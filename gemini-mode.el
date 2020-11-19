;;; gemini-mode.el --- Major mode for working with gemini protocol files -*- lexical-binding: t; -*-
;;; Version: 0.0.1
;;; Commentary:
;;; soon

;;; Code:

(require 'thingatpt)

;;; Constants

(defconst gemini-mode-version "0.0.1"
  "The version number for Gemini mode.")

;;; Regular Expressions

(defconst gemini--regex-header
  "^\\(?1:#+[ \t]+\\)\\(?2:.*?\\)\\(?3:[ \t]*\\)$"
  "Regular expression for a Section Title (Heading).

Capture group layout:
1. Matches the leading # characters and spaces
2. Matches the contents of the heading
3. Matches any trailing whitespace")

(defconst gemini--regex-blank-line
  "\n\\s-*\n"
  "Regular expression for a blank line.")

;;; Syntax


;;; Helper functions and macros

(defun gemini--compress-whitespace (s)
  "Replace multiple instances of tabs, spaces, or newlines in S
with a single space."
  (replace-regexp-in-string "[ \t\n]+" " " s))

(defun gemini--s-trim-right (s)
  "Remove whitespace at the end of S."
  (if (string-match "[ \t\n\r]+\\'" s)
      (replace-match "" t t s)
    s))

(defun gemini--ensure-blank-line-before-point ()
  "Ensure an empty line preceeds the point. Does not preserve
point. Intended to create space between existing lines and
something that is being inserted. The point is not preserved here
because this is intended to preceed the insertion of some text."
  ;; Immediate newline is required if point is mid-line
  (unless (bolp)
    (newline))
  ;; Newline required if not at the begging of a buffer or immediately preceeded
  ;; by an existing newline
  (unless (or (bobp) (looking-back gemini--regex-blank-line nil))
    (newline)))

(defun gemini--ensure-blank-line-after-point ()
  "Ensure a blank line follows point. Preserves point.
Intended to 'push' any non-blank-lines 'downwards' after the
insertion of something to ensure space between what was just
inserted and the lines of text that follow what was inserted. The
point is being preserved because the point needs to remain next
to what was inserted prior to the invocation of this function."
  (save-excursion
    ;; Immediate new line required if point is mid-line
    (unless (eolp)
      (newline))
    ;; Newline required if not at the end of buffer or if the point
    (unless (or (eobp) (looking-at-p gemini--regex-blank-line))
      (newline))))

(defun gemini-header-level-at-point (&optional p)
  "Determine the header level at point.
P is an optional argument that represents a point at which to
begin a search. P must be a number. If P is not provided,
defaults to the value of a call to `point'. Uses
`re-search-backward' to find a match. Returns a number from 1 to
6 representing the level of nesting at point or P respectively.
Internally the function relies on the match groups defined by
`gemini--regex-header'."
  (save-excursion
    (goto-char (or p (point)))
    ;; If the point is inside a heading - move it to the end of the
    ;; heading, and continue as normal
    (if (thing-at-point-looking-at gemini--regex-header)
	(move-end-of-line nil))
    ;; The level defaults to 1; if no match is found, the point is at
    ;; "top level".
    (let ((level 1))
      ;; If a match was found for a previous heading, examine the heading
      ;; capture group for the heading markup to determine the level.
      (when (re-search-backward gemini--regex-header nil t)
        ;(debug)
        (let* ((header-markup (match-string-no-properties 1))
               (trimmed-header-markup (gemini--s-trim-right header-markup)))
          ;(debug)
          (setq level (length trimmed-header-markup))))
      level)))

;;; Insertions

(defun gemini--insert-with-blank-lines-surrounding (text)
  "Insert TEXT and ensures the inserted text is preceeded by an
empty line, and also followed by an empty line. Point is moved to
after the inserted text."
  (gemini--ensure-blank-line-before-point)
  (insert text)
  (gemini--ensure-blank-line-after-point))

(defun gemini-insert-header-auto ()
  "Insert a setion title. Does not preserve point.

The level of the heading is determined by the surrounding context
of the document, specifically: the level of the previous heading
will be used for the level of the heading being inserted.

The text of the heading is provided by multiple means. If an
active region exists, the text from the region will be used as
heading text. If no active region exists, but the point is on a
line that is not a heading, that line is used as the heading
text.

Blank lines will cause only heading markup to be inserted and the
point moved to the relevant position. Trying to insert a heading
when the point is on a line of an existing section title will
move the point to pthe end of the heading.

Headings will always be followed by a newline, one will be
inserted if the heading inserted is not already followed by a
newline. if the preceeding line is not empty, a newline will also
be inserted above the heading."
  (interactive "*")
  (let ((level (gemini-header-level-at-point))
        (text ""))
    (if (use-region-p)
        ;; Use the active region contents if available
        (setq text (delete-and-extract-region (region-beginning) (region-end)))

      ;; If the active region is not available, and the point is on a header,
      ;; unwrap it before trying to use the whole line as header text.
      (when (thing-at-point-looking-at gemini--regex-header)
        (gemini-unwrap-header-at-point))
      ;; Use the whole line as header text
      (setq text (delete-and-extract-region
                  (line-beginning-position) (line-end-position))))
    (let* ((header-markup (make-string level ?#))
           ;; Ensure that text doesn't contain wacky whitespace
           (whitespace-compressed-text (gemini--compress-whitespace text))
           (header-text (concat header-markup " " whitespace-compressed-text)))
      (gemini--insert-with-blank-lines-surrounding header-text))))

;;; Removals

(defun gemini-unwrap-header-at-point ()
  "When point is at a header, do a backwards regex search to set
the match data. Once the match data is set, replace the markup
portion of the header capture group with the empty string. This
has the effect of 'unwrapping' the header, or turning the header
text into regular text."
  (save-excursion
    ;; First, sanity check that point is at a header
    (when (thing-at-point-looking-at gemini--regex-header)
      ;; Set match data, limiting search to the beginning of the line that point
      ;; is on
      (replace-match "" t t nil 1))))

;;; Mode Definition

(defun gemini-mode-show-version ()
  "Output version number in minibuffer."
  (interactive)
  (message "gemini-mode version %s" gemini-mode-version))

(defconst gemini-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-h") 'gemini-insert-header-auto)
    map))

(easy-menu-define gemini-mode-menu gemini-mode-map
  "Menu for gemini-mode interactive actions"
  '("Gemini"
    ("Insert"
     ["Heading Auto" gemini-insert-header-auto])))

(define-derived-mode gemini-mode text-mode "Gemini"
  "Major mode for Gemini files.")

(add-to-list 'auto-mode-alist
             '("\\.\\(?:gemini\\|\\(?:gmi\\)\\)" . gemini-mode))

(provide 'gemini-mode)

;;; gemini-mode.el ends here
