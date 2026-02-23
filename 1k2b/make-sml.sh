#!/bin/sh
pasmo -d --alocal main.asm 1k2b.bin
./smloadgen 1k2b.bin 0x4000
./smlfilegen 1k2b.bin 0x4000
