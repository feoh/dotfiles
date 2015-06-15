;;; dispatcher.el --- Event dispatch system

;; Copyright (C) 2014 Steven Rémot

;;; Author: Steven Rémot

;;; License:
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Defines a lightweight event dispatcher

;;; Code:
(require 'eieio)

(defclass roguel-ike-dispatcher ()
  ((hooks :type hash-table
          :protection :private
          :documentation "A hash table making the link between events and functions."))
  "An event dispatcher.

For each kind of event, one can register functions that will
be called on event dispatch.

There is no restriction regarding the arguments provided on dispatch.")

(defmethod initialize-instance :after ((self roguel-ike-dispatcher) slots)
  "Initialize hooks."
  (oset self hooks (make-hash-table)))

(defmethod register ((self roguel-ike-dispatcher) event function)
  "Ask the dispatcher to call FUNCTION on EVENT dispatch."
  (let* ((hooks (oref self hooks))
         (hook (gethash event hooks '())))
    (add-to-list 'hook function)
    (puthash event hook hooks)))

(defmethod unregister ((self roguel-ike-dispatcher) event function)
  "Ask the dispatcher not to call FUNCTION on EVENT dispatch."
  (let* ((hooks (oref self hooks))
         (hook (gethash event hooks '())))
    (puthash event (delete function hook) hooks)))

(defmethod dispatch ((self roguel-ike-dispatcher) event &rest arguments)
  "Call all functions associated to EVENT with ARGUMENTS."
  (let* ((hooks (oref self hooks))
         (hook (gethash event hooks '())))
    (apply 'run-hook-with-args 'hook arguments)))

(provide 'roguel-ike-lib/dispatcher)
;;; dispatcher.el ends here
