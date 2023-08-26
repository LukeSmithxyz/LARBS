#!/bin/bash
# Provide a list of packages you want to have installed in a file named install.txt where every line is a package.
aur=$(pacman -Qm)
while read package; do
	desc=$(pacman -Q --info $package | grep Description | cut -d ":" -f2) || true
	desc="${desc:1}"
	flag=""
	if pacman -Qm $package &> /dev/null; then
		flag=A
	fi
	echo $flag,$package,\"$desc.\" >> procs.csv
done < install.txt
