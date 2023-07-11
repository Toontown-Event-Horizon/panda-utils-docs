#!/usr/bin/env bash

ws() {
	python -m http.server -d build/html
}

we1() {
	watchexec -rpe rst,py -i index.rst -i source/generated make html
}

we2() {
	watchexec -rpf source/index.rst -f source/conf.py make clean html
}

make clean html
(trap 'kill 0' SIGINT; ws & we1 & we2)
