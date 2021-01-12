WASI_SDK = ~/wasi-sdk/wasi-sdk-11.0

.PHONY: build
build:
	$(WASI_SDK)/bin/clang --sysroot $(WASI_SDK)/share/wasi-sysroot -c lib0.c -o lib0.o
	wasm-validate --enable-all lib0.o # 少なくとも--enable-bulk-memoryが必要
	$(WASI_SDK)/bin/clang --sysroot $(WASI_SDK)/share/wasi-sysroot -c lib1.c -o lib1.o
	wasm-validate --enable-all lib1.o # 同様

	$(WASI_SDK)/bin/ar qc liblib.a lib0.o lib1.o
	$(WASI_SDK)/bin/ranlib liblib.a

	$(WASI_SDK)/bin/clang --sysroot $(WASI_SDK)/share/wasi-sysroot main.c -L. -llib -o a.wasm
	wasm-validate a.wasm

.PHONY: clean
clean:
	rm lib0.o
	rm lib1.o
	rm liblib.a
	rm a.wasm
