;;; shift-number-tests.el --- Testing -*- lexical-binding: t -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; See: `shift-number-tests.sh' for launching this script.

(require 'ert)
(require 'rect)

;;; Code:

(defvar shift-number-tests-basedir
  (concat (file-name-directory load-file-name) "..")
  "Base directory for shift-number tests.")
(add-to-list 'load-path shift-number-tests-basedir)
(require 'shift-number)

;; ---------------------------------------------------------------------------
;; Internal Functions/Macros

(defun buffer-reset-text (initial-buffer-text)
  "Initialize buffer with INITIAL-BUFFER-TEXT."
  (erase-buffer)
  ;; Don't move the cursor.
  (save-excursion (insert initial-buffer-text)))

(defmacro with-shift-number-test (initial-buffer-text &rest body)
  "Run BODY with messages inhibited, setting buffer text to INITIAL-BUFFER-TEXT."
  (declare (indent 1))
  `(with-temp-buffer
     (let ((inhibit-message t))
       (buffer-reset-text ,initial-buffer-text)
       ,@body)))

(defun cursor-marker ()
  "Insert a | character at point to mark cursor position for test verification."
  (insert "|"))

(defmacro should-error-with-message (form error-type expected-message)
  "Assert FORM signals an error of ERROR-TYPE with EXPECTED-MESSAGE."
  (declare (indent 1))
  (let ((err-sym (make-symbol "err")))
    `(let ((,err-sym (should-error ,form :type ,error-type)))
       (should (equal ,expected-message (error-message-string ,err-sym))))))


;; ---------------------------------------------------------------------------
;; Basic Integer Tests

(ert-deftest simple-increment ()
  "Check a single number increments."
  (let ((text-initial "1")
        (text-expected "|2"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-decrement ()
  "Check a single number decrements."
  (let ((text-initial "2")
        (text-expected "|1"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-increment-by-amount ()
  "Check incrementing by a specific amount."
  (let ((text-initial "5")
        (text-expected "|15"))
    (with-shift-number-test text-initial
      (shift-number-up 10)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest simple-decrement-by-amount ()
  "Check decrementing by a specific amount."
  (let ((text-initial "15")
        (text-expected "|5"))
    (with-shift-number-test text-initial
      (shift-number-down 10)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest no-arg-increment ()
  "Check that ARG defaults to 1 when omitted in a Lisp call."
  (let ((text-initial "1")
        (text-expected "|2"))
    (with-shift-number-test text-initial
      (shift-number-up)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest no-arg-decrement ()
  "Check that ARG defaults to 1 when omitted in a Lisp call."
  (let ((text-initial "2")
        (text-expected "|1"))
    (with-shift-number-test text-initial
      (shift-number-down)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest no-arg-incremental-up ()
  "Check that ARG defaults to 1 when omitted in a Lisp call."
  (let ((text-initial "0 0 0")
        (text-expected "1 2 |3"))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up-incremental)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest no-arg-incremental-down ()
  "Check that ARG defaults to 1 when omitted in a Lisp call."
  (let ((text-initial "10 10 10")
        (text-expected "9 8 |7"))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-down-incremental)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest delta-zero ()
  "Check that delta of zero leaves number unchanged."
  (let ((text-initial "42")
        (text-expected "|42"))
    (with-shift-number-test text-initial
      (shift-number-up 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest zero-increment ()
  "Check that single digit zero increments correctly."
  (let ((text-initial "0")
        (text-expected "|1"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest negative-delta-up ()
  "Check that negative delta decrements when using shift-number-up."
  (let ((text-initial "10")
        (text-expected "|7"))
    (with-shift-number-test text-initial
      (shift-number-up -3)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest negative-delta-down ()
  "Check that negative delta increments when using shift-number-down."
  (let ((text-initial "10")
        (text-expected "|13"))
    (with-shift-number-test text-initial
      (shift-number-down -3)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Negative Number Tests

(ert-deftest simple-to-negative ()
  "Check a number can decrement to negative."
  (let ((text-initial "0")
        (text-expected "|-1"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest negative-increment ()
  "Check a negative number increments correctly."
  (let ((text-initial "-5")
        (text-expected "|-4"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest negative-to-positive ()
  "Check a negative number can become positive."
  (let ((text-initial "-1")
        (text-expected "|1"))
    (with-shift-number-test text-initial
      (shift-number-up 2)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest negative-to-zero ()
  "Check a negative number can become zero."
  (let ((text-initial "-1")
        (text-expected "|0"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest negative-two-digit-to-one-digit ()
  "Check that incrementing -10 to -9 reduces digit count correctly."
  (let ((text-initial "-10")
        (text-expected "|-9"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest negative-disabled-at-zero ()
  "Check that decrementing below zero is prevented when shift-number-negative is nil."
  (let ((text-initial "0")
        (text-expected "|0")
        (shift-number-negative nil))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest negative-disabled-existing-negative ()
  "Check that existing negative is treated as unsigned when shift-number-negative is nil.
The minus sign is ignored, so -5 becomes -6 (5 incremented to 6)."
  (let ((text-initial "-5")
        (text-expected "|-6")
        (shift-number-negative nil))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest negative-disabled-existing-negative-decrement ()
  "Check that decrementing with shift-number-negative nil treats number as unsigned.
The minus sign is ignored, so -5 is treated as 5, decrementing gives 4, result is -4."
  (let ((text-initial "-5")
        (text-expected "|-4")
        (shift-number-negative nil))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest positive-sign-preserved ()
  "Check that explicit + sign is preserved."
  (let ((text-initial "+5")
        (text-expected "|+6"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest positive-sign-to-negative ()
  "Check that explicit + sign becomes - when crossing zero."
  (let ((text-initial "+1")
        (text-expected "|-1"))
    (with-shift-number-test text-initial
      (shift-number-down 2)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Leading Zeros / Padding Tests

(ert-deftest leading-zeros-preserved ()
  "Check that leading zeros are preserved when incrementing."
  (let ((text-initial "007")
        (text-expected "|008"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest leading-zeros-preserved-decrement ()
  "Check that leading zeros are preserved when decrementing."
  (let ((text-initial "010")
        (text-expected "|009"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest leading-zeros-overflow-padded ()
  "Check that leading zeros are lost when number overflows padded width."
  (let ((text-initial "099")
        (text-expected "|100"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest leading-zeros-width-gain ()
  "Check that leading zeros are preserved when number gains a digit within width."
  (let ((text-initial "009")
        (text-expected "|010"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest leading-zeros-negative ()
  "Check leading zeros with negative numbers."
  (let ((text-initial "-007")
        (text-expected "|-006"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest leading-zeros-negative-to-zero ()
  "Check that negative number with leading zeros can become zero."
  (let ((text-initial "-001")
        (text-expected "|000"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest leading-zeros-to-negative ()
  "Check that positive number with leading zeros can become negative."
  (let ((text-initial "001")
        (text-expected "|-001"))
    (with-shift-number-test text-initial
      (shift-number-down 2)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Width Change Tests

(ert-deftest width-gain ()
  "Check behavior when number gains a digit."
  (let ((text-initial "99")
        (text-expected "|100"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest width-reduction ()
  "Check behavior when number loses a digit."
  (let ((text-initial "100")
        (text-expected "|99"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest width-reduction-negative ()
  "Check behavior when negative number loses a digit."
  (let ((text-initial "-100")
        (text-expected "|-99"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Cursor Position Tests

(ert-deftest cursor-in-middle ()
  "Check that number is found when cursor is in the middle."
  (let ((text-initial "12345")
        (text-expected "12|346"))
    (with-shift-number-test text-initial
      (forward-char 2) ; Position cursor on '3'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest cursor-at-end ()
  "Check that number is found when cursor is at the end."
  (let ((text-initial "123")
        (text-expected "12|4"))
    (with-shift-number-test text-initial
      (goto-char (point-max))
      (backward-char 1) ; Position cursor on '3'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest cursor-before-number ()
  "Check that number ahead on line is found when cursor is before it."
  (let ((text-initial "abc 42")
        (text-expected "|abc 43"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest cursor-between-numbers ()
  "Check that next number is found when cursor is between numbers."
  (let ((text-initial "10 20 30")
        (text-expected "10 |21 30"))
    (with-shift-number-test text-initial
      (forward-char 3) ; Position cursor on space after '10'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest cursor-on-first-of-multiple ()
  "Check that first number is incremented when cursor is on it."
  (let ((text-initial "10 20 30")
        (text-expected "|11 20 30"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest cursor-on-negative-sign ()
  "Check that number is found when cursor is on the negative sign."
  (let ((text-initial "-42")
        (text-expected "|-41"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest cursor-on-positive-sign ()
  "Check that number is found when cursor is on the positive sign."
  (let ((text-initial "+42")
        (text-expected "|+43"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest cursor-after-last-digit ()
  "Check that number is found when cursor is immediately after last digit."
  (let ((text-initial "123")
        (text-expected "124|"))
    (with-shift-number-test text-initial
      (goto-char (point-max)) ; Position cursor after '3'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; No Operation / Edge Case Tests

(ert-deftest nop-no-number ()
  "Error when there's no number on the line."
  (let ((text-initial "abc")
        (text-expected "|abc"))
    (with-shift-number-test text-initial
      (should-error-with-message
          (shift-number-up 1)
        'user-error
        "No number on the current line")
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest nop-non-number-signed ()
  "Error when minus sign is followed by non-digit."
  (let ((text-initial "-X")
        (text-expected "|-X"))
    (with-shift-number-test text-initial
      (should-error-with-message
          (shift-number-up 1)
        'user-error
        "No number on the current line")
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest nop-cursor-after-trailing-space ()
  "Error when cursor is after number with trailing space at end of buffer."
  (let ((text-initial "123 ")
        (text-expected "123 |"))
    (with-shift-number-test text-initial
      (goto-char (point-max))
      (should-error-with-message
          (shift-number-up 1)
        'user-error
        "No number on the current line")
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest nop-cursor-after-trailing-space-decrement ()
  "Error when decrementing with cursor after trailing space."
  (let ((text-initial "123 ")
        (text-expected "123 |"))
    (with-shift-number-test text-initial
      (goto-char (point-max))
      (should-error-with-message
          (shift-number-down 1)
        'user-error
        "No number on the current line")
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest nop-blank-line ()
  "Error on a blank line."
  (let ((text-initial "")
        (text-expected "|"))
    (with-shift-number-test text-initial
      (should-error-with-message
          (shift-number-up 1)
        'user-error
        "No number on the current line")
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest nop-blank-line-decrement ()
  "Error on a blank line when decrementing."
  (let ((text-initial "")
        (text-expected "|"))
    (with-shift-number-test text-initial
      (should-error-with-message
          (shift-number-down 1)
        'user-error
        "No number on the current line")
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest nop-different-line ()
  "Error - do not increment number on a different line."
  (let ((text-initial
         ;; format-next-line: off
         (concat "\n"
                 "42"))
        (text-expected
         ;; format-next-line: off
         (concat "|\n"
                 "42")))
    (with-shift-number-test text-initial
      (should-error-with-message
          (shift-number-up 1)
        'user-error
        "No number on the current line")
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest nop-cursor-after-all-numbers ()
  "Error when cursor is positioned after all numbers on the line."
  (let ((text-initial "10 20 30 ")
        (text-expected "10 20 30 |"))
    (with-shift-number-test text-initial
      (goto-char (point-max)) ; Position cursor after trailing space.
      (should-error-with-message
          (shift-number-up 1)
        'user-error
        "No number on the current line")
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Sign Context Tests (avoid false negatives in expressions)

(ert-deftest expression-subtraction ()
  "Check that subtraction expressions don't create false negatives."
  (let ((text-initial "123-456")
        (text-expected "123-|457"))
    (with-shift-number-test text-initial
      (forward-char 4) ; Position cursor on '4'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest expression-subtraction-first-number ()
  "Check that first number in subtraction is incremented independently."
  (let ((text-initial "123-456")
        (text-expected "|124-456"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest expression-addition ()
  "Check that addition expressions work correctly."
  (let ((text-initial "123+456")
        (text-expected "123+|457"))
    (with-shift-number-test text-initial
      (forward-char 4) ; Position cursor on '4'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Region Tests

(ert-deftest region-multiple-numbers ()
  "Check that all numbers in a region are incremented."
  (let ((text-initial "1 2 3")
        (text-expected "2 3 |4"))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest region-decrement-multiple ()
  "Check that all numbers in a region are decremented."
  (let ((text-initial "5 6 7")
        (text-expected "4 5 |6"))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest region-partial ()
  "Check that only numbers within the region are modified.
The 1 is unchanged, 2 becomes 3, 3 becomes 4, original 4 and 5 unchanged."
  (let ((text-initial "1 2 3 4 5")
        (text-expected "1 3 |4 4 5"))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char 3) ; Position before '2'.
      (set-mark (point))
      (forward-char 4) ; Position after '3'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest region-no-numbers ()
  "Check that region with no numbers leaves buffer unchanged."
  (let ((text-initial "abc def ghi")
        (text-expected "abc def ghi|"))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest region-mixed-signs ()
  "Check that region with mixed positive and negative numbers works."
  (let ((text-initial "-5 0 +5")
        (text-expected "-4 1 |+6"))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest region-multiple-lines ()
  "Check that region spanning multiple lines increments all numbers."
  (let ((text-initial
         ;; format-next-line: off
         (concat "1 2\n"
                 "3 4\n"
                 "5 6"))
        (text-expected
         ;; format-next-line: off
         (concat "2 3\n"
                 "4 5\n"
                 "6 |7")))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest region-reversed ()
  "Check that region works when mark is after point.
Cursor ends on last modified number regardless of selection direction."
  (let ((text-initial "1 2 3")
        (text-expected "2 3 |4"))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-max))
      (set-mark (point))
      (goto-char (point-min))
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Rectangle Mode Tests

(ert-deftest rectangle-single-column ()
  "Check rectangle mode increments a column of numbers."
  (let ((text-initial
         ;; format-next-line: off
         (concat "1 0 0\n"
                 "1 0 0\n"
                 "1 0 0"))
        (text-expected
         ;; format-next-line: off
         (concat "2 0 0\n"
                 "2 0 0\n"
                 "|2 0 0")))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (backward-char 4) ; Position at column 0 of last line.
      (rectangle-mark-mode 1)
      (shift-number-up 1)
      (rectangle-mark-mode 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest rectangle-with-negatives ()
  "Check rectangle mode works with negative numbers."
  (let ((text-initial
         ;; format-next-line: off
         (concat "-5 0\n"
                 "-5 0\n"
                 "-5 0"))
        (text-expected
         ;; format-next-line: off
         (concat "-4 0\n"
                 "-4 0\n"
                 "|-4 0")))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (backward-char 2) ; Position at column 0 of last line.
      (rectangle-mark-mode 1)
      (shift-number-up 1)
      (rectangle-mark-mode 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest rectangle-decrement ()
  "Check rectangle mode decrements a column of numbers."
  (let ((text-initial
         ;; format-next-line: off
         (concat "5 0 0\n"
                 "5 0 0\n"
                 "5 0 0"))
        (text-expected
         ;; format-next-line: off
         (concat "4 0 0\n"
                 "4 0 0\n"
                 "|4 0 0")))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (backward-char 4) ; Position at column 0 of last line.
      (rectangle-mark-mode 1)
      (shift-number-down 1)
      (rectangle-mark-mode 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest rectangle-middle-column ()
  "Check rectangle mode increments a middle column of numbers."
  (let ((text-initial
         ;; format-next-line: off
         (concat "1 2 3\n"
                 "1 2 3\n"
                 "1 2 3"))
        (text-expected
         ;; format-next-line: off
         (concat "1 3 3\n"
                 "1 3 3\n"
                 "1 |3 3")))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (forward-char 2) ; Position at column 2 (the '2').
      (set-mark (point))
      (goto-char (point-max))
      (backward-char 2) ; Position at column 2 of last line.
      (rectangle-mark-mode 1)
      (shift-number-up 1)
      (rectangle-mark-mode 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest rectangle-last-column ()
  "Check rectangle mode increments the last column of numbers."
  (let ((text-initial
         ;; format-next-line: off
         (concat "1 2 3\n"
                 "1 2 3\n"
                 "1 2 3"))
        (text-expected
         ;; format-next-line: off
         (concat "1 2 4\n"
                 "1 2 4\n"
                 "1 2 |4")))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (forward-char 4) ; Position at column 4 (the '3').
      (set-mark (point))
      (goto-char (point-max))
      (rectangle-mark-mode 1)
      (shift-number-up 1)
      (rectangle-mark-mode 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest rectangle-with-motion ()
  "Check rectangle mode works with shift-number-motion enabled."
  (let ((text-initial
         ;; format-next-line: off
         (concat "1 0 0\n"
                 "1 0 0\n"
                 "1 0 0"))
        (text-expected
         ;; format-next-line: off
         (concat "2 0 0\n"
                 "2 0 0\n"
                 "2| 0 0"))
        (shift-number-motion t))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (backward-char 4) ; Position at column 0 of last line.
      (rectangle-mark-mode 1)
      (shift-number-up 1)
      (rectangle-mark-mode 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Incremental Mode Tests

(ert-deftest incremental-no-mark-error ()
  "Check that incremental mode signals error when mark is not set."
  (with-shift-number-test "0 0 0"
    (should-error-with-message
        (shift-number-up-incremental 1)
      'user-error
      "The mark is not set")))

(ert-deftest incremental-without-active-region ()
  "Check that incremental mode works without an active region.
Only the mark needs to be set."
  (let ((text-initial "0 0 0")
        (text-expected "1 2 |3"))
    (with-shift-number-test text-initial
      ;; Set mark but don't activate region.
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      ;; Region is not active, but incremental should still work.
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-region-by-amount ()
  "Check that incremental mode respects the amount argument."
  (let ((text-initial "0 0 0")
        (text-expected "2 4 |6"))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up-incremental 2)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-region-down ()
  "Check that incremental decrement works."
  (let ((text-initial "10 10 10")
        (text-expected "9 8 |7"))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-down-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-region-multiline ()
  "Check that incremental mode works across multiple lines."
  (let ((text-initial
         ;; format-next-line: off
         (concat "0 0 0\n"
                 "0 0 0\n"
                 "0 0 0"))
        (text-expected
         ;; format-next-line: off
         (concat "1 2 3\n"
                 "4 5 6\n"
                 "7 8 |9")))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-rectangle ()
  "Check that incremental mode works with rectangle selection."
  (let ((text-initial
         ;; format-next-line: off
         (concat "0 0 0\n"
                 "0 0 0\n"
                 "0 0 0"))
        (text-expected
         ;; format-next-line: off
         (concat "1 0 0\n"
                 "2 0 0\n"
                 "|3 0 0")))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (backward-char 4) ; Position at column 0 of last line.
      (rectangle-mark-mode 1)
      (shift-number-up-incremental 1)
      (rectangle-mark-mode 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-rectangle-multicolumn ()
  "Check that incremental count continues across rectangle cells.
Cursor ends on the last number modified (highest increment)."
  (let ((text-initial
         ;; format-next-line: off
         (concat "0 0\n"
                 "0 0\n"
                 "0 0"))
        (text-expected
         ;; format-next-line: off
         (concat "1 2\n"
                 "3 4\n"
                 "5 |6")))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (rectangle-mark-mode 1)
      (shift-number-up-incremental 1)
      (rectangle-mark-mode 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-direction-reversed ()
  "Check that incremental direction reverses when point is before mark.
With point before mark, 0 0 0 becomes 3 2 1 instead of 1 2 3."
  (let ((text-initial "0 0 0")
        (text-expected "|3 2 1")
        (shift-number-incremental-direction-from-region t))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point-max))
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-direction-forward ()
  "Check that incremental direction is forward when point is after mark.
With point after mark, 0 0 0 becomes 1 2 3 (standard behavior)."
  (let ((text-initial "0 0 0")
        (text-expected "1 2 |3")
        (shift-number-incremental-direction-from-region t))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-direction-disabled ()
  "Check that direction is always forward when option is disabled."
  (let ((text-initial "0 0 0")
        (text-expected "1 2 |3")
        (shift-number-incremental-direction-from-region nil))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point-max))
      ;; Point is before mark, but option is disabled so direction is forward.
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-direction-reversed-down ()
  "Check that reversed direction works with shift-number-down-incremental."
  (let ((text-initial "10 10 10")
        (text-expected "|7 8 9")
        (shift-number-incremental-direction-from-region t))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point-max))
      (shift-number-down-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-direction-reversed-multiline ()
  "Check that reversed direction works across multiple lines."
  (let ((text-initial
         ;; format-next-line: off
         (concat "0 0 0\n"
                 "0 0 0\n"
                 "0 0 0"))
        (text-expected
         ;; format-next-line: off
         (concat "|9 8 7\n"
                 "6 5 4\n"
                 "3 2 1"))
        (shift-number-incremental-direction-from-region t))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point-max))
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-direction-reversed-rectangle ()
  "Check that reversed direction works with rectangle selection."
  (let ((text-initial
         ;; format-next-line: off
         (concat "0 0 0\n"
                 "0 0 0\n"
                 "0 0 0"))
        (text-expected
         ;; format-next-line: off
         (concat "|3 0 0\n"
                 "2 0 0\n"
                 "1 0 0"))
        (shift-number-incremental-direction-from-region t))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      ;; Set mark at end of last line (column 0), point at start (column 0).
      ;; Point is before mark, so direction is reversed.
      (goto-char (point-max))
      (backward-char 4) ; Position at column 0 of last line.
      (set-mark (point))
      (goto-char (point-min))
      (rectangle-mark-mode 1)
      (shift-number-up-incremental 1)
      (rectangle-mark-mode 0)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest incremental-inactive-mark ()
  "Incremental works with a set-but-inactive mark.
Per the readme the region need not be active, but with
`transient-mark-mode' on and `mark-even-if-inactive' nil a bare `(mark)'
would signal `mark-inactive'."
  (let ((text-initial "1 2 3")
        (text-expected "2 4 6")
        (transient-mark-mode t)
        (mark-even-if-inactive nil))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (push-mark (point) t) ; Mark set, region left inactive.
      (goto-char (point-max))
      (shift-number-up-incremental 1)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Motion Tests

(ert-deftest motion-enabled ()
  "Check that shift-number-motion mark moves cursor and sets mark at number start."
  (let ((text-initial "abc 123 def")
        (text-expected "abc 124| def")
        (mark-expected 5) ; Position of "124".
        (shift-number-motion 'mark))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string)))
      (should (equal mark-expected (mark))))))

(ert-deftest motion-enabled-down ()
  "Check that shift-number-motion mark works with shift-number-down."
  (let ((text-initial "abc 123 def")
        (text-expected "abc 122| def")
        (mark-expected 5) ; Position of "122".
        (shift-number-motion 'mark))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string)))
      (should (equal mark-expected (mark))))))

(ert-deftest motion-enabled-region ()
  "Check that shift-number-motion mark works with region operations."
  (let ((text-initial "1 2 3")
        (text-expected "2 3 4|")
        (mark-expected 1) ; Position of "2" (first number in region).
        (shift-number-motion 'mark))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string)))
      (should (equal mark-expected (mark))))))

(ert-deftest motion-disabled ()
  "Check that cursor position is maintained and mark is not set when motion is disabled."
  (let ((text-initial "123")
        (text-expected "|124")
        (shift-number-motion nil))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string)))
      (should-not (mark)))))

;; Search path (`shift-number-increment-at-point-with-search', used by evil-numbers).

(ert-deftest search-motion-none ()
  "`:motion' nil leaves point at the number start on the search path."
  (let ((text-initial "123")
        (text-expected "|124"))
    (with-shift-number-test text-initial
      (shift-number-increment-at-point-with-search
       :amount 1
       :range
       (cons (point-min) (point-max))
       :motion nil)
      (cursor-marker)
      (should (equal text-expected (buffer-string)))
      (should-not (mark)))))

(ert-deftest search-motion-end ()
  "`:motion' t leaves point at the number end on the search path."
  (let ((text-initial "123")
        (text-expected "124|"))
    (with-shift-number-test text-initial
      (shift-number-increment-at-point-with-search
       :amount 1
       :range
       (cons (point-min) (point-max))
       :motion t)
      (cursor-marker)
      (should (equal text-expected (buffer-string)))
      (should-not (mark)))))

(ert-deftest search-motion-mark ()
  "`:motion' mark moves point to the end and sets mark at the start."
  (let ((text-initial "123")
        (text-expected "124|")
        (mark-expected 1)) ; Start of "124".
    (with-shift-number-test text-initial
      (shift-number-increment-at-point-with-search
       :amount 1
       :range
       (cons (point-min) (point-max))
       :motion 'mark)
      (cursor-marker)
      (should (equal text-expected (buffer-string)))
      (should (equal mark-expected (mark))))))

;; ---------------------------------------------------------------------------
;; Multi-digit and Large Number Tests

(ert-deftest large-number ()
  "Check that large numbers are handled correctly."
  (let ((text-initial "999999999")
        (text-expected "|1000000000"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest large-negative ()
  "Check that large negative numbers are handled correctly."
  (let ((text-initial "-999999999")
        (text-expected "|-1000000000"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Context Tests (number in various positions)

(ert-deftest number-at-line-start ()
  "Check number at the start of a line."
  (let ((text-initial "42 is the answer")
        (text-expected "|43 is the answer"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest number-at-line-end ()
  "Check number at the end of a line."
  (let ((text-initial "answer is 42")
        (text-expected "|answer is 43"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest number-surrounded-by-parens ()
  "Check number surrounded by parentheses."
  (let ((text-initial "foo(42)")
        (text-expected "foo(|43)"))
    (with-shift-number-test text-initial
      (forward-char 4) ; Position cursor on '4'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest number-in-array ()
  "Check number in array-like syntax."
  (let ((text-initial "[1, 2, 3]")
        (text-expected "[|2, 2, 3]"))
    (with-shift-number-test text-initial
      (forward-char 1) ; Position cursor on '1'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest number-embedded-in-word ()
  "Check number embedded within identifier-like text."
  (let ((text-initial "var1name")
        (text-expected "var|2name"))
    (with-shift-number-test text-initial
      (forward-char 3) ; Position cursor on '1'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Decimal Number Tests

(ert-deftest decimal-integer-part ()
  "Check that cursor on integer part of decimal increments integer."
  (let ((text-initial "3.14")
        (text-expected "|4.14"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest decimal-fractional-part ()
  "Check that cursor on fractional part of decimal increments fraction."
  (let ((text-initial "3.14")
        (text-expected "3.|15"))
    (with-shift-number-test text-initial
      (forward-char 2) ; Position cursor on '1'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest decimal-fractional-overflow ()
  "Check that fractional part can overflow its width."
  (let ((text-initial "3.99")
        (text-expected "3.|100"))
    (with-shift-number-test text-initial
      (forward-char 2) ; Position cursor on '9'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest decimal-cursor-on-point ()
  "Check that cursor on decimal point finds the integer part."
  (let ((text-initial "3.14")
        (text-expected "4|.14"))
    (with-shift-number-test text-initial
      (forward-char 1) ; Position cursor on '.'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest scientific-notation-mantissa ()
  "Check that scientific notation mantissa is incremented independently."
  (let ((text-initial "1e10")
        (text-expected "|2e10"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest scientific-notation-exponent ()
  "Check that scientific notation exponent is incremented independently."
  (let ((text-initial "1e10")
        (text-expected "1e|11"))
    (with-shift-number-test text-initial
      (forward-char 2) ; Position cursor on '1' in exponent.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest scientific-notation-uppercase ()
  "Check that uppercase E in scientific notation works."
  (let ((text-initial "1E10")
        (text-expected "|2E10"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest scientific-notation-negative-exponent ()
  "Check that negative exponent in scientific notation is handled."
  (let ((text-initial "1e-10")
        (text-expected "1e-|9"))
    (with-shift-number-test text-initial
      (forward-char 3) ; Position cursor on '1' in exponent.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest scientific-notation-positive-exponent ()
  "Check that explicit positive exponent in scientific notation is handled."
  (let ((text-initial "1e+10")
        (text-expected "1e+|11"))
    (with-shift-number-test text-initial
      (forward-char 3) ; Position cursor on '1' in exponent.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest scientific-notation-cursor-on-exponent-sign ()
  "Check that cursor on + in exponent finds the exponent."
  (let ((text-initial "1e+10")
        (text-expected "1e|+11"))
    (with-shift-number-test text-initial
      (forward-char 2) ; Position cursor on '+'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest scientific-notation-cursor-on-e ()
  "Check that cursor on 'e' finds the mantissa."
  (let ((text-initial "1e10")
        (text-expected "2|e10"))
    (with-shift-number-test text-initial
      (forward-char 1) ; Position cursor on 'e'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest underscore-separator ()
  "Check that underscore-separated numbers are treated as separate numbers."
  (let ((text-initial "1_000")
        (text-expected "|2_000"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest multiple-decimal-points ()
  "Check behavior with multiple decimal points like version numbers."
  (let ((text-initial "1.2.3")
        (text-expected "|2.2.3"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest multiple-decimal-points-middle ()
  "Check incrementing middle component of version number."
  (let ((text-initial "1.2.3")
        (text-expected "1.|3.3"))
    (with-shift-number-test text-initial
      (forward-char 2) ; Position cursor on '2'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest multiple-decimal-points-last ()
  "Check incrementing last component of version number."
  (let ((text-initial "1.2.3")
        (text-expected "1.2.|4"))
    (with-shift-number-test text-initial
      (forward-char 4) ; Position cursor on '3'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest all-zeros ()
  "Check that all zeros increment correctly."
  (let ((text-initial "000")
        (text-expected "|001"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest all-zeros-to-negative ()
  "Check that all zeros can decrement to negative with leading zeros."
  (let ((text-initial "000")
        (text-expected "|-001"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest scientific-notation-decimal-mantissa ()
  "Check scientific notation with decimal in mantissa."
  (let ((text-initial "1.5e10")
        (text-expected "|2.5e10"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest scientific-notation-decimal-mantissa-fractional ()
  "Check incrementing fractional part of decimal mantissa in scientific notation."
  (let ((text-initial "1.5e10")
        (text-expected "1.|6e10"))
    (with-shift-number-test text-initial
      (forward-char 2) ; Position cursor on '5'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest tab-separated-numbers ()
  "Check that tab-separated numbers work correctly."
  (let ((text-initial "1\t2\t3")
        (text-expected "1\t|3\t3"))
    (with-shift-number-test text-initial
      (forward-char 2) ; Position cursor on '2'.
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Binary Literal Tests

(ert-deftest binary-increment ()
  "Check that binary literal increments correctly."
  (let ((text-initial "0b101")
        (text-expected "|0b110"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest binary-decrement ()
  "Check that binary literal decrements correctly."
  (let ((text-initial "0b110")
        (text-expected "|0b101"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest binary-uppercase-prefix ()
  "Check that uppercase 0B prefix is preserved."
  (let ((text-initial "0B101")
        (text-expected "|0B110"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest binary-padding-preserved ()
  "Check that binary padding is preserved."
  (let ((text-initial "0b0001")
        (text-expected "|0b0010"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest binary-to-zero ()
  "Check that binary can decrement to zero."
  (let ((text-initial "0b1")
        (text-expected "|0b0"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest binary-negative ()
  "Check that negative binary literal works."
  (let ((text-initial "-0b101")
        (text-expected "|-0b110"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest binary-to-negative ()
  "Check that binary can decrement below zero."
  (let ((text-initial "0b0")
        (text-expected "|-0b1"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Octal Literal Tests

(ert-deftest octal-increment ()
  "Check that octal literal increments correctly."
  (let ((text-initial "0o42")
        (text-expected "|0o43"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest octal-decrement ()
  "Check that octal literal decrements correctly."
  (let ((text-initial "0o43")
        (text-expected "|0o42"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest octal-uppercase-prefix ()
  "Check that uppercase 0O prefix is preserved."
  (let ((text-initial "0O755")
        (text-expected "|0O756"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest octal-wrap-digit ()
  "Check that octal wraps from 7 to 10."
  (let ((text-initial "0o7")
        (text-expected "|0o10"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest octal-padding-preserved ()
  "Check that octal padding is preserved."
  (let ((text-initial "0o007")
        (text-expected "|0o010"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest octal-negative ()
  "Check that negative octal literal works."
  (let ((text-initial "-0o77")
        (text-expected "|-0o100"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest octal-to-negative ()
  "Check that octal can decrement below zero."
  (let ((text-initial "0o0")
        (text-expected "|-0o1"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Hexadecimal Literal Tests

(ert-deftest hex-increment ()
  "Check that hexadecimal literal increments correctly."
  (let ((text-initial "0xBEEF")
        (text-expected "|0xBEF0"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-decrement ()
  "Check that hexadecimal literal decrements correctly."
  (let ((text-initial "0xBEF0")
        (text-expected "|0xBEEF"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-lowercase ()
  "Check that lowercase hex is preserved."
  (let ((text-initial "0xcafe")
        (text-expected "|0xcaff"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-uppercase-prefix ()
  "Check that uppercase 0X prefix is preserved."
  (let ((text-initial "0X10")
        (text-expected "|0X11"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-padding-preserved ()
  "Check that hex padding is preserved."
  (let ((text-initial "0x00FF")
        (text-expected "|0x0100"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-wrap-f-to-10 ()
  "Check that hex F wraps to 10."
  (let ((text-initial "0xF")
        (text-expected "|0x10"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-case-upcase ()
  "Check that shift-number-case upcase forces uppercase."
  (let ((text-initial "0xcafe")
        (text-expected "|0xCAFF")
        (shift-number-case 'upcase))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-case-downcase ()
  "Check that shift-number-case downcase forces lowercase."
  (let ((text-initial "0xCAFE")
        (text-expected "|0xcaff")
        (shift-number-case 'downcase))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-case-nil-preserves ()
  "Check that shift-number-case nil preserves original case."
  (let ((text-initial "0xCaFe")
        (text-expected "|0xcaff")
        (shift-number-case nil))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-negative ()
  "Check that negative hex literal works."
  (let ((text-initial "-0xFF")
        (text-expected "|-0x100"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest hex-to-negative ()
  "Check that hex can decrement below zero."
  (let ((text-initial "0x0")
        (text-expected "|-0x1"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Superscript Number Tests

(ert-deftest superscript-increment ()
  "Check that superscript number increments correctly."
  (let ((text-initial "x⁴²")
        (text-expected "x|⁴³"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest superscript-decrement ()
  "Check that superscript number decrements correctly."
  (let ((text-initial "x⁴³")
        (text-expected "x|⁴²"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest superscript-negative ()
  "Check that negative superscript works."
  (let ((text-initial "x⁻¹")
        (text-expected "x|⁻²"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest superscript-to-negative ()
  "Check that superscript can become negative."
  (let ((text-initial "x⁰")
        (text-expected "x|⁻¹"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest superscript-single-digit ()
  "Check that single digit superscript works."
  (let ((text-initial "²")
        (text-expected "|³"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest superscript-positive-sign ()
  "Check that positive superscript sign works."
  (let ((text-initial "x⁺¹")
        (text-expected "x|⁺²"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Subscript Number Tests

(ert-deftest subscript-increment ()
  "Check that subscript number increments correctly."
  (let ((text-initial "H₂O")
        (text-expected "H|₃O"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest subscript-decrement ()
  "Check that subscript number decrements correctly."
  (let ((text-initial "H₃O")
        (text-expected "H|₂O"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest subscript-negative ()
  "Check that negative subscript works."
  (let ((text-initial "x₋₁")
        (text-expected "x|₋₂"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest subscript-multi-digit ()
  "Check that multi-digit subscript works."
  (let ((text-initial "C₁₂H₂₂O₁₁")
        (text-expected "C|₁₃H₂₂O₁₁"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest subscript-positive-sign ()
  "Check that positive subscript sign works."
  (let ((text-initial "x₊₁")
        (text-expected "x|₊₂"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest subscript-to-negative ()
  "Check that subscript can decrement below zero."
  (let ((text-initial "x₀")
        (text-expected "x|₋₁"))
    (with-shift-number-test text-initial
      (forward-char 1)
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Separator Characters Tests

(ert-deftest separator-underscore-enabled ()
  "Check that underscore separator is treated as part of number when enabled."
  (let ((text-initial "1_000_000")
        (text-expected "|1_000_001")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-underscore-large-increment ()
  "Check that underscore-separated number increments by large amount."
  (let ((text-initial "1_000_000")
        (text-expected "|2_000_000")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-up 1000000)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-comma-enabled ()
  "Check that comma separator is treated as part of number when enabled."
  (let ((text-initial "1,000,000")
        (text-expected "|1,000,001")
        (shift-number-separator-chars ","))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-disabled ()
  "Check that separator is not recognized when disabled."
  (let ((text-initial "1_000")
        (text-expected "|2_000")
        (shift-number-separator-chars nil))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-hex-underscore ()
  "Check that underscore separator works with hex literals.
Separator position is preserved relative to the end of the number."
  (let ((text-initial "0xFF_FF")
        (text-expected "|0x100_00")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-binary-underscore ()
  "Check that underscore separator works with binary literals."
  (let ((text-initial "0b1111_1111")
        (text-expected "|0b10000_0000")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-octal-underscore ()
  "Check that underscore separator works with octal literals."
  (let ((text-initial "0o77_77")
        (text-expected "|0o100_00")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-padding-width ()
  "Check that padding width counts digits only, not separator characters.
Previously the width included the separator, so \"00_10\" decremented
gave \"000_09\", growing the number by one character."
  (let ((text-initial "00_10")
        (text-expected "|00_09")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-padding-pad-default ()
  "Check that pad-default preserves the digit count with separators."
  (let ((text-initial "1_000")
        (text-expected "|0_999")
        (shift-number-separator-chars "_")
        (shift-number-pad-default t))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-padding-width-hex ()
  "Check that padding width counts hex digits only, not separators.
Exercises the base-16 formatter: \"0F_FF\" incremented previously grew
to \"0x010_00\" instead of \"0x10_00\"."
  (let ((text-initial "0x0F_FF")
        (text-expected "|0x10_00")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-padding-width-octal ()
  "Check that padding width counts octal digits only, not separators.
Exercises the base-8 formatter: \"07_77\" incremented previously grew
to \"0o010_00\" instead of \"0o10_00\"."
  (let ((text-initial "0o07_77")
        (text-expected "|0o10_00")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-padding-width-binary ()
  "Check that padding width counts binary digits only, not separators.
Exercises the base-2 formatter: \"0111_1111\" incremented previously
grew to \"0b01000_0000\" instead of \"0b1000_0000\"."
  (let ((text-initial "0b0111_1111")
        (text-expected "|0b1000_0000")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-padding-zero ()
  "Check that padding width is correct for an all-zero grouped number.
\"0_0\" incremented previously grew to \"00_1\" instead of \"0_1\"."
  (let ((text-initial "0_0")
        (text-expected "|0_1")
        (shift-number-separator-chars "_"))
    (with-shift-number-test text-initial
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-incremental-backward ()
  "Check that a separator-grouped number is changed once in backward mode.
Backward scanning previously re-found the digits before the separator
and modified them as a second number (1_000 became 3_001)."
  (let ((text-initial "1_000")
        (text-expected "|1_001")
        (shift-number-separator-chars "_")
        (shift-number-incremental-direction-from-region t))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point-max))
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-incremental-backward-multiple ()
  "Check backward scanning steps over a separator-grouped number cleanly.
The number before it must be found and use the next count (not a count
inflated by re-matching part of the separator-grouped number)."
  (let ((text-initial "5 1_000")
        (text-expected "|7 1_001")
        (shift-number-separator-chars "_")
        (shift-number-incremental-direction-from-region t))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point-max))
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-incremental-backward-dash ()
  "Check a dash separator stays literal when reporting number bounds.
A `-' must not be read as a character range while scanning the
separator-grouped number, otherwise the bounds collapse and the
leading digit is modified a second time."
  (let ((text-initial "1-000")
        (text-expected "|1-001")
        (shift-number-separator-chars "-")
        (shift-number-incremental-direction-from-region t))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point-max))
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest separator-incremental-backward-multichar ()
  "Check a multi-character separator list containing a dash works.
A dash anywhere but the end of the list used to form a range with the
preceding character and silently drop every separator, re-exposing the
double-modify bug."
  (let ((text-initial "1_000")
        (text-expected "|1_001")
        (shift-number-separator-chars "-_")
        (shift-number-incremental-direction-from-region t))
    (with-shift-number-test text-initial
      (goto-char (point-min))
      (set-mark (point-max))
      (shift-number-up-incremental 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Padding Default Option Tests

(ert-deftest pad-default-enabled ()
  "Check that shift-number-pad-default preserves width when number shrinks."
  (let ((text-initial "10")
        (text-expected "|09")
        (shift-number-pad-default t))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest pad-default-disabled ()
  "Check that shift-number-pad-default disabled doesn't pad."
  (let ((text-initial "9")
        (text-expected "|8")
        (shift-number-pad-default nil))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(ert-deftest pad-default-leading-zeros-always-pad ()
  "Check that leading zeros are preserved regardless of pad-default."
  (let ((text-initial "09")
        (text-expected "|08")
        (shift-number-pad-default nil))
    (with-shift-number-test text-initial
      (shift-number-down 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

;; ---------------------------------------------------------------------------
;; Region Cursor Position Tests

(ert-deftest region-cursor-with-motion ()
  "Check that shift-number-motion t positions cursor at end without mark."
  (let ((text-initial "1 2 3")
        (text-expected "2 3 4|")
        (shift-number-motion t))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string)))
      ;; Mark should not be changed to number position.
      (should (equal 1 (mark))))))

(ert-deftest region-cursor-without-motion ()
  "Check that cursor is at beginning of last number when motion is nil."
  (let ((text-initial "1 2 3")
        (text-expected "2 3 |4")
        (shift-number-motion nil))
    (with-shift-number-test text-initial
      (transient-mark-mode 1)
      (goto-char (point-min))
      (set-mark (point))
      (goto-char (point-max))
      (shift-number-up 1)
      (cursor-marker)
      (should (equal text-expected (buffer-string))))))

(provide 'shift-number-tests)
;;; shift-number-tests.el ends here
