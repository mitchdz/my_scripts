#!/bin/bash

release="jammy"

help() {
	echo "Run it like so: $0 -b <package name> -r <Ubuntu release adjective> -p <The ppa location e.g. (ppa:lvoytek/runc-fix-dev-in-containers) (optional - without it will run against the release package version)>"
}


while getopts hr:p:b: flag
do
    case "${flag}" in
        r) release=${OPTARG};;
        p) ppa=${OPTARG};;
        b) package=${OPTARG};;
	h) help; exit 0;;
    esac
done

if [ -z "$package" ]; then
    echo "Enter a package name with the -b flag"
    exit 1
fi

rm -rf "dep8-${package}"

if [ -z "$ppa" ]; then
    autopkgtest -U -s -o "dep8-${package}" -B ${package} -- qemu "/var/lib/adt-images/autopkgtest-${release}-amd64.img"
else
    autopkgtest -U -s -o "dep8-${package}" --setup-commands="sudo add-apt-repository -y -u -s ${ppa}" -B ${package} -- qemu "/var/lib/adt-images/autopkgtest-${release}-amd64.img"    
fi
