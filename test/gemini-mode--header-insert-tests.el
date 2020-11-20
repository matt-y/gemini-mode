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

(describe "gemini-insert-header-auto"
	  ;; Level Detection
	  (it "Inserts a level 1 header in an empty buffer"
	      (with-gemini-buffer
	       ""
	       (gemini-insert-header-auto)
	       (expect (buffer-string) :to-equal "# ")))

	  ;; Inserting with text at point 
	  (it "Takes a line of text containing point and translates it into a header"
	      (with-gemini-buffer
	       "This is a <POINT> line with the point"
	       (gemini-insert-header-auto)
	       (expect (buffer-string)
		       :to-equal "# This is a line with the point")))
	  (it "Does not modify existing header at point if no level change occurs"
	      (with-gemini-buffer
	       "# This is a <POINT> header with the point"
	       (gemini-insert-header-auto)
	       (expect (buffer-string)
		       :to-equal "# This is a header with the point")))
	  (it "Does not modify an existing header at point"
	      (with-gemini-buffer
	       "## Preceeding Header\n\n# This is a <POINT> header with the point"
	       (gemini-insert-header-auto)
	       (expect (buffer-string)
		       :to-equal "## Preceeding Header\n\n# This is a header with the point")))

	  ;; Insertion with text region
	  (it "Uses active region text is used as header content"
	      (with-gemini-buffer-region
	       "This is a <REGION-START>line of text<REGION-END>"
	       (gemini-insert-header-auto)
	       (expect (buffer-string)
		       :to-equal "This is a\n\n# line of text")))
	  (it "Collapses weird weird whitespace in the active region into a header"
	      (with-gemini-buffer-region
	       "<REGION-START> This\t\nis   \n a\n line of \n\ttext<REGION-END>"
	       (gemini-insert-header-auto)
	       (expect (buffer-string)
		       :to-equal "# This is a line of text")))
	  (it "Inserts new header using active region in existing header at same level"
	      (with-gemini-buffer-region
	       "## This is a <REGION-START>line of text<REGION-END>"
	       (expect (buffer-string)
		       :to-equal "## This is a \n## line of text")))

	  ;; Spacing
	  (it "Will not insert a blank line preceeding the header
	  when inserting at beginning of the buffer"
	      (with-gemini-buffer
	       "<POINT>\n\n"
	       (gemini-insert-header-auto)
	       (expect (buffer-string) :to-equal "# \n\n")))
	  (it "Will not insert a blank line following the header when inserting at the end of bufer"
	      (with-gemini-buffer
	       "\n\n<POINT>"
	       (gemini-insert-header-auto)
	       (expect (buffer-string) :to-equal "\n\n# ")))
	  (it "Inserts appropriate space between a new header and the preceeding line"
	      (with-gemini-buffer
	       "This is a line that preceeds the point\n<POINT>"
	       (gemini-insert-header-auto)
	       (expect (buffer-string)
		       :to-equal "This is a line that preceeds the point\n\n# ")))
	  (it "Inserts appropriate space between a new header and the following line"
	      (with-gemini-buffer
	       "<POINT>\nThis is a line that follows the point"
	       (gemini-insert-header-auto)
	       (expect (buffer-string)
		       :to-equal "# \n\nThis is a line that follows the point")))
	  (it "Inserts appropriate space around a new header"
	      (with-gemini-buffer
	       "Preceeding Line\n<POINT>\nFollowing Line"
	       (gemini-insert-header-auto)
	       (expect (buffer-string)
		       :to-equal "Preceeding Line\n\n# \n\nFollowing Line")))
	  (it "Does not insert space when the new header is not crowded on either side"
	      (with-gemini-buffer
	       "Before text\n\nHeader <POINT> Line\n\nAfter Text"
	       (gemini-insert-header-auto)
	       (expect (buffer-string)
		       :to-equal "Before text\n\n# Header Line\n\nAfter Text")))
)

(provide 'gemini-mode--header-insert-tests)

;;; gemini-mode--header-insert-tests.el ends here




