;;; test-gemini-mode--macro-utils.el

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

(defmacro with-gemini-buffer (contents &rest body)
  "Executes BODY in a temporary gemini-mode buffer with CONTENTS
  as the buffer content.

CONTENTS is a string that contains the optional sentinel value
`<POINT>` indicating the desired point position in the temporary
buffer. If no `<POINT>` string is present, the point is placed at
the end of the buffer"
  `(with-temp-buffer
     (delay-mode-hooks (gemini-mode))
     (insert ,contents)
     (goto-char (point-min))
     ;; search for sentinel, 'noerror moves to limit of search and
     ;; returns nil when not found
     (when (search-forward point-sentinel nil 'noerror)
       (delete-char (- (length point-sentinel))))
     ,@body))

		       
(provide 'test-gemini-mode--macro-utils)

;;; test-gemini-mode--macro-utils.el ends here

