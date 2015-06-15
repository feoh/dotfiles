;;; entity.el --- Manages game entities

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
;; Define roguel-ike moving entities

;;; Code:
(require 'roguel-ike/stats/regenerator)
(require 'roguel-ike/level/cell/object)
(require 'roguel-ike/message-logger)
(require 'roguel-ike/race)
(require 'roguel-ike-lib/dispatcher)

;;;;;;;;;;;;;;
;; Generics ;;
;;;;;;;;;;;;;;

(defgeneric set-entity (cell entity)
  "Set the ENTITY standing on CELL.")

;;;;;;;;;;;;;;;;;;;;;
;; Abstract entity ;;
;;;;;;;;;;;;;;;;;;;;;

(defclass rlk--entity (rlk--level-cell-object)
  ((stats :initarg :stats
          :type rlk--stats
          :reader get-stats
          :protection :protected
          :documentation "The entity's statistics.")
   (race :initarg :race
         :type rlk--race
         :reader get-race
         :protection :private
         :documentation "The entity's race.")
   (message-logger :initarg :message-logger
                   :type rlk--message-logger
                   :reader get-message-logger
                   :writer set-message-logger
                   :protection :private
                   :documentation "The logger used to display entitie's messages.")
   (behaviour :initarg :behaviour
              :reader get-behaviour
              :protection :private
              :documentation "Entity's behaviour.")
   (dispatcher :reader get-dispatcher
               :type roguel-ike-dispatcher
               :protection :private
               :documentation "Entity's event dispatcher.

Here are the events that can occur to an entity with their arguments:

* :moved
  Occur when the entity does a move.

* :attacked
  Occur when the entity succesfully attacks

* :used-skill
  Occur when the entity succesfully use a skill

* :used-physical-skill
  Occur when the entity succesfully use a physical skill

* :used-magical-skill
  Occur when the entity succesfully use a magical skill

* :received-damages
  Occur when the entity is hurt by something

* :turns-spent NB-TURNS
  Occur when the entity does an action that spends a turn.
  NB-TURNS is the number of turns the action took.

* :died
  Occur when the entity dies, just before it is removed from the level.")
   (current-effects :initform ()
                    :reader get-current-effects
                    :type list
                    :protection :private
                    :documentation "Return the current effects appliers associated to the entity."))
  "The base class for game entities.")

(defmethod initialize-instance :after ((self rlk--entity) slots)
  "Initializes entity's objects."
  (set-entity (get-behaviour self) self)
  (oset self dispatcher (roguel-ike-dispatcher "Entity dispatcher"))
  (register (get-dispatcher (get-stat-slot self :health))
            :current-value-changed
            (apply-partially (lambda (self old-value new-value)
                               (when (<= new-value 0)
                                 (die self)))
                             self))

  (let ((regenerator (rlk--stats-regenerator "Entity's stat regenerator"
                                             :stats (get-stats self)
                                             :slots '(:health
                                                      :stamina
                                                      :strength
                                                      :constitution
                                                      :speed
                                                      :spirit))))
    (register (get-dispatcher self)
              :turns-spent
              (apply-partially 'add-turns regenerator))
    (setup-experience-system self)))

(defmethod get-layer ((self rlk--entity))
  "See rlk--level-cell-object."
  3)

(defmethod is-entity-p ((self rlk--entity))
  "See rlk--level-cell-object."
  t)

(defmethod get-type ((self rlk--entity))
  "See rlk--level-cell-object."
  (if (is-hero-p self)
      :hero
    (get-type (get-race self))))

(defmethod accept-other-object-p ((self rlk--entity))
  "See rlk--level-cell-object."
  nil)

(defmethod format-message ((self rlk--entity) message)
  "Create a string from MESSAGE.

If MESSAGE is a string, simply return it.

If MESSAGE is a list, each of its elements will be converted to a string using this rules:
- If the element is a string, use it
- If the element is the symbol `Me', use SELF's name
- If the element is the symbol `me', use SELF's name downcased
- If it is a cons, its elements will be sent to `get-verb'
- Otherwise, use the item's string representation"
  (if (stringp message)
      message
    (let ((result ""))
      (dolist (item message)
        (setq result (concat result
                             (if (> (length result) 0)
                                 " "
                               "")
                             (cond ((stringp item)
                                      item)
                                   ((eq 'Me item)
                                    (get-name self))
                                   ((eq 'me item)
                                    (downcase (get-name item)))
                                   ((consp item)
                                    (get-verb self (car item) (cdr item)))
                                   (t
                                    (prin1-to-string item))))))
      result)))

(defmethod display-message ((self rlk--entity) message &rest format-arguments)
  "Use the message logger to display a message."
  (apply 'display-message
         (get-message-logger self)
         (format-message self message)
         format-arguments))


(defmethod set-level :before ((self rlk--entity) level)
  "See rlk--level-cell-object.
Unregister from the old level"
  (when (slot-boundp self 'level)
    (remove-entity (get-level self) self)))

(defmethod set-level :after ((self rlk--entity) level)
  "See rlk--level-cell-object.
Register to the new level."
  (add-entity level self))

(defmethod set-cell ((self rlk--entity) cell)
  "Set the new cell of the entity.
This method is instead for private use ONLY.
If you want to change entity position, use set-pos instead."
  (let ((old-cell (get-cell self)))
    (when (is-container-p old-cell)
      (set-entity old-cell nil))
    (set-entity cell self)))

(defmethod try-move ((self rlk--entity) dx dy)
  "If the entity can move to the cell (x + DX, y + DY), will move to it.
Return t if the entity could move, nil otherwise."
  (when (call-next-method)
    (dispatch (get-dispatcher self) :moved)
    t))

(defmethod is-alive-p ((self rlk--entity))
  "Return t if the entity is alive, nil otherwise."
  (> (get-health self) 0))

(defgeneric is-manual-p (behaviour)
  "Return t when the behaviour is manual, nil otherwise.")

(defmethod is-hero-p ((self rlk--entity))
  "Return t if the entity is the hero, nil otherwise."
  (is-manual-p (get-behaviour self)))

;;;;;;;;;;;;;;;;;;;;;;
;; Slot interaction ;;
;;;;;;;;;;;;;;;;;;;;;;

(defmethod get-stat-slot ((self rlk--entity) slot)
  "Return the stat slot SLOT."
  (get-slot (get-stats self) slot))

(defmethod get-max-health ((self rlk--entity))
  "Return the maximum health the entity can have."
  (get-base-value (get-stat-slot self :health)))

(defmethod get-health ((self rlk--entity))
  "Return the entity's current health."
  (get-current-value (get-stat-slot self :health)))

(defmethod set-health ((self rlk--entity) health)
  "Set entity's current health to HEALTH."
  (set-current-value (get-stat-slot self :health) health))

(defmethod hurt ((self rlk--entity) points)
  "Substract to the entity's heatlh POINT health points."
  (dispatch (get-dispatcher self) :received-damages)
  (set-health self (- (get-health self) points)))

(defmethod die ((self rlk--entity))
  "Make the entity disappear from the level."
  (display-message self '(Me ("die." . "dies.")))
  (dispatch (get-dispatcher self) :died)
  (remove-entity (get-level self) self)
  (set-entity (get-cell self) nil))

(defmethod heal ((self rlk--entity) points)
  "Add to the entity's current health POINT health points."
  (set-health self (+ (get-health self) points))
  (when (> (get-health self) (get-max-health self))
    (set-health self (get-max-health self))))

(defmethod get-strength ((self rlk--entity))
  "Return the entity's current strength."
  (get-current-value (get-stat-slot self :strength)))

(defmethod get-constitution ((self rlk--entity))
  "Return the entity's constitution."
  (get-current-value (get-stat-slot self :constitution)))

(defmethod get-speed ((self rlk--entity))
  "Return the entity's current speed."
  (get-current-value (get-stat-slot self :speed)))

(defmethod get-spirit ((self rlk--entity))
  "Return the entity's current spirit."
  (get-current-value (get-stat-slot self :spirit)))

(defmethod add-experience ((self rlk--entity) slot experience)
  "Add experience point to a slot.

SLOT is a stat slot name.

EXPERIENCE is the amount of experience to add."
  (add-experience (get-stat-slot self slot) experience))

(defmethod setup-experience-system ((self rlk--entity))
  "Register all handlers for the experience system."
  (let ((dispatcher (get-dispatcher self)))
    (register dispatcher :attacked (apply-partially 'add-experience
                                                    (get-stat-slot self :strength)
                                                    1))
    (register dispatcher :used-physical-skill (apply-partially 'add-experience
                                                               (get-stat-slot self :strength)
                                                               1))
    (register dispatcher :received-damages (apply-partially 'add-experience
                                                            (get-stat-slot self :constitution)
                                                            1))
    (register dispatcher :received-damages (apply-partially 'add-experience
                                                            (get-stat-slot self :health)
                                                            1))
    (register dispatcher :used-skill (apply-partially 'add-experience
                                                      (get-stat-slot self :stamina)
                                                      1))
    (register dispatcher :moved (apply-partially 'add-experience
                                                 (get-stat-slot self :speed)
                                                 1))
    (register dispatcher :used-magical-skill (apply-partially 'add-experience
                                                              (get-stat-slot self :spirit)
                                                              1))))

;;;;;;;;;;;;;
;; Effects ;;
;;;;;;;;;;;;;

(defmethod register-effect-applier ((self rlk--entity) applier)
  "Add the APPLIER to the list of the current applied effects."
  (oset self current-effects (append (get-current-effects self) (list applier))))

(defmethod unregister-effect-applier ((self rlk--entity) applier)
  "Remove APPLIER from registered effect appliers."
  (oset self current-effects (delete applier (get-current-effects self))))

;;;;;;;;;;;;
;; Action ;;
;;;;;;;;;;;;

(defmethod do-action ((self rlk--entity) callback)
  "Update the ennemy, returning the turns spent to CALLBACK."
  (do-action (get-behaviour self) callback))

(defmethod spend-time ((self rlk--entity) nb-turns)
  "Dispach an event :turns-spent, with NB-TURNS as parameter."
  (dispatch (get-dispatcher self) :turns-spent nb-turns))

;;;;;;;;;;;;;
;; Physics ;;
;;;;;;;;;;;;;

(defmethod collide-with-cell ((self rlk--entity) cell direction energy)
  "If CELL has an entity, transfer half of ENERGY to it.
The entity is hurt with the remaining ENERGY."
  (let ((damages energy)
        (half-energy (/ energy 2)))
    (when (and (is-container-p cell)
               (has-entity-p cell)
               (> half-energy 0))
      (project (get-entity cell)
               direction
               half-energy)
      (setq damages (- energy half-energy)))
    (setq damages (compute-damages self damages))
    (display-message self '(Me ("take" . "takes") "%i projection damages.")
                     damages)
    (hurt self damages)))

(defmethod project ((self rlk--entity) direction energy)
  "Create a motion projection itself in DIRECTION for the given ENERGY.

Won't project itself if dead."
  (when (is-alive-p self)
    (add-motion (get-level self) self direction energy)))


;;;;;;;;;;;;;;;;;;;
;; Combat system ;;
;;;;;;;;;;;;;;;;;;;

(defmethod attack-successfull-p ((self rlk--entity) target)
  "Return nil if the TARGET dodged the attack, t otherwise.
This method contains randomness."
  (= 0 (random (floor (max (- (get-speed target) (get-speed self)) 1)))))

(defmethod get-base-damages ((self rlk--entity))
  "Return the base damages the entity can inflict."
  (get-strength self))

(defmethod compute-damages ((self rlk--entity) base-damages)
  "Return the number of damages that will be inflicted to itself.

BASE-DAMAGES is the initial damages inflicted. This method computes
the effective damages according to the entity's constitution.

This method contains randomness."
  (random (1+ (max  (- base-damages (get-constitution self)) 1))))

(defmethod attack ((self rlk--entity) target)
  "Try to attack the target.
This method contains randomness."
  (if (attack-successfull-p self target)
      (let ((damages (compute-damages target (get-base-damages self))))
        (display-message self '(Me ("attack" . "attacks") "%s for %d damages")
                         (downcase (get-name target))
                         damages)
        (hurt target damages)
        (dispatch (get-dispatcher self) :attacked))
    (display-message self '(Me ("miss" . "misses") "%s")
                     (downcase (get-name target)))))

;;;;;;;;;;;;
;; Skills ;;
;;;;;;;;;;;;

(defmethod fulfill-skill-requirements-p ((self rlk--entity) skill)
  "Return t if the entity's stats fulfill the skill's requirements.

Return nil otherwise."
  (catch 'fulfilled
    (dolist (req-cons (get-requirements skill))
      (when (< (get-current-value (get-stat-slot self (car req-cons)))
               (cdr req-cons))
        (throw 'fulfilled nil)))
    t))

(defmethod can-use-skill-now-p ((self rlk--entity) skill)
  "Return t if the entity can use the SKILL.

An entity can use a skill when its stats fulfill the requirements
and it has enough to be spend by the skill."
  (and (fulfill-skill-requirements-p self skill)
       (catch 'can-spend
         (dolist (spend-cons (get-spend skill))
           (when (< (get-current-value (get-stat-slot self (car spend-cons)))
                    (cdr spend-cons))
             (throw 'can-spend nil)))
         t)))

(defmethod spend-stats-for-skill ((self rlk--entity) skill)
  "Withdraw from entity's stats the SKILL's spend numbers."
  (let ((slot nil))
    (dolist (spend-cons (get-spend skill))
      (setq slot (get-stat-slot self (car spend-cons)))
      (set-current-value slot (- (get-current-value slot) (cdr spend-cons))))))

(defmethod use-skill ((self rlk--entity) skill &rest action-arguments)
  "Use the skill SKILL.

Assume all checks have been done before.

Return t when the skill's action could be done, nil otherwise.

ACTION-ARGUMENTS are the optional and various arguments that depends on the
SKILL's tags."
  (let ((arguments (append (list self) action-arguments))
        (dispatcher (get-dispatcher self)))
    (if (apply 'do-action skill arguments)
        (progn
          (spend-stats-for-skill self skill)
          (dispatch dispatcher :used-skill)

          (when (has-tag-p skill :physical)
            (dispatch dispatcher :used-physical-skill))

          (when (has-tag-p skill :magical)
            (dispatch dispatcher :used-magical-skill))

          t)
      nil)))

(defmethod get-usable-skills ((self rlk--entity))
  "Return the skills the entity can use now."
  (let ((usable-skills '()))
    (dolist (skill (get-skills (get-race self)))
      (when (can-use-skill-now-p self skill)
        (add-to-list 'usable-skills skill)))
    usable-skills))

;;;;;;;;;;;;;;
;; Messages ;;
;;;;;;;;;;;;;;

(defmethod get-name ((self rlk--entity))
  "Return the entity name."
  (if (is-hero-p self)
      "You"
    (concat "The " (get-name (get-race self)))))

(defmethod get-verb ((self rlk--entity) you-verb other-verb)
  "Return YOU-VERB when entity is the main character, OTHER-VERB otherwise."
  (if (is-hero-p self)
      you-verb
    other-verb))

;;;;;;;;;;;;;;;;;;;;;
;; Entity creation ;;
;;;;;;;;;;;;;;;;;;;;;


(defun rlk--entity-create-stats-from-list-and-race (race list)
  "Create stats using RACE and LIST.

RACE is a rlk--race.
LIST is a plist which keys are stat slot names, and values
are base-values, or conses in the form (base-value . experience)."

  (let ((stats-slots '())
        (slot-names '(:health
                      :stamina
                      :strength
                      :constitution
                      :speed
                      :spirit))
        (race-evolution (get-stats-evolution race)))
    (dolist (name slot-names)
      (let* ((slot-base-value (plist-get list name))
             (base-value (if (numberp slot-base-value)
                            slot-base-value
                          (car slot-base-value)))
             (experience (if (numberp slot-base-value)
                             0
                           (cdr slot-base-value)))
             (experience-rate (plist-get race-evolution name)))
        (add-to-list 'stats-slots (cons name
                                        (rlk--stats-slot (format "%s slot" name)
                                                         :base-value base-value
                                                         :experience experience
                                                         :experience-rate experience-rate)))))
    (rlk--stats "Stats"
                :slots stats-slots)))

(defun rlk--entity-create (race stats behaviour)
  "Create an entity.
RACE is the race of the entity.
STATS is the current statistics of the entity, in the form of a plist.
BEHAVIOUR is the entity's behaviour.
MESSAGE-LOGGER is the message logging system used by the entity."
  (when (symbolp race)
    (setq race (rlk--race-get-race race)))

  (rlk--entity "Entity"
               :race race
               :stats (rlk--entity-create-stats-from-list-and-race race
                                                                   stats)
               :behaviour behaviour))

(defun rlk--entity-create-new (race behaviour)
  "Create a new entity.
RACE is the race of the new entity.  Its statistics are the RACE's base
statistics.
BEHAVIOUR is the entity's behaviour.
MESSAGE-LOGGER is the message logging system used by the entity."
  (when (symbolp race)
    (setq race (rlk--race-get-race race)))
  (rlk--entity-create race (get-base-stats race) behaviour))

(provide 'roguel-ike/entity)
;;; entity.el ends here
