;;; evil-numbers-tests.el --- Testing -*- lexical-binding: t -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; See: `evil-numbers-tests.sh' for launching this script.

(require 'ert)

(setq evil-numbers-tests-basedir
      (concat (file-name-directory load-file-name) ".."))
(add-to-list 'load-path evil-numbers-tests-basedir)
(require 'evil-numbers)

;;; Code:

;; ---------------------------------------------------------------------------
;; Global State (Set Up Key Bindings)

;; VIM-style increment/decrement key bindings.
(global-set-key (kbd "C-a") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-x") 'evil-numbers/dec-at-pt)

;; Incremental variants (not standard VIM).
(global-set-key (kbd "C-M-a") 'evil-numbers/inc-at-pt-incremental)
(global-set-key (kbd "C-M-x") 'evil-numbers/dec-at-pt-incremental)


;; ---------------------------------------------------------------------------
;; Internal Functions/Macros

(defmacro simulate-input (&rest keys)
  "Helper macro to simulate input using KEYS."
  (declare (indent 0))
  `(let ((keys-list (list ,@keys)))
     (dolist (keys keys-list)
       (execute-kbd-macro keys))))

(defun buffer-reset-text (initial-buffer-text)
  "Initialize buffer with INITIAL-BUFFER-TEXT."
  (buffer-disable-undo)
  (simulate-input
    (kbd "i"))
  (erase-buffer)
  ;; Don't move the cursor.
  (save-excursion (insert initial-buffer-text))
  (simulate-input
    (kbd "<escape>"))
  (buffer-enable-undo))

(defmacro with-evil-numbers-test (initial-buffer-text &rest body)
  "Run BODY with messages inhibited, setting buffer text to INITIAL-BUFFER-TEXT."
  (declare (indent 1))
  ;; Messages make test output noisy (mainly evil mode switching messages).
  ;; Set `inhibit-message' to nil to see messages when debugging.
  `(let ((inhibit-message t))
     (evil-mode 1)
     (buffer-reset-text ,initial-buffer-text)
     (prog1 (progn
              ,@body)
       (evil-mode 0))))


;; ---------------------------------------------------------------------------
;; Tests
;; ---------------------------------------------------------------------------

;; ---------------------------------------------------------------------------
;; Simple Decimal Tests

(ert-deftest simple ()
  "Check a single number increments."
  (let ((text-expected "2|")
        (text-initial "1"))
    (with-evil-numbers-test text-initial
      ;; Increment the number.
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-negative ()
  "Check a single number decrements."
  (let ((text-expected "-1|")
        (text-initial "0"))
    (with-evil-numbers-test text-initial
      ;; Decrement the number.
      (simulate-input
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Binary Number Tests

(ert-deftest simple-binary ()
  "Check that binary numbers increment correctly."
  (let ((text-expected " 0b110| ")
        (text-initial " 0b101 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-binary-uppercase-prefix ()
  "Check that uppercase binary prefix works."
  (let ((text-expected " 0B110| ")
        (text-initial " 0B101 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-binary-decrement ()
  "Check that binary numbers decrement correctly."
  (let ((text-expected " 0b100| ")
        (text-initial " 0b101 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-binary-carry ()
  "Check that binary increment handles carry correctly."
  (let ((text-expected " 0b1000| ")
        (text-initial " 0b111 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-binary-negative ()
  "Check that negative binary numbers work."
  (let ((text-expected " -0b100| ")
        (text-initial " -0b101 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-binary-to-negative ()
  "Check that binary can decrement to negative."
  (let ((text-expected " -0b1| ")
        (text-initial " 0b0 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-binary-cursor-positions ()
  "Check that binary is detected at all cursor positions."
  (let ((text-initial " 0b101 "))
    ;; Test incrementing at different offsets within the binary number.
    (dotimes (i 6)
      (with-evil-numbers-test text-initial
        (dotimes (_ i)
          (simulate-input
            "l"))
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal " 0b110| " (buffer-string)))))))

;; ---------------------------------------------------------------------------
;; Octal Number Tests

(ert-deftest simple-octal ()
  "Check that octal numbers increment correctly."
  (let ((text-expected " 0o10| ")
        (text-initial " 0o7 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-octal-uppercase-prefix ()
  "Check that uppercase octal prefix works."
  (let ((text-expected " 0O43| ")
        (text-initial " 0O42 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-octal-decrement ()
  "Check that octal numbers decrement correctly."
  (let ((text-expected " 0o41| ")
        (text-initial " 0o42 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-octal-carry ()
  "Check that octal increment handles carry correctly (7 -> 10)."
  (let ((text-expected " 0o100| ")
        (text-initial " 0o77 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-octal-negative ()
  "Check that negative octal numbers work."
  (let ((text-expected " -0o41| ")
        (text-initial " -0o42 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-octal-to-negative ()
  "Check that octal can decrement to negative."
  (let ((text-expected " -0o1| ")
        (text-initial " 0o0 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-octal-cursor-positions ()
  "Check that octal is detected at all cursor positions."
  (let ((text-initial " 0o42 "))
    ;; Test incrementing at different offsets within the octal number.
    (dotimes (i 5)
      (with-evil-numbers-test text-initial
        (dotimes (_ i)
          (simulate-input
            "l"))
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal " 0o43| " (buffer-string)))))))

;; ---------------------------------------------------------------------------
;; Hexadecimal Number Tests

;; See bug #18.
(ert-deftest simple-hex ()
  "Check that hexadecimal is detected at all positions."
  (let ((text-initial " 0xFFF "))
    ;; Test incrementing at different offsets,
    ;; this ensures scanning the hexadecimal is handled properly.
    (dotimes (i 6)
      (with-evil-numbers-test text-initial
        (dotimes (_ i)
          (simulate-input
            "l"))
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal " 0x1000| " (buffer-string)))))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "llllll")
        (kbd "C-a")
        "a|"
        (kbd "<escape>"))
      (should (equal " 0xFFF |" (buffer-string))))))

;; See bug #17.
(ert-deftest simple-hex-positive-to-negative ()
  "Change positive hex to negative."
  (let ((text-expected " -0x1| ")
        (text-initial " 0x1 "))
    (dotimes (i 4)
      (with-evil-numbers-test text-initial
        (dotimes (_ i)
          (simulate-input
            "l"))
        (simulate-input
          (kbd "C-x")
          (kbd "C-x"))
        (simulate-input
          "a|"
          (kbd "<escape>"))
        (should (equal text-expected (buffer-string)))))))

(ert-deftest simple-hex-negative-to-positive ()
  "Change negative hex to positive."
  (let ((text-expected " 0x1| ")
        (text-initial " -0x1 "))
    (dotimes (i 5)
      (with-evil-numbers-test text-initial
        (dotimes (_ i)
          (simulate-input
            "l"))
        (simulate-input
          (kbd "C-a")
          (kbd "C-a"))
        (simulate-input
          "a|"
          (kbd "<escape>"))
        (should (equal text-expected (buffer-string)))))))

;; See bug #24.
(ert-deftest simple-hex-case-preserved ()
  "Check that hexadecimal case is preserved when incrementing/decrementing."
  ;; Lowercase hex should stay lowercase.
  (let ((text-expected " 0xf1| ")
        (text-initial " 0xf0 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string)))))
  ;; Uppercase hex should stay uppercase.
  (let ((text-expected " 0xF1| ")
        (text-initial " 0xF0 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string)))))
  ;; Numeric-only hex (no alpha) should become lowercase (default).
  (let ((text-expected " 0xa| ")
        (text-initial " 0x9 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string)))))
  ;; Test decrement preserves case too.
  (let ((text-expected " 0xef| ")
        (text-initial " 0xf0 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-hex-case-forced-upcase ()
  "Check that `evil-numbers-case' set to `upcase' forces uppercase hex."
  (let ((evil-numbers-case 'upcase))
    ;; Lowercase input should become uppercase.
    (let ((text-expected " 0xAB| ")
          (text-initial " 0xaa "))
      (with-evil-numbers-test text-initial
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal text-expected (buffer-string)))))
    ;; Uppercase input stays uppercase.
    (let ((text-expected " 0xAB| ")
          (text-initial " 0xAA "))
      (with-evil-numbers-test text-initial
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal text-expected (buffer-string)))))
    ;; Numeric-only hex becomes uppercase when alpha digits appear.
    (let ((text-expected " 0xA| ")
          (text-initial " 0x9 "))
      (with-evil-numbers-test text-initial
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal text-expected (buffer-string)))))))

(ert-deftest simple-hex-case-forced-downcase ()
  "Check that `evil-numbers-case' set to `downcase' forces lowercase hex."
  (let ((evil-numbers-case 'downcase))
    ;; Uppercase input should become lowercase.
    (let ((text-expected " 0xab| ")
          (text-initial " 0xAA "))
      (with-evil-numbers-test text-initial
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal text-expected (buffer-string)))))
    ;; Lowercase input stays lowercase.
    (let ((text-expected " 0xab| ")
          (text-initial " 0xaa "))
      (with-evil-numbers-test text-initial
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal text-expected (buffer-string)))))
    ;; Numeric-only hex becomes lowercase when alpha digits appear.
    (let ((text-expected " 0xa| ")
          (text-initial " 0x9 "))
      (with-evil-numbers-test text-initial
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal text-expected (buffer-string)))))))

;; ---------------------------------------------------------------------------
;; Separator Character Tests

(ert-deftest simple-separator-chars ()
  "Check separator characters are handled when incrementing."
  (let ((text-expected "1_11_111|")
        (text-initial "1_11_110"))
    ;; Test at different offsets to ensure
    ;; there are no bugs similar to #18 occurring.
    (dotimes (i 8)
      (with-evil-numbers-test text-initial
        (setq-local evil-numbers-separator-chars "_")
        (dotimes (_ i)
          (simulate-input
            "l"))
        (simulate-input
          (kbd "C-a")
          "a|")
        (should (equal text-expected (buffer-string)))))))

(ert-deftest simple-separator-chars-disabled ()
  "Check separator characters are ignored when disabled."
  (let ((text-expected "2|_11_111")
        (text-initial "1_11_111"))
    (with-evil-numbers-test text-initial
      (setq-local evil-numbers-separator-chars nil)
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Edge Cases / No-Operation Tests

(ert-deftest simple-nop-non-number ()
  "Do nothing, the value under the cursor is not a number."
  (let ((text-expected "X|")
        (text-initial "X"))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-nop-non-number-signed ()
  "Do nothing, the value under the cursor is not a number, but it has a sign."
  (let ((text-expected "-|X")
        (text-initial "-X"))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

;; See bug #25.
(ert-deftest simple-nop-non-number-with-newline-before ()
  "Do nothing, ensure the newline isn't stepped over."
  (let ((text-expected "|\n0")
        (text-initial "\n0"))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "<end>")
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-nop-non-number-with-newline-after ()
  "Do nothing, ensure the newline isn't stepped over."
  (let ((text-expected "0\n|")
        (text-initial "0\n"))
    (with-evil-numbers-test text-initial
      (simulate-input
        "j"
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-nop-cursor-after-decimal ()
  "Do nothing, the cursor is after the number so it shouldn't be modified."
  (let ((text-expected "1 |\n")
        (text-initial "1 \n"))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "<end>")
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-nop-cursor-after-hex ()
  "Do nothing, the cursor is after the number so it shouldn't be modified."
  (let ((text-expected "0xBEEF |\n")
        (text-initial "0xBEEF \n"))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "<end>")
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string))))))

;; See bug #20.
(ert-deftest simple-nop-blank-line-cursor-stays ()
  "Do nothing on blank line and don't move cursor to next line.
When incrementing on a blank line with another line after it,
the cursor should remain on the blank line, not move to the next line."
  (let ((text-expected "|\n0")
        (text-initial "\n0"))
    (with-evil-numbers-test text-initial
      (simulate-input
        ;; Cursor starts on the blank first line.
        ;; Try to increment - should fail and cursor should NOT move.
        (kbd "C-a")
        ;; Show cursor location.
        "a|")
      (should (equal text-expected (buffer-string)))))
  ;; Also test decrement.
  (let ((text-expected "|\n0")
        (text-initial "\n0"))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string))))))

;; See bug #27.
(ert-deftest simple-nop-cursor-at-end-of-line-trailing-space ()
  "Do nothing when cursor is at trailing space where forward-char can't move.
When the cursor is at the last blank space on a line (end of line),
the number directly before it should NOT be manipulated."
  ;; Test with trailing space (the exact bug #27 scenario).
  (let ((text-expected "123 |")
        (text-initial "123 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        ;; Move to end of line (the trailing space).
        (kbd "<end>")
        ;; Try to increment - should do nothing.
        (kbd "C-a")
        ;; Show cursor location.
        "a|")
      (should (equal text-expected (buffer-string)))))
  ;; Also test decrement.
  (let ((text-expected "123 |")
        (text-initial "123 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "<end>")
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Visual Selection Tests

(ert-deftest selected-block-column-first ()
  "Block selection test."
  (let ((text-expected
         ;; format-next-line: off
         (concat "1| 0 0\n"
                 "1 0 0\n"
                 "1 0 0\n"))
        (text-initial
         ;; format-next-line: off
         (concat "0 0 0\n"
                 "0 0 0\n"
                 "0 0 0\n")))
    (with-evil-numbers-test text-initial
      (simulate-input
        ;; Block select the column.
        (kbd "C-v")
        "jj"
        ;; Increment.
        (kbd "C-a")
        ;; Show cursor location.
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest selected-block-column-second ()
  "Block selection test."
  (let ((text-expected
         ;; format-next-line: off
         (concat "0 1| 0\n"
                 "0 1 0\n"
                 "0 1 0\n"))
        (text-initial
         ;; format-next-line: off
         (concat "0 0 0\n"
                 "0 0 0\n"
                 "0 0 0\n")))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "w")
        ;; Block select the column.
        (kbd "C-v")
        "jj"
        ;; Increment.
        (kbd "C-a")
        ;; Show cursor location.
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest selected-block-column-third ()
  "Block selection test."
  (let ((text-expected
         ;; format-next-line: off
         (concat "0 0 1|\n"
                 "0 0 1\n"
                 "0 0 1\n"))
        (text-initial
         ;; format-next-line: off
         (concat "0 0 0\n"
                 "0 0 0\n"
                 "0 0 0\n")))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "ww")
        ;; Block select the column.
        (kbd "C-v")
        "jj"
        ;; Increment.
        (kbd "C-a")
        ;; Show cursor location.
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest selected-block-column-first-incremental ()
  "Incremental block selection test."
  (let ((text-expected
         ;; format-next-line: off
         (concat "1| 0 0\n"
                 "2 0 0\n"
                 "3 0 0\n"))
        (text-initial
         ;; format-next-line: off
         (concat "0 0 0\n"
                 "0 0 0\n"
                 "0 0 0\n")))
    (with-evil-numbers-test text-initial
      (simulate-input
        ;; Block select the column.
        (kbd "C-v")
        "jj"
        ;; Increment.
        (kbd "C-M-a")
        ;; Show cursor location.
        "a|")
      (should (equal text-expected (buffer-string))))))

;; See bug #21.
(ert-deftest selected-line-cursor-at-end ()
  "Line selection increments numbers before the cursor."
  (let ((text-expected "2 2 2|\n")
        (text-initial "1 1 1\n"))
    (with-evil-numbers-test text-initial
      (simulate-input
        ;; Move to end of line (cursor after last number).
        (kbd "<end>")
        ;; Line select.
        (kbd "V")
        ;; Increment.
        (kbd "C-a")
        ;; Show cursor location.
        "a|")
      (should (equal text-expected (buffer-string))))))

(ert-deftest selected-lines-incremental ()
  "Incremental line selection test."
  (let ((text-expected
         ;; format-next-line: off
         (concat "1| 2 3\n"
                 "4 5 6\n"
                 "7 8 9\n"))
        (text-initial
         ;; format-next-line: off
         (concat "0 0 0\n"
                 "0 0 0\n"
                 "0 0 0\n")))
    (with-evil-numbers-test text-initial
      (simulate-input
        ;; Line select the rows.
        (kbd "V")
        "jj"
        ;; Increment.
        (kbd "C-M-a")
        ;; Show cursor location.
        "a|")
      (should (equal text-expected (buffer-string))))))

;; See commit c37a4cf92a9cf8aa9f8bd752ea856a9d1bc6c84c.
(ert-deftest selected-block-column-padding-preserved ()
  "Block selection should preserve padding when `evil-numbers-pad-default' is set.
When incrementing numbers using block selection with padding enabled,
the padding should be preserved. For example, incrementing 7 with padding
should result in 08 (matching original width), not 8."
  ;; Test with padding enabled via evil-numbers-pad-default.
  (let ((evil-numbers-pad-default t))
    (let ((text-expected
           ;; format-next-line: off
           (concat "0|8 00 00\n"
                   "08 00 00\n"
                   "08 00 00\n"))
          (text-initial
           ;; format-next-line: off
           (concat "07 00 00\n"
                   "07 00 00\n"
                   "07 00 00\n")))
      (with-evil-numbers-test text-initial
        (simulate-input
          ;; Block select the first column (both digits).
          (kbd "C-v")
          "ljj"
          ;; Increment.
          (kbd "C-a")
          ;; Show cursor location.
          "a|")
        (should (equal text-expected (buffer-string)))))
    ;; Also test decrement preserves padding.
    (let ((text-expected
           ;; format-next-line: off
           (concat "0|6 00 00\n"
                   "06 00 00\n"
                   "06 00 00\n"))
          (text-initial
           ;; format-next-line: off
           (concat "07 00 00\n"
                   "07 00 00\n"
                   "07 00 00\n")))
      (with-evil-numbers-test text-initial
        (simulate-input
          ;; Block select the first column (both digits).
          (kbd "C-v")
          "ljj"
          ;; Decrement.
          (kbd "C-x")
          ;; Show cursor location.
          "a|")
        (should (equal text-expected (buffer-string)))))))

;; ---------------------------------------------------------------------------
;; Option Behavior Tests

;; See bug #26.
(ert-deftest simple-cursor-at-end-of-number ()
  "Check `evil-numbers-use-cursor-at-end-of-number' behavior."
  (let ((text-initial "foo(1)"))
    ;; Test with option DISABLED (default VIM behavior).
    ;; Cursor directly after a number should NOT increment it.
    (let ((evil-numbers-use-cursor-at-end-of-number nil))
      (with-evil-numbers-test text-initial
        (simulate-input
          ;; Move cursor to the ')' (directly after the number).
          "f)"
          ;; Try to increment.
          (kbd "C-a")
          ;; Show cursor location.
          "a|")
        ;; Number should NOT be incremented.
        (should (equal "foo(1)|" (buffer-string)))))

    ;; Test with option ENABLED.
    ;; Cursor directly after a number SHOULD increment it.
    (let ((evil-numbers-use-cursor-at-end-of-number t))
      (with-evil-numbers-test text-initial
        (simulate-input
          ;; Move cursor to the ')' (directly after the number).
          "f)"
          ;; Try to increment.
          (kbd "C-a")
          ;; Show cursor location.
          "a|")
        ;; Number SHOULD be incremented (cursor ends at number).
        (should (equal "foo(2|)" (buffer-string)))))))

(ert-deftest simple-handle-negative-disabled ()
  "Check `evil-numbers-negative' behavior when disabled.
When disabled, the minus sign before a number is ignored."
  ;; Test with option ENABLED (default behavior).
  ;; Incrementing -5 should give -4.
  (let ((evil-numbers-negative t)
        (text-expected " -4| ")
        (text-initial " -5 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string)))))

  ;; Test with option DISABLED.
  ;; The minus sign is ignored, so -5 is treated as 5.
  ;; Incrementing 5 gives 6, result is -6 (minus untouched).
  (let ((evil-numbers-negative nil)
        (text-expected " -6| ")
        (text-initial " -5 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string)))))

  ;; Test decrement with option DISABLED.
  ;; Decrementing 5 (ignoring the minus) gives 4, result is -4.
  (let ((evil-numbers-negative nil)
        (text-expected " -4| ")
        (text-initial " -5 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string)))))

  ;; Positive numbers should work normally with option disabled.
  (let ((evil-numbers-negative nil)
        (text-expected " 6| ")
        (text-initial " 5 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-a")
        "a|")
      (should (equal text-expected (buffer-string)))))

  ;; Decrementing 0 with option disabled should clamp to 0.
  (let ((evil-numbers-negative nil)
        (text-expected " 0| ")
        (text-initial " 0 "))
    (with-evil-numbers-test text-initial
      (simulate-input
        (kbd "C-x")
        "a|")
      (should (equal text-expected (buffer-string))))))

(provide 'evil-numbers-tests)
;;; evil-numbers-tests.el ends here
