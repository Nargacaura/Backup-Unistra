.. _class_Action:

Action
======


.. _class_Action_constants:

Constants
---------

+-----+-------------------------------------------------------------------------+
| int | :ref:`ACTION_SHORT_TIMEOUT<class_Action_constant_ACTION_SHORT_TIMEOUT>` |
+-----+-------------------------------------------------------------------------+
| int | :ref:`ACTION_TIMEOUT<class_Action_constant_ACTION_TIMEOUT>`             |
+-----+-------------------------------------------------------------------------+


.. _class_Action_properties:

Properties
----------

+-------+-------------------------------------------------------------------+
| int   | :ref:`_action_type<class_Action_property__action_type>`           |
+-------+-------------------------------------------------------------------+
| int   | :ref:`_sender_id<class_Action_property__sender_id>`               |
+-------+-------------------------------------------------------------------+
| Array | :ref:`_targets_id<class_Action_property__targets_id>`             |
+-------+-------------------------------------------------------------------+
| int   | :ref:`_cost<class_Action_property__cost>`                         |
+-------+-------------------------------------------------------------------+
| bool  | :ref:`_can_be_countered<class_Action_property__can_be_countered>` |
+-------+-------------------------------------------------------------------+
| bool  | :ref:`_can_be_doubted<class_Action_property__can_be_doubted>`     |
+-------+-------------------------------------------------------------------+
| int   | :ref:`_card_type<class_Action_property__card_type>`               |
+-------+-------------------------------------------------------------------+


.. _class_Action_methods:

Methods
-------

+------+-------------------------------------------------------------------------------------------+
| int  | :ref:`_calculate_action_cost<class_Action_method__calculate_action_cost>` **(** **)**     |
+------+-------------------------------------------------------------------------------------------+
| bool | :ref:`_can_action_be_countered<class_Action_method__can_action_be_countered>` **(** **)** |
+------+-------------------------------------------------------------------------------------------+
| bool | :ref:`_can_action_be_doubted<class_Action_method__can_action_be_doubted>` **(** **)**     |
+------+-------------------------------------------------------------------------------------------+


.. _class_Action_static_methods:

Static Methods
--------------

+--------+-----------------------------------------------------------------------------------------------------------------+
| String | :ref:`get_action_string<class_Action_static_method_get_action_string>` **(** **int** action_type **)**          |
+--------+-----------------------------------------------------------------------------------------------------------------+
| String | :ref:`get_counters<class_Action_static_method_get_counters>` **(** **int** action_type **)**                    |
+--------+-----------------------------------------------------------------------------------------------------------------+
| String | :ref:`is_main_action<class_Action_static_method_is_main_action>` **(** :ref:`Action<class_Action>` action **)** |
+--------+-----------------------------------------------------------------------------------------------------------------+


.. _class_Action_enums:

Enumerations
------------

+------+---------------------------------------------------+
| enum | :ref:`ACTION_TYPE<class_Action_enum_ACTION_TYPE>` |
+------+---------------------------------------------------+


.. _class_Action_constants_description:

Constants Descriptions
----------------------

.. _class_Action_constant_ACTION_SHORT_TIMEOUT:

- const int **ACTION_SHORT_TIMEOUT**

Time to wait after a short action is made.

----

.. _class_Action_constant_ACTION_TIMEOUT:

- const int **ACTION_TIMEOUT**

Time to let the players react to a *long* action.


.. _class_Action_properties_description:

Properties Descriptions
-----------------------

.. _class_Action_property__action_type:

- int **_action_type**

The type of action.

----

.. _class_Action_property__sender_id:

- int **_sender_id**

ID of the player that made the action.

----

.. _class_Action_property__targets_id:

- Array **_targets_id**

Array containing the ID of the players targeted by the action.

----

.. _class_Action_property__cost:

- int **_cost**

The cost of the action.

----

.. _class_Action_property__can_be_countered:

- bool **_can_be_countered**

If the action can be countered.

----

.. _class_Action_property__can_be_doubted:

- bool **_can_be_doubted**

If the action can be doubted.

----

.. _class_Action_property__card_type:

- int **_card_type**

The card type that made the action


.. _class_Action_methods_description:

Methods Descriptions
--------------------

.. _class_Action_method__calculate_action_cost:

- int **_calculate_action_cost (** **)**

**Description:** Method called in the constructor to return the action cost.

----

.. _class_Action_method__can_action_be_countered:

- bool **_can_action_be_countered (** **)**

**Description:** Method called in the constructor to return a boolean that tells if the action can be countered.

----

.. _class_Action_method__can_action_be_doubted:

- bool **_can_action_be_doubted (** **)**

**Description:** Method called in the constructor to return a boolean that tells if the action can be doubted.


.. _class_Action_static_methods_description:

Static Methods Descriptions
---------------------------

.. _class_Action_static_method_get_action_string:

- static String **get_action_string (** **int** action_type **)**

**Description:** Static Method to get the short description of the action.


**Method parameters:**


- int **action_type**: Type of the action.

----

.. _class_Action_static_method_get_counters:

- static String **get_counters (** **int** action_type **)**

**Description:** Static Method to get the counters of the action.


**Method parameters:**


- int **action_type**: Type of the action.

----

.. _class_Action_static_method_is_main_action:

- static String **is_main_action (** :ref:`Action<class_Action>` action **)**

**Description:** Static Method that checks if the action is a main action.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: Action to check.


.. _class_Action_enums_description:

Enumerations Descriptions
-------------------------

.. _class_Action_enum_ACTION_TYPE:

enum **ACTION_TYPE**:

**Description:** Enumeration to store action types in a human readable way.

- **START**: The first action on the action stack.
- **END**: The last action on the action stack.
- **PASS**: When a player decide to pass in the reaction phase.
- **DOUBT**: A player doubts another player's action.
- **COUNTER**: A player counters another player's action.
- **INCOME**: Basic action, takes one coin to the Court.
- **FOREIGN_AID**: Takes two coins to the Court.
- **COUP**: Kill a player card for the price of 7 coins.
- **DUKE**: Takes three coins to the Court.
- **ASSASSIN**: Kill a player card for the price of 3 coins.
- **CONTESSA**: Should not be on the action stack.
- **CAPTAIN**: Takes two coins to a player.
- **AMBASSADOR**: Switch two of the alive player cards.
- **INQUISITOR_1**: Switch one of the alive player cards.
- **INQUISITOR_2**: Look at one card of a given player, choose to leave it in their hand or send it back to the Court.
