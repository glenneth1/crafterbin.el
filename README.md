# crafterbin.el

An Emacs package for uploading text and files to [crafterbin.glennstack.dev](https://crafterbin.glennstack.dev), a pastebin-like service.

## Overview

crafterbin.el provides a simple interface to upload text snippets or entire files to the CrafterBin service. It allows you to quickly share code snippets, configuration files, or any text content with others.

## Requirements

- Emacs 24.3 or later
- curl (must be installed and available in your PATH)

## Installation

### Manual Installation

1. Download `crafterbin.el` to a directory in your load-path
2. Add the following to your Emacs configuration:

```elisp
(require 'crafterbin)
```

### Using use-package

```elisp
(use-package crafterbin
  :load-path "/path/to/crafterbin.el"
  :commands (crafterbin-upload crafterbin-upload-file crafterbin-upload-region))
```

## Usage

### Interactive Commands

- `M-x crafterbin-upload`: If region is active, uploads the selected region. Otherwise, prompts for a file to upload.
- `M-x crafterbin-upload-file`: Prompts for a file to upload.
- `M-x crafterbin-upload-region`: Uploads the currently selected region.
- `M-x crafterbin-check-curl`: Checks if curl is available in your system.

### Example Key Bindings

Add these to your Emacs configuration:

```elisp
(global-set-key (kbd "C-c C-p") 'crafterbin-upload)
(global-set-key (kbd "C-c C-f") 'crafterbin-upload-file)
```

## Customization

You can customize the CrafterBin service URL:

```elisp
(setq crafterbin-url "https://crafterbin.glennstack.dev")
```

## How It Works

When you upload content to CrafterBin:

1. The text is sent to the CrafterBin service using curl
2. Upon successful upload, the URL of the paste is copied to your clipboard
3. A message with the URL is displayed in the minibuffer

## License

This project is maintained by Glenn Thompson.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request on [Codeberg](https://codeberg.org).
