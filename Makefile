duck:
	mkdir -p build
	jsduck --config=doc/config.json --output=build `find . -name \*.js | grep -v -x ./bin/npm2nix.js`

doc: duck # DUH!!

clean:
	rm -rf build
