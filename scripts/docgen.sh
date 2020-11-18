#!/usr/bin/env sh

./to_vimdoc.sed ../README.md | fmt -s | ./sections_tags.awk > ../doc/nvim-lua-guide.txt
./to_vimdocja.sed ../README.ja.md | fmt -s | ./sections_tags.awk > ../doc/nvim-lua-guide.jax
