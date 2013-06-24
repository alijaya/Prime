#!/bin/bash
NAME=`basename "\`pwd\`"`;
rm  -f "$NAME.zip"
zip -r "$NAME.zip" haxelib.json src/
