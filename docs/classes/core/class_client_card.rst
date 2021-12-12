.. _class_Card:

Card
====


.. _class_Card_properties:

Properties
----------

+-------+-------------------------------------------------------+
| int   | :ref:`_type<class_Card_property__type>`               |
+-------+-------------------------------------------------------+
| Array | :ref:`_counters<class_Card_property__counters>`       |
+-------+-------------------------------------------------------+
| bool  | :ref:`_is_dead<class_Card_property__is_dead>`         |
+-------+-------------------------------------------------------+
| bool  | :ref:`_is_selected<class_Card_property__is_selected>` |
+-------+-------------------------------------------------------+


.. _class_Card_methods:

Methods
-------

+--------+---------------------------------------------------------------------------------+
| String | :ref:`get_name<class_Card_method_get_name>` **(** **)**                         |
+--------+---------------------------------------------------------------------------------+
| void   | :ref:`kill<class_Card_method_kill>` **(** **)**                                 |
+--------+---------------------------------------------------------------------------------+
| void   | :ref:`_set_default_counter<class_Card_method__set_default_counter>` **(** **)** |
+--------+---------------------------------------------------------------------------------+


.. _class_Card_static_methods:

Static Methods
--------------

+--------+---------------------------------------------------------------------------------------+
| String | :ref:`get_card_name<class_Card_static_method_get_card_name>` **(** **int** type **)** |
+--------+---------------------------------------------------------------------------------------+


.. _class_Card_enums:

Enumerations
------------

+------+---------------------------------------------+
| enum | :ref:`CARD_TYPE<class_Card_enum_CARD_TYPE>` |
+------+---------------------------------------------+


.. _class_Card_properties_description:

Properties Descriptions
-----------------------

.. _class_Card_property__type:

- int **_type**

The type of card.

----

.. _class_Card_property__counters:

- Array **_counters**

Array of counters, elements are of type **Action.ACTION_TYPE**.

----

.. _class_Card_property__is_dead:

- bool **_is_dead**

Boolean: ``true`` if the card is dead else ``false``.

----

.. _class_Card_property__is_selected:

- bool **_is_selected**

Boolean: ``true`` if the card is selected else ``false``.


.. _class_Card_methods_description:

Methods Descriptions
--------------------

.. _class_Card_method_get_name:

- String **get_name (** **)**

**Description:** Method to get the name of the card.

----

.. _class_Card_method_kill:

- void **kill (** **)**

**Description:** Method to kill the card (set _is_dead to ``true``).

----

.. _class_Card_method__set_default_counter:

- void **_set_default_counter (** **)**

**Description:** Method called in the constructor to set the default counters.


.. _class_Card_static_methods_description:

Static Methods Descriptions
---------------------------

.. _class_Card_static_method_get_card_name:

- static String **get_card_name (** **int** type **)**

**Description:** Static Method to get the name of a card by its card_type.


**Method parameters:**


- int **type**: Type of the card.


.. _class_Card_enums_description:

Enumerations Descriptions
-------------------------

.. _class_Card_enum_CARD_TYPE:

enum **CARD_TYPE**:

**Description:** Enumeration to store card types in a human readable way.

- **HIDDEN**: Card type for opponents cards that are not dead.
- **DUKE**: Duke character.
- **ASSASSIN**: Assassin character.
- **CONTESSA**: Contessa character.
- **CAPTAIN**: Captain character.
- **AMBASSADOR**: Ambassador character.
- **INQUISITOR**: Inquisitor character.
- **INVALID**: Card type for invalid cards.
