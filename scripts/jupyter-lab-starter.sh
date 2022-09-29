#!/bin/bash

# initialize anaconda
cinit

echo "Enter (1) for ~/Documents/projects/ "
echo "or (2) for ~/Documents/school/cmda3605/"
echo "or (3) for ~/Documents/school/cmda3634/"
echo "or (4) for ~/Documents/school/cmda3654/"
echo "or (5) for ~/Documents/python"
read usr_input

if [ $usr_input -eq 1 ] ; then
    cd ~/Documents/projects

elif [ $usr_input -eq 2 ] ; then
    cd ~/Documents/school/cmda3605

elif [ $usr_input -eq 3 ] ; then
    cd ~/Documents/school/cmda3634

elif [ $usr_input -eq 4 ] ; then
    cd ~/Documents/school/cmda3654
elif [ $user_input -eq 5]; then
    cd ~/Documents/python
fi

# conda activate

jupyter lab
