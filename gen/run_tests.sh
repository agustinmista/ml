#!/bin/bash

./diag 2 2000 0.75 diag.data
./plot.R diag.data

./vert 2 1000 0.50 vert.data
./plot.R vert.data

./spiral 5000 spiral.data
./plot.R spiral.data
