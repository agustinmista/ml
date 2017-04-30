#!/bin/bash

echo "+==============================================================================+"
echo "|                                Ejercicio (a)                                 |"
echo "+==============================================================================+"
./diagonal 2 200 0.75 diagonal1
echo "+------------------------------------------------------------------------------+"
./plot.R diagonal1.data
echo "+==============================================================================+"
./diagonal 2 5000 0.50 diagonal2
echo "+------------------------------------------------------------------------------+"
./plot.R diagonal2.data
echo "+==============================================================================+"

echo "+==============================================================================+"
echo "|                                Ejercicio (b)                                 |"
echo "+==============================================================================+"
./parallel 2 200 0.75 parallel1
echo "+------------------------------------------------------------------------------+"
./plot.R parallel1.data
echo "+==============================================================================+"
./parallel 2 5000 0.50 parallel2
./plot.R parallel2.data
echo "+==============================================================================+"
echo "|                                Ejercicio (c)                                 |"
echo "+==============================================================================+"
./spiral 200 spiral1
echo "+------------------------------------------------------------------------------+"
./plot.R spiral1.data
echo "+==============================================================================+"
./spiral 5000 spiral2
echo "+------------------------------------------------------------------------------+"
./plot.R spiral2.data
echo "+==============================================================================+"
