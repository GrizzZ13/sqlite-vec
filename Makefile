.DEFAULT_GOAL:=loadable
COMMIT=$(shell git rev-parse HEAD)
VERSION=$(shell cat VERSION)
DATE=$(shell date +'%FT%TZ%z')

ifeq ($(shell uname -s),Darwin)
    output=dist/libvec.dylib
else ifeq ($(shell uname -s),Linux)
    output=dist/libvec.so
else
    $(error Unsupported OS: $(shell uname -s))
endif

dist:
	mkdir -p dist

loadable: sqlite-vec.c sqlite-vec.h dist
	gcc \
		-fPIC -shared \
		-Ivendor/include \
		-Lvendor/lib \
		-Wall -Wextra \
		-O3 \
		$< -o $(output)

loadable-debug: sqlite-vec.c sqlite-vec.h dist
	gcc \
		-g \
		-fPIC -shared \
		-Ivendor/include \
		-Lvendor/lib \
		-Wall -Wextra \
		-DDEBUG \
		-O3 \
		$< -o $@

sqlite-vec.h: sqlite-vec.h.tmpl VERSION
	VERSION=$(shell cat VERSION) \
	DATE=$(shell date -r VERSION +'%FT%TZ%z') \
	SOURCE=$(shell git log -n 1 --pretty=format:%H -- VERSION) \
	envsubst < $< > $@

clean:
	rm -rf dist