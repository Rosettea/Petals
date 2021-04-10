# Petals
> *The* plugin manager for Hilbish.

Petals is the official Hilbish plugin manager. It exposes both an API to
load plugins and start them and the single `petals` command to
manage them interactively.

Petals is not in a stable state (like Hilbish) so use with caution!

## Requirements
- Hilbish `master` branch
> Petals uses new functions from the `fs` library that aren't in the
latest release.

## Installation
Clone this repository to one of the paths Hilbish looks for libaries at.
A good, standard path is `.local/share/hilbish/libs`:  
```
git clone https://github.com/Hilbis/Petals ~/.local/share/hilbish/libs/petals
```

## Usage
Require in your `.hilbishrc.lua` and initialize:
```lua
petals = require 'petals'
petals.init()
```

Then load your plugins:
```lua
petals.load 'Hilbis/SamplePetal'
```

In interactive mode (the shell),  
1. Install them with the `petals install` command
2. and `petals.start()`!

## Notes
- Petals is inspired by vim plugin managers,
namely [vim-plug](https://github.com/junegunn/vim-plug) and
[packer.nvim](https://github.com/wbthomason/packer.nvim)
- Also by [zplug](https://github.com/zplug/zplug)
- It's called petals since the name Hilbish comes from Hibiscus
(flower stuff yeee)

## License
Petals is licensed under the BSD 3-clause license.  
[Read here](LICENSE) for more info.
