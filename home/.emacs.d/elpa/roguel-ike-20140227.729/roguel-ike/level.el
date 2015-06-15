;;; level.el --- Contains the data structures relative to levels

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
;; Defines roguel-ike level structure

;;; Code:
(require 'eieio)
(require 'roguel-ike/time-manager)
(require 'roguel-ike/physics/world)
(require 'roguel-ike/level/cell)

(defgeneric is-hero-p (entity)
  "Return t is the ENTITY is the hero.")

(defvar-local rlk--local-controller nil)

(defclass rlk--level ()
  ((cells :initarg :cells
          :type list
          :reader get-cells
          :protection :private
          :documentation "A two-dimensional list of cells")
   (time-manager :type rlk--time-manager
                 :reader get-time-manager
                 :protection :private
                 :documentation "Time management algorithm.")
   (physics-world :type rlk--physics-world
                  :reader get-physics-world
                  :protection :private
                  :documentation "Physics world."))
  "Represents a game level")

(defmethod initialize-instance :after ((self rlk--level) slots)
  "Initialize the time manager."
  (oset self time-manager (rlk--time-manager "Level time manager"))
  (oset self physics-world (rlk--physics-world "Physics world"))
  (add-after-step-hook (get-time-manager self)
                       (apply-partially (lambda (self)
                                          (run-world self))
                                        self)))

(defmethod get-height ((self rlk--level))
  "Return the horizontal number of cells."
  (length (oref self cells)))

(defmethod get-width ((self rlk--level))
  "Return the vertical number of cells."
  (if (eq (get-height self) 0)
      0
    (length (car (oref self cells)))))

(defmethod get-cell-at ((self rlk--level) x y)
  "Return the cell at position x, y."
  (nth x (nth y (get-cells self))))

(defmethod get-accessible-cells-pos ((self rlk--level))
  "Return all the accessible cells in the level."
  (let ((cells '()))
    (dotimes (x (get-width self))
      (dotimes (y (get-height self))
        (when (is-accessible-p (get-cell-at self x y))
          (add-to-list 'cells (cons x y)))))
    cells))

(defmethod get-controller ((self rlk--level))
  "Return the current controller."
  rlk--local-controller)

(defmethod add-entity ((self rlk--level) entity)
  "Add an entity to the level."
  (insert-object (get-time-manager self) entity))

(defmethod remove-entity ((self rlk--level) entity)
  "Remove an entity from the level."
  (remove-object (get-time-manager self) entity)
  (when (is-hero-p entity)
    (stop self)))

(defmethod get-lit-entities ((self rlk--level))
  "Return all entities standing on lit cells in the level."
  (let ((entities '()))
    (dolist (line (get-cells self))
      (dolist (cell line)
        (when (and (is-lit-p cell)
                   (is-container-p cell)
                   (has-entity-p cell))
          (add-to-list 'entities (get-entity cell)))))
    entities))

(defmethod add-motion ((self rlk--level) entity direction energy)
  "Create a motion affecting ENTITY, for the given DIRECTION and ENERGY.

DIRECTION is a vector represented by a cons in the form (DX . DY)."
  (add-motion (get-physics-world self) (rlk--physics-motion "Motion"
                                                            :object entity
                                                            :direction direction
                                                            :energy energy)))

(defmethod run-world ((self rlk--level))
  "Update the world's motions."
  (run (get-physics-world self) (apply-partially 'call-renderers
                                                 (get-controller self))))

(defmethod stop ((self rlk--level))
  "Stop the current level."
  (stop (get-time-manager self))
  (stop (get-physics-world self)))

(provide 'roguel-ike/level)
;;; level.el ends here
