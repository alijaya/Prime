haxelib install mlib
alias mlib="haxelib run mlib"

for lib in prime-*; do
	cd $lib
	mlib i -no-source-license
	cd ..
done
