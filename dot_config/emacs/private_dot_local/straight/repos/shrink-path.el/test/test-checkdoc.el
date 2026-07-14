;;; test-checkdoc.el --- run checkdoc over files -*- lexical-binding: t; -*-

(require 'checkdoc)

(load (expand-file-name "test-helper.el" (directory-file-name (file-name-directory load-file-name))))

(setq checkdoc-package-keywords-flag nil
      checkdoc-arguments-in-order-flag nil
      checkdoc-verb-check-experimental-flag nil)

(checkdoc-file shrink-path-el)

;;; test-checkdoc.el ends here
