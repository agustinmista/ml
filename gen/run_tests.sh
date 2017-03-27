#!/bin/bash

./diag 2 2000 0.75 diag
./plot.R diag.data

./vert 2 1000 0.50 vert
./plot.R vert.data
