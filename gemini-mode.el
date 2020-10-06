;;; gemini-mode.el --- Major mode for working with gemini protocol files

;;; Commentary:
;;; soon

;;; Code:

;;; Constants

(defconst gemini-mode-version "0.0.1-dev"
  "The version number for Gemini mode.")
;;; Mode Definition

(defun gemini-mode-show-version ()
  "Output version number in minibuffer."
  (interactive)
  (message "gemini-mode version %s" gemini-mode-version))

(define-derived-mode gemini-mode text-mode "Gemini"
  "Major mode for Gemini files.")

(add-to-list 'auto-mode-alist
             '("\\.\\(?:gemini\\)" . gemini-mode))


(provide 'gemini-mode)

;;; gemini-mode.el ends here
