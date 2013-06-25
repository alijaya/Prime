#!/bin/bash


control_c()
# run if user hits control-c
{
  echo -en "\n*** Ouch! Exiting ***\n"
  exit $?
}
 
# trap keyboard interrupt (control-c)
trap control_c SIGINT


cd "`dirname $0`/..";

haxelib install hxjava
haxelib install hxcpp
haxelib install munit

for lib in prime*; do
  cd $lib;
  if [[ "prime" == "$lib" ]]; then
    COVERAGE="mcover.MCover.coverage(['prime'],['src','../prime-bindable/src', '../prime-components/src', '../prime-core/src', '../prime-css/src', '../prime-data/src', '../prime-display/src', '../prime-fsm/src', '../prime-layout/src', '../prime-media/src', '../prime-mvc/src', '../prime-signals/src'],[''])"
  else
    COVERAGE="mcover.MCover.coverage(['prime'],['src'],[''])"
  fi;

  for target in js swf cpp neko java cs php; do
    echo "- Compiling $lib xml for: $target"
    haxe prime.hxml "-${target}" none --no-output -xml ../docs/$lib-$target.xml  -lib mcover -D MCOVER --macro "$COVERAGE" -swf-version 12 -swf-lib ../assets/debug-assets.swf;
  done;
  cd ..;
done
