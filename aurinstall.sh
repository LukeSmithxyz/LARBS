#!/bin/bash

qm=$(pacman -Qm | awk '{print $1}')

instcheck() {
if [[ $qm = *"$1"* ]]; then
	echo $1 already installed.
else
	aurinstall $1
fi
}
instcheck $1

#for prog in "$@"
#do
	#(pacman -Qm | grep $prog ) || echo "not"
#done

