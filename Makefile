prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --arch arm64 --arch x86_64 --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/apple/Products/Release/osx-ca-bundler" "$(bindir)"

uninstall:
	osx-ca-bundler uninstall
	rm -rf "$(bindir)/osx-ca-bundler"

clean:
	rm -rf .build

.PHONY: build install uninstall clean