;;; test-gemini-mode--macro-utils.el -*- lexical-binding: t; -*-

;;; Commentary:

;; Utility macros and funcitons for gemini-mode tests 
;;
;; This file is part of gemini-mode

;;; Code:

(require 'gemini-mode)

(defvar point-sentinel "<POINT>"
  "When used in a `with-temp-buffer` macro CONTENTS variable,
  designates where the emacs point will be placed within that
  buffer. 

Use this to set up test cases that rely on point positioning.")

(defvar region-regex "\\(?1:<REGION-START>\\)\\(?2:.*?\\)\\(?2:<REGION-END>\\)")
(defvar region-start "<REGION-START>")
(defvar region-end "REGION-END>")

(defmacro with-gemini-buffer (contents &rest body)
  "Executes BODY in a temporary gemini-mode buffer with CONTENTS
  as the buffer content. Will set the point to a particular
  position when a sentinel is provided in CONTENTS.

CONTENTS is a string that will be used as the buffer contents. 

CONTENTS can contain the optional sentinel value `<POINT>`
indicating the desired point position in the temporary buffer. If
no `<POINT>` string is present, the point is placed at the end of
the buffer."
  `(with-temp-buffer
     (delay-mode-hooks (gemini-mode))
     (insert ,contents)
     (goto-char (point-min))
       
     
     ;; If no region is found, search for point sentinel	    
     (when (search-forward point-sentinel nil 'noerror)
       (delete-char (- (length point-sentinel))))
     ,@body))

(defmacro with-gemini-buffer-region (contents &rest body)
  "Executes BODY in a temporary gemini-mode buffer with CONTENTS
  as the buffer content. Will set an active region if the region
  delimiters are provided in CONTENTS.

CONTENTS is a string that will be used as the buffer contents. 

CONTENTS may contain a <REGION-START> and <REGION-END> delimiters
that will see the text inside of the two delimeters used as the
active region."
  `(with-temp-buffer
     (delay-mode-hooks (gemini-mode))
     (insert ,contents)
     (goto-char (point-min))
     
     (when (search-forward region-regex nil 'noerror)
       (let ((begin (match-beginning 0))
	     (end (match-end 0)))
	 ;; Okay, here we take the point to the end of the entire match
	 ;; body, then remove the region-end delimeter. We go to the
	 ;; start, then remove the region-start delimeter. The point
	 ;; should now be at the beginning of the second capture group,
	 ;; so we engage `set-mark-command' and move the point forward
	 ;; through the second capture group.
	 ;;
	 ;; woof.
	 (point end)
	 (delete-char (- (length region-end)))
	 (point begin)
	 (delete-char (length region-start))
	 (set-mark-command)
	 (forward-char (length (match-string-no-properties 2)))))))

		       
(provide 'test-gemini-mode--macro-utils)

;;; test-gemini-mode--macro-utils.el ends here

