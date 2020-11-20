# gemini-mode

Emacs major mode for working with the [text/gemini file
type](https://gemini.circumlunar.space/docs/specification.html).

This is still in major development, and is not feature complete.

## "Quick" start 

Gemini-mode is not yet MELPA available.

You must clone this repository to install it locally:

`git clone https://github.com/matt-y/gemini-mode.git`

After the repository is cloned, you must add it to your `load-path`
within Emacs, and then use `require` to load `gemini-mode` from your
`load-path`. The following configuration will perform these tasks:

``` emacs-lisp
(add-to-list 'load-path "/my/path/to/cloned/gemini-mode-repo")
(require 'gemini-mode)
```

You will need to modify the second argument to `add-to-list` in the
above snippet with the location of the cloned `gemini-mode` repository.

After this initial set up, any files with a `.gemini` or `.gmi`
extensions will enjoy the `gemini-mode` major mode automatically.

## Development 

Hacking on `gemini-mode` is /relatively/ easy!

`gemini-mode` uses the [Cask elisp project
management](https://cask.readthedocs.io/en/latest/index.html) tool to
manage development dependencies and (eventually) packaging. To work on
`gemini-mode` you will need to install Cask. [Instructions for
installing can be found
here](https://cask.readthedocs.io/en/latest/guide/installation.html).

### Testing 

`gemini-mode` uses the [emacs-buttercup test
framework](https://github.com/jorgenschaefer/emacs-buttercup).

To run the test suite, navigate to the project root containing our
`Cask` file, and run the following command in the terminal:

```sh
cask exec buttercup -L .
```

### Submitting Issues 

Please submit issues if you encounter any issues or unexpected behavior
in `gemini-mode`. 

When making an issue, please be as descriptive as possible. Providing a
minimally reproducible test case of your issue is highly appreciated. A
sample buffer, along with steps to reproduce is wonderful. 

### Submitting Code 

If you're keen on fixing something, that's great! If an issue is
relatively self contained then go ahead and make a PR. 

For changes that are substantial, please open an issue to discuss
changes you would like to make prior to starting work. This cuts down on
wasted effort in the event the change cannot be merged for whatever reason.

## License 

`gemini-mode` is available under the GNU General Public License
version 3. [A copy can be found here](LICENSE).



