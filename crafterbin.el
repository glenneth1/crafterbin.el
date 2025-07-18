;;; crafterbin.el --- Upload text to crafterbin.glennstack.dev -*- lexical-binding: t -*-

;; Author: Glenn Thompson
;; Keywords: tools, convenience
;; Version: 1.0

;;; Commentary:
;; This package provides functions to upload text and files to crafterbin.glennstack.dev
;; It can upload either a file or the selected region.

;;; Code:
(require 'url)
(require 'url-http)

(defgroup crafterbin nil
  "Upload text to crafterbin.glennstack.dev."
  :group 'tools)

(defcustom crafterbin-url "https://crafterbin.glennstack.dev"
  "URL of the CrafterBin service."
  :type 'string
  :group 'crafterbin)

(defun crafterbin-upload-region (start end)
  "Upload the region between START and END to CrafterBin."
  (interactive "r")
  (let ((text (buffer-substring-no-properties start end))
        (temp-file (concat (make-temp-file "crafterbin-") ".txt")))
    (with-temp-file temp-file
      (insert text))
    (crafterbin-upload-file temp-file)
    (delete-file temp-file)))

(defun crafterbin-check-curl ()
  "Check if curl is available."
  (interactive)
  (if (executable-find "curl")
      (message "curl is available at %s" (executable-find "curl"))
    (message "curl is not available in PATH")))

(defun crafterbin-upload-file (file)
  "Upload FILE to CrafterBin."
  (interactive "File to upload: ")
  (message "Uploading to CrafterBin at %s..." crafterbin-url)
  
  ;; Check if curl is available
  (unless (executable-find "curl")
    (error "curl is not available. Please install curl or check your PATH"))
  
  ;; Expand file path to handle tilde and get absolute path
  (let ((expanded-file (expand-file-name file)))
    ;; Use curl instead of url-retrieve for better multipart handling
    (let ((temp-buffer (generate-new-buffer "*crafterbin-output*")))
      (message "Running curl to upload %s" expanded-file)
      (let ((exit-code (call-process "curl" nil temp-buffer nil
                    "-v" "-X" "POST"
                    "-F" (format "file=@%s" (shell-quote-argument expanded-file))
                    crafterbin-url)))
        (message "curl exit code: %s" exit-code)
        
        (with-current-buffer temp-buffer
          (let ((output (buffer-string)))
            (if (= exit-code 0)
                (progn
                  ;; Extract just the URL from the output
                  (goto-char (point-max))
                  (forward-line -1)
                  (let ((url (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
                    (when (string-match "^https://" url)
                      (kill-new url)
                      (message "Uploaded to %s (URL copied to clipboard)" url)))
                  
                  ;; If we couldn't find a URL, show the full output for debugging
                  (unless (string-match "^https://" (car kill-ring))
                    (message "Full output: %s" output)))
              (message "Error uploading: %s" output)))
          (kill-buffer temp-buffer))))))

(defun crafterbin-upload ()
  "Upload to CrafterBin. If region is active, upload region, otherwise prompt for file."
  (interactive)
  (if (region-active-p)
      (crafterbin-upload-region (region-beginning) (region-end))
    (call-interactively 'crafterbin-upload-file)))

(provide 'crafterbin)
;;; crafterbin.el ends here
