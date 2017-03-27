#!/bin/bash

./diag 2 200 0.75 diag1
./plot.R diag1.data

./diag 2 5000 0.50 diag2
./plot.R diag2.data

./vert 2 200 0.75 vert1
./plot.R vert1.data

./vert 2 5000 0.50 vert2
./plot.R vert2.data

./spiral 200 spiral1
./plot.R spiral1.data

./spiral 5000 spiral2
./plot.R spiral2.data
