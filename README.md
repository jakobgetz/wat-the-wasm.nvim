# wat-the-wasm.nvim

Expolore WebAssembly Text. View WebAssembly Text how it is assembled to WebAssembly.

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
:Wat2Wasm     -- display WebAssembly Text as WebAssembly binary
:Wat2Wat      -- display WebAssembly Text, with the information the WebAssembly binary contains
:WatTheWasm   -- display WebAssembly Text as WebAssembly binary with verbose information
:WatRevert    -- revert back to the original WebAssembly Text
```

## Config
So far wat-the-wasm has no configuration options.

## Contributing
Pull requests are always welcome!
