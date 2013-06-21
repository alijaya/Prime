#!/bin/bash

TPLDIR="$1"

set -e

cd "`dirname $0`/.."

for lib in prime*; do
  ARGS=""
  for p in cpp cs java js neko php swf; do if [ -f "docs/$lib-$p.xml" ]; then
    ARGS="$ARGS -f docs/$lib-$p.xml,$p";
  fi; done;

  if [ -n "$ARGS" ]; then
    chxdoc -o docs/output/api/$lib --generateTodo=true --templatesDir=$TPLDIR/templates/ --deny flash.* --deny js.* --deny cpp.* --deny cs.* --deny java.* --deny php.* --deny mcover.* $ARGS
  fi;
done;


