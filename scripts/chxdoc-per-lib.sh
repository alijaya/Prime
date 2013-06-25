#!/bin/bash

set -e

cd "`dirname $0`/.."

for lib in prime*; do
  ARGS=""
  for p in cpp cs java js neko php swf; do if [ -f "docs/$lib-$p.xml" ]; then
    ARGS="$ARGS -f docs/$lib-$p.xml,$p";
  fi; done;

  if [ -n "$ARGS" ]; then
    chxdoc --generateTodo=true                                                                         \
    	"--title=$lib API docs" "--subtitle=http://prime.vc"                                           \
    	-o docs/output/api/$lib                                                                        \
    	--templatesDir=./docs/theme/ --template prime-chxdoc                                           \
    	--deny flash.* --deny js.* --deny cpp.* --deny cs.* --deny java.* --deny php.*                 \
    	--deny Main --deny mcli.* --deny mcover.* \
    	$ARGS;
  fi;
done;


