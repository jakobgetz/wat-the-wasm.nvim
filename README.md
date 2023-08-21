# wat-the-wasm.nvim

Expolore WebAssembly Text. View WebAssembly Text how it gets assembled to WebAssembly.

## Install

```lua
{ "jakobgetz/wat-the-wasm.nvim" }
```
This plugins makes use of the [WABT: The WebAssembly Binary Toolkit](https://github.com/WebAssembly/wabt). Make sure it is installed.

## Setup
```lua
require "wat-the-wasm".setup()
```

## Use

Use these commands on your `.wat` files to explore the assembler.
```
:Wat2Wasm     -- display WebAssembly Text as WebAssembly Binary
:Wasm2Wat     -- display WebAssembly Binary as WebAssembly Text
:WatTheWasm   -- display WebAssembly Text as WebAssembly Binary with verbose Information
:WatToggle    -- toggle between WebAssembly Text, Verbose WebAssembly Binary and WebAssembly Text that gets generated from the Binary
```

## Config
So far wat-the-wasm has no configuration options.

## Contributing
Pull requests are always welcome!
