;;; gemini-mode--header-insert-tests.el -*- lexical-binding: t; -*-

;;; Commentary:

;; Tests related to header insertion in gemini mode
;;
;; This file is part of gemini-mode

;;; Code:

(require 'buttercup)
(require 'gemini-mode)

(describe "gemini-header-level-at-point"
	  (it "Provides a default level of 1 with an empty buffer"
	      (with-gemini-buffer
	       ""
	       (expect (gemini-header-level-at-point) :to-equal 1)))
	  (it "Provides a default level of 1 when no header preceeds <POINT>"
	      (with-gemini-buffer
	       "<POINT>\n## Header Below"
	       (expect (gemini-header-level-at-point) :to-equal 1)))
	  (it "Matches the level 2 header preceeding <POINT>"
	      (with-gemini-buffer
	       "## Header\n<POINT>"
	       (expect (gemini-header-level-at-point) :to-equal 2)))
	  (it "Matches the level 7 header preceeding <POINT>"
	      (with-gemini-buffer
	       "####### Header\n<POINT>"
	       (expect (gemini-header-level-at-point) :to-equal 7)))
	  (it "Matches the level of the immediate parent header when that parent header is nested"
	      (with-gemini-buffer
	       "# Level 1 Heading 
## Level 2 Heading 
<POINT>
## Another Level 2 Heading"
	       (expect (gemini-header-level-at-point) :to-equal 2)))
	  (it "Matches the header level of the heading <POINT> is located IN"
	      (with-gemini-buffer
	       "### Level <POINT> Heading"
	       (expect (gemini-header-level-at-point) :to-equal 3))))

(provide 'gemini-mode--header-insert-tests)

;;; gemini-mode--header-insert-tests.el ends here




