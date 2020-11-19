# gemini-mode

Emacs major mode for working with the [text/gemini file
type](https://gemini.circumlunar.space/docs/specification.html).

This is still in major development, and is not feature complete.

## "Quick" start 

Gemini-mode is not yet MELPA available.

You must clone this repository to install it locally:

`git clone https://github.com/matt-y/gemini-mode.git`

After the repository is cloned, you must add it to your `load-path`
within emacs, and then use `require` to load `gemini-mode` from your
`load-path`. The following configuration will perform these tasks:

``` emacs-lisp
(add-to-list 'load-path "/my/path/to/cloned/gemini-mode-repo")
(require 'gemini-mode)
```

You will need to modify the second argument to `add-to-list` in the
above snippet with the location of the cloned `gemini-mode` repository.

After this initial set up, any files with a `.gemini` or `.gmi`
extensions will enjoy the `gemini-mode` major mode automatically.
