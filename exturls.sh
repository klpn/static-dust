#!/bin/sh
mkdir -p fonts
mkdir -p mathjax
curl -o merriweather-v18-latin.zip "https://google-webfonts-helper.herokuapp.com/api/fonts/merriweather?download=zip&subsets=latin&variants=700,regular,italic,700italic"
curl -o MathJax-2.7.2.zip https://codeload.github.com/mathjax/MathJax/zip/2.7.2
unzip merriweather-v18-latin.zip -d fonts
unzip MathJax-2.7.2.zip -d mathjax 
