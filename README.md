# AlpsNMR-Tutorial <img src='AlpsNMRlogo.png' align="right" height="139" />

Extended tutorial of [AlpsNMR](https://bioconductor.org/packages/release/bioc/html/AlpsNMR.html) in large dataset

For this tutorial you will need install the `AlpsNMR` package

## Installation
```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("AlpsNMR")
```

You can download needed data executing included [download_demo()](https://github.com/sipss/AlpsNMR-Tutorial/blob/main/download_demo.R) function

Follow the [tutorial](https://github.com/sipss/AlpsNMR-Tutorial/blob/main/Tutorial.pdf) to execute `AlpsNMR` in a real dataset from beginning to end,
including all the steps of untargeted metabolomics analysis.
