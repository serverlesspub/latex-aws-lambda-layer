PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

DOCKER_IMAGE ?= lambci/lambda-base-2:build
TARGET ?=/opt/

MOUNTS = -v $(PROJECT_ROOT):/var/task \
	-v $(PROJECT_ROOT)result:$(TARGET)

DOCKER = docker run -it --rm -w=/var/task/build
build result cache: 
	mkdir $@

clean:
	rm -rf build result cache

bash:
	$(DOCKER) $(MOUNTS) --entrypoint /bin/bash -t $(DOCKER_IMAGE)

all: build result cache 
	$(DOCKER) $(MOUNTS) --entrypoint /usr/bin/make -t $(DOCKER_IMAGE) TARGET_DIR=$(TARGET) -f ../Makefile_Latex $@

example.pdf: 
	docker run -it --rm $(MOUNTS) \
		-w=/var/task/test \
		--env PATH=/opt/texlive/bin/x86_64-linux:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
		--entrypoint /opt/texlive/bin/x86_64-linux/pdflatex \
		$(DOCKER_IMAGE) example.latex

STACK_NAME ?= latex-layer 

#result/texlive/bin/x86_64-linux/pdflatex: all

build/layer.zip: result/texlive/bin/x86_64-linux/pdflatex build
	# CloudFormation has trouble zipping texlive due to nested directory dept
	#
	# This is why we zip outside
	
	cd result && zip -ry $(PROJECT_ROOT)$@ *

build/output.yaml: template.yaml build/layer.zip
	aws cloudformation package --template $< --s3-bucket $(DEPLOYMENT_BUCKET) --output-template-file $@

deploy: build/output.yaml
	aws cloudformation deploy --template $< --stack-name $(STACK_NAME)
	aws cloudformation describe-stacks --stack-name $(STACK_NAME) --query Stacks[].Outputs --output table

deploy-example:
	cd example && \
		make deploy DEPLOYMENT_BUCKET=$(DEPLOYMENT_BUCKET) LATEX_STACK_NAME=$(STACK_NAME)
