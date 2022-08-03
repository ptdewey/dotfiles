#!/bin/bash

cinit

echo "Enter (1) for ~/Documents/python/ "
echo "or (2) for ~/Documents/school/CMDA3605/"
echo "or (3) for ~/Documents/school/CMDA3634/"
echo "or (4) for ~/Documents/school/CMDA3654/"
read usr_input

if [ $usr_input -eq 1 ] ; then
    cd ~/Documents/python

elif [ $usr_input -eq 2 ] ; then
    cd ~/Documents/school/CMDA3605

elif [ $usr_input -eq 3 ] ; then
    cd ~/Documents/school/CMDA3634

elif [ $usr_input -eq 2 ] ; then
    cd ~/Documents/school/CMDA3654
fi

# conda activate

jupyter notebook
