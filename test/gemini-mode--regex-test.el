;;; gemini-mode--regex-tests.el -*- lexical-binding: t; -*-

;;; Commentary:

;; Test suite for major items in gemini-mode
;;
;; This file is part of gemini-mode

;;; Code:

(require 'buttercup)
(require 'gemini-mode)

;; Rudimentary testing of match groups for the gemini--regex-header
(describe "gemini--regex-header"
  (it "Does not match leading space in markup"
      (with-gemini-buffer
       " ### Blah"
       (let ((match (re-search-backward gemini--regex-header nil t)))
	 (expect match :to-equal nil))))
  (it "Does not match leading tab in markup"
      (with-gemini-buffer
       "\t### Blah"
       (let ((match (re-search-backward gemini--regex-header nil t)))
	 (expect match :to-equal nil))))
  (it "Does not match when there is no space between markup and content"
      (with-gemini-buffer
       "###Blah"
       (let ((match (re-search-backward gemini--regex-header nil t)))
	 (expect match :to-equal nil))))

  (it "Matches header markup followed by a tab"
      (with-gemini-buffer
       "###\tBlah"
       (let ((match (re-search-backward gemini--regex-header nil t)))
	 (expect (match-string-no-properties 1) :to-equal "###\t"))))
  (it "Matches header markup followed by a space"
      (with-gemini-buffer
       "## Blah"
       (let ((match (re-search-backward gemini--regex-header nil t)))
	 (expect (match-string-no-properties 1) :to-equal "## "))))
	 
  (it "Matches trailing space following content"
      (with-gemini-buffer
       "# Blah "
       (let ((match (re-search-backward gemini--regex-header nil t)))
	 (expect (match-string-no-properties 3) :to-equal " "))))
  (it "Matches trailing tab following content"
      (with-gemini-buffer
       "#### Blah\t"
       (let ((match (re-search-backward gemini--regex-header nil t)))
	 (expect (match-string-no-properties 3) :to-equal "\t"))))
  (it "Matches header content"
      (let ((expected-content "This is a very cool header"))
	(with-gemini-buffer
	 (concat "# " expected-content)
	 (let ((match (re-search-backward gemini--regex-header nil t)))
	   (expect (match-string-no-properties 2) :to-equal expected-content))))))


(provide 'gemini-mode--regex-tests)

;;; gemini-mode--regex-tests.el ends here
