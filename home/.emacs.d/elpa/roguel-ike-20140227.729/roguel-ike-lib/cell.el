;;; cell.el --- Cell generics

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
;; Define the generics a cell can implement in order to
;; be used in various algorithms.

;;; Code:
(require 'eieio)

;;;;;;;;;;;;;
;; Display ;;
;;;;;;;;;;;;;

(defgeneric get-visible-type (cell)
  "Return the type that should be used for the CELL display.

For a wall, it could be :wall.
For a ground on which the hero is standing, it could be :hero.
For a cell the player currently doesn't see, it could be :shadow.")

;;;;;;;;;;;;;;
;; Lighting ;;
;;;;;;;;;;;;;;

(defgeneric is-lit-p (cell)
  "Return t is the cell is visible.

A cell is visible for example when the hero can see it.")

(defgeneric set-lit (cell lit)
  "Set the CELL's lit state.

Setting LIT to t means the cell is currently visible.")

(defgeneric block-light-p (cell)
  "Return t if nothing behing the cell should be visible.")

(defmethod set-visited (cell visited)
  "Set the CELL's visited state.

VISITED is a boolean.

This method is a placeholder that does nothing"
  nil)

(provide 'roguel-ike-lib/cell)

;;; cell.el ends here
