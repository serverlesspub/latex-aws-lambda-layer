# TeX Live (latex/pdflatex) for AWS Lambda

TeX Live (including `latex` and `pdflatex`) for AWS Lambda, including packages and fonts required for Pandoc.

Intended for instances powered by Amazon Linux 2.x, such as the `nodejs10.x` runtime, and the updated 2018.03 Amazon Linux 1 runtimes.

The binaries will be in `/opt/texlive/bin/x86_64-linux` after linking the layer to a Lambda function. *Binaries depend on each other, so when executing, you will need to add that directory to your `PATH` environment variable*.

```
pdfTeX 3.14159265-2.6-1.40.20 (TeX Live 2019)
kpathsea version 6.3.1
Compiled with libpng 1.6.36; using libpng 1.6.36
Compiled with zlib 1.2.11; using zlib 1.2.11
Compiled with xpdf version 4.01
```

Note that this distribution comes with minimal fonts ([lm](https://ctan.org/pkg/lm?lang=en), [amsfonts](https://ctan.org/pkg/amsfonts?lang=en) and [ec](https://ctan.org/pkg/ec?lang=en)), required for Pandoc. To add more fonts, modify the build profile from <https://github.com/serverlesspub/latex-aws-lambda-layer/>.

For an example of how to use the layer, check out 
<https://github.com/serverlesspub/latex-aws-lambda-layer/example>.
