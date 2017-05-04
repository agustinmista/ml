#!/bin/bash

./train_spiral.sh

./train_diagonal_sized.sh
./train_parallel_sized.sh
./plot_sized_error.R datasets/diagonal_sized/diagonal.error.avg datasets/parallel_sized/parallel.error.avg
./plot_sized_size.R datasets/diagonal_sized/diagonal.size.avg datasets/parallel_sized/parallel.size.avg

./train_diagonal_noise.sh
./train_parallel_noise.sh
./plot_noise_error.R datasets/diagonal_noise/diagonal.error.avg datasets/parallel_noise/parallel.error.avg

./train_diagonal_dimmed.sh
./train_parallel_dimmed.sh
./plot_dimmed_error.R datasets/diagonal_dimmed/diagonal.error.avg datasets/parallel_dimmed/parallel.error.avg

./run_xor.R datasets/xor/xor.data
