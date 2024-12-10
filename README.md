Sjasm Z80 Assembler 0.42c
=========================
Sjasm is a Z80 assembler originally developed by Sjoerd Mastijn. It is available to download, sources included, at site [XL2S Entertainment](http://xl2s.tk/).


#### Configure and build:

`cmake -S . -B build`

`cmake --build build`


#### Alternative configuration and build (using Ninja):
`cmake -Wno-dev --fresh -B build -G Ninja`

`ninja -C build`
