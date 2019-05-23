# TeX Live (LaTeX/pdflatex) for AWS Lambda

TeX Live (including `latex` and `pdflatex`) for AWS Lambda, including packages and fonts required for Pandoc.

Intended for instances powered by Amazon Linux 2.x, such as the `nodejs10.x` runtime, and the updated 2018.03 Amazon Linux 1 runtimes

## WORK IN PROGRESS!!!

Note that this is work in progress, not ready for public usage yet. TeX Live requires a functioning `perl` executable, even at runtime, and this layer does not include that. 

## Usage

After deployment, the binaries will be in `/opt/texlive/bin/x86_64-linux` after linking the layer to a Lambda function. 

Binaries depend on each other, so when executing, you will need to add that directory to your `PATH` environment variable.

## Prerequisites

* Docker desktop
* Unix Make environment
* AWS command line utilities (just for deployment)

## Compiling the code

* start Docker services
* `make all`

There are two `make` scripts in this project.

* [`Makefile`](Makefile) is intended to run on the build system, and just starts a Docker container matching the AWS Linux 2 environment for Lambda runtimes to compile Latex using the second script.
* [`Makefile_Latex`](Makefile_Latex) is the script that will run inside the container, and actually compile binaries. 

The output will be in the `result` dir.

### Configuring the build

By default, this compiles a version expecting to run as a Lambda layer from `/opt/texlive`. Change the expected runtime location in [`texlive.profile`](texlive.profile).

The default Docker image used is `lambci/lambda-base-2:build`. To use a different base, provide a `DOCKER_IMAGE` variable when invoking `make`.

You can include/exclude collections from [`texlive.profile`](texlive.profile), or change the CTAN packages installed in addition to the minimal collection in [`Makefile_Latex`](Makefile_Latex).

Note that this distribution comes with minimal fonts ([lm](https://ctan.org/pkg/lm?lang=en), [amsfonts](https://ctan.org/pkg/amsfonts?lang=en) and [ec](https://ctan.org/pkg/ec?lang=en)) required for Pandoc. To add the full recommended font set, enable `collection-fontsrecommended` in [`texlive.profile`](texlive.profile).

### Experimenting

* `make bash` to open an interactive shell with all the build directories mounted

### Compiled info

```
pdfTeX 3.14159265-2.6-1.40.20 (TeX Live 2019)
kpathsea version 6.3.1
Compiled with libpng 1.6.36; using libpng 1.6.36
Compiled with zlib 1.2.11; using zlib 1.2.11
Compiled with xpdf version 4.01
```

## Deploying to AWS as a layer

Run the following command to deploy the compiled result as a layer in your AWS account.

```
make deploy DEPLOYMENT_BUCKET=<YOUR BUCKET NAME>
```

### configuring the deployment

By default, this uses `latex-layer` as the stack name. Provide a `STACK_NAME` variable when
calling `make deploy` to use an alternative name.

### example usage

An example project is in the [example](example) directory. It sets up two buckets, and listens to file uploads on the first bucket to convert and generate HTML files from markdown. You can deploy it from the root Makefile using:

```
make deploy-example DEPLOYMENT_BUCKET=<YOUR BUCKET NAME>
```

For more information, check out:

* general install process: <https://www.tug.org/texlive/quickinstall.html>
* profile variables: <https://wiki.archlinux.org/index.php/TeX_Live>
* required packages for pandoc: <https://pandoc.org/MANUAL.html>

## Author

Gojko Adzic <https://gojko.net>

## License

* These scripts: [MIT](https://opensource.org/licenses/MIT)
* TeX Live: <https://www.tug.org/texlive/copying.html>
* LaTeX: <https://www.latex-project.org/lppl.txt>
* Contained libraries all have separate licenses, check the respective web sites for more information
