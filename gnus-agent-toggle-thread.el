;;; gnus-agent-toggle-thread.el --- Mark whole threads in gnus agent

;; Copyright (C) 1999 by Tom Breton

;; Author: Tom Breton <tob@world.std.com>
;; Keywords: news, extensions
;; Version: 1.1

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Usage:

;; Include this code in .gnus.el, and use the key sequence "T%" in the
;; summary buffer to toggle the download marks on a thread or
;; sub-thread. 

;; Ordinarily you will want the cursor to be at the top of a thread
;; when you do this.  If you invoke it somewhere else, it will toggle
;; the downloadmarks on the following sub-thread.

;;; Commentary:

;; tehom-gnus-summary-act-on-articles is similar to
;; gnus-summary-iterate but carefully doesn't change the process marks

;;; Changes from 1.0

;; Changed cursor-position handling to support gnus 5.8.x

;;; Code:

(defun tehom-gnus-summary-act-on-articles (func &optional arg)
  "Perform the given operation on all articles that are process/prefixed."

  (let ((articles (gnus-summary-work-articles arg))
	 article)
    (if 
      (or
	(not (commandp func ))
	(eq func 'undefined))

      (gnus-error 1 "Undefined function")
      (save-excursion
	(while articles
	  (gnus-summary-goto-subject (setq article (pop articles)))
	  (let (gnus-newsgroup-processable)
	    (command-execute func))
	  (gnus-summary-remove-process-mark article)))))
  (gnus-summary-position-point))


(defun tehom-gnus-agent-toggle-dl-thread (arg)
  "Toggle an entire thread for agent downloading."
  (interactive "P")

  
  (save-excursion
    (gnus-uu-mark-thread))
  (tehom-gnus-summary-act-on-articles 'gnus-agent-toggle-mark arg)
  (gnus-summary-next-thread 1 t))


;;Bind the command to a reasonable unused key sequence.  By this time,
;;gnus-sum.el has been loaded, so do this.  If it hadn't been loaded,
;;we'd use gnus-sum-load-hook instead.
(define-key gnus-summary-mode-map "T%"
	'tehom-gnus-agent-toggle-dl-thread)

;;; gnus-agent-toggle-thread.el ends here

