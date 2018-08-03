## Hello World

The minimal incr_dom app.

Build: `dune build src/{hello_world.bc.js,hello_world.html}`
Size: 11MB

Remove dead code in bytecode: `ocamlclean -verbose -o hello_world.opt.bc hello_world.bc`
Fatal error: exception Stack overflow

Google closure simple:
java -jar ~/bin/closure-compiler-v20180716.jar \
    --compilation_level=SIMPLE \
    --js=hello_world.bc.js \
    --js_output_file=hello_world.opt.bc.js
Size: 2.5MB

Google closure advanced:
java -jar ~/bin/closure-compiler-v20180716.jar \
    --compilation_level=ADVANCED \
    --js=hello_world.bc.js \
    --js_output_file=hello_world.opt.bc.js
Failed

## Simple counter

Minimal interaction, click a button to increment counter.

Build: `dune build src/{simple_counter.bc.js,simple_counter.html}`
