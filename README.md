# gemini-mode

Emacs major mode for working with the [text/gemini file
type](https://gemini.circumlunar.space/docs/specification.html).

This is still in major development, and is not nearly feature
complete. This started as a way to learn a bit more about emacs and
practice some elisp. If we get a fun mode out of it, all the better.

## Roadmap 

The immediate roadmap of things that are yet to be done is below. Font
lock/syntax highlighting for these various things is also something that
will be added incrementally throughout - once I figure out how it works,
at least.

- Header subtree promotion/demotion
- Link lines 
- Preformatted text blocks 
- Unordered lists 
- Quote lines 

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

## Using `gemini-mode` 

### Heading Lines 

Heading lines are the bread-and-butter of any gemini file. `gemini-mode`
allows you to insert them in a manner that will "match" your current
heading level, or at a specific markup level. 

The text of the heading is provided by multiple means. 

If an active region exists, the text from the region will be used as
heading text. If no active region exists, but the point is on a line
that is not a heading, that line is used as the heading text. An active
region can span multiple lines, the whitespace will be "collapsed" so
that the heading will be a single "line".

Inserting a heading over an existing heading will be a no-op unless
you're commanding the level to change. Very bossy!

Inserting a heading on a blank lines will cause only heading markup to
be inserted and the point moved to a place where you can start
typing. Trying to insert a heading when the point is on a line of an
existing section title will move the point to the end of the heading.

Headings will always be followed by a newline, and one will mercifullybe
inserted if the heading you are creating is not already followed by a
newline. If the preceeding line is not empty, a newline will _also_ be
inserted above the heading. 

Both the "auto" and "specific level" heading insertion functions follow
the above "algorithm".

#### Matching the current heading level 

- **C-c g h** will insert a heading that automatically detects the level
of the heading that preceeds it. This functionality is provided through
the `gemini-insert-heading-auto` function.

#### Inserting a heading at a specific level

- **C-c g M-h 1** Inserts a level one heading; functionality provided
  through the `gemini-insert-heading-level-1` function
- **C-c g M-h 2** Inserts a level two heading; functionality provided
  through the `gemini-insert-heading-level-2` function
- **C-c g M-h 3** Inserts a level three heading; functionality provided
  through the `gemini-insert-heading-level-3` function


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



