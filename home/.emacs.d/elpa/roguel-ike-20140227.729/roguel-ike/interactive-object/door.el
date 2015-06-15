;;; door.el --- Dungeon door

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
;; Defines a dungeon door

;;; Code:
(require 'roguel-ike/interactive-object)

(defclass rlk--interactive-object-door (rlk--interactive-object)
  ((opened :initform nil
          :type boolean
          :reader is-opened-p
          :protection :private
          :documentation "Tell whether the door is opened or not."))
  "A door that can be opened and closed.
An entity cannot pass when door is closed.")

(defmethod get-type ((self rlk--interactive-object-door))
  "See rlk--level-cell-object."
  (if (is-opened-p self)
      :door-opened
    :door-closed))

(defmethod accept-other-object-p ((self rlk--interactive-object-door))
  "See rlk--level-cell-object."
  (is-opened-p self))

(defmethod block-light-p ((self rlk--interactive-object-door))
  "See rlk--level-cell-object."
  (not (is-opened-p self)))

(defmethod do-action ((self rlk--interactive-object-door) hero action)
  "Close / open the door.
When the action is :open and the door is closed, open it.
When the action is :close and the door is open, close it."
  (cond
   ((and (is-opened-p self) (equal action :close))
    (oset self opened nil)
    t)
   ((and (not (is-opened-p self)) (equal action :open))
    (oset self opened t)
    t)
   (t
    nil)))

(provide 'roguel-ike/interactive-object/door)

;;; door.el ends here
