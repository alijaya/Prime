#!/bin/bash

cd `dirname "$0"/..`

alias munit="haxelib run munit"

for lib in prime*; do
	cd $lib
	munit test $@;
	cd ..
done
