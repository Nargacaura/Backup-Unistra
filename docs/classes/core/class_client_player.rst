.. _class_Player:

Player
======

**Inherits:** :ref:`Player_Base<class_Player_Base>`


.. _class_Player_methods:

Methods
-------

+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`play_turn<class_Player_method_play_turn>` **(** **Dictionary** players_data **)**                                                              |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`select_cards<class_Player_method_select_cards>` **(** **Array** cards, **int** qty, **String** text **)**                                      |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`branch_options<class_Player_method_branch_options>` **(** **Array** options, **String** text **)**                                             |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`request_kill_card<class_Player_method_request_kill_card>` **(** **String** text, **int** qty **)**                                             |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_start_reaction<class_Player_method__on_start_reaction>` **(** :ref:`Action<class_Action>` calling_action **)**                             |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_end_reaction<class_Player_method__on_end_reaction>` **(** **)**                                                                            |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_end_turn<class_Player_method__on_end_turn>` **(** **)**                                                                                    |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_choose_action<class_Player_method__on_choose_action>` **(** **int** action_type, **int** card_type, **Array** targets_id **)**             |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_choose_cards<class_Player_method__on_choose_cards>` **(** **Array** cards **)**                                                            |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_choose_options<class_Player_method__on_choose_options>` **(** **Array** cards **)**                                                        |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_reaction<class_Player_method__on_reaction>` **(** **int** action_type, :ref:`Action<class_Action>` calling_action, **int** card_type **)** |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`connect_signals<class_Player_method_connect_signals>` **(** **Node** view **)**                                                                |
+------+------------------------------------------------------------------------------------------------------------------------------------------------------+


.. _class_Player_signals:

Signals
-------

+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`resume<class_Player_signal_resume>` **(** **)**                                                           |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`make_reaction<class_Player_signal_make_reaction>` **(** :ref:`Action<class_Action>` action **)**          |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`choose_cards<class_Player_signal_choose_cards>` **(** **Array** cards, **int** qty, **String** text **)** |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`choose_options<class_Player_signal_choose_options>` **(** **Array** options, **String** text **)**        |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`chosen_cards<class_Player_signal_chosen_cards>` **(** **Array** cards **)**                               |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`chosen_options<class_Player_signal_chosen_options>` **(** **Array** options **)**                         |
+--------+-----------------------------------------------------------------------------------------------------------------+


.. _class_Player_methods_description:

Methods Descriptions
--------------------

.. _class_Player_method_play_turn:

- void **play_turn (** **Dictionary** players_data **)**

**Description:** Called from `Board`: Method that requests an action from a player when it's their turn to play.


**Method parameters:**


- Dictionary **players_data**: Dictionary containing the minimum info needed to play.

----

.. _class_Player_method_select_cards:

- void **select_cards (** **Array** cards, **int** qty, **String** text **)**

**Description:** Called from `Board`: Method that requests a choice of cards from the player.


**Method parameters:**


- Array **cards**: Array of cards to choose from.
- int **qty**: Quantity of cards to choose.
- String **text**: Text to display to the player.

----

.. _class_Player_method_branch_options:

- void **branch_options (** **Array** options, **String** text **)**

**Description:** Called from `Board`: Method that requests a player to pick an option in a list.


**Method parameters:**


- Array **options**: Array of options to choose from.
- String **text**: Text to display to the player.

----

.. _class_Player_method_request_kill_card:

- void **request_kill_card (** **String** text, **int** qty **)**

**Description:** Called from `Board`: Method that requests a victim from the player.


**Method parameters:**


- String **text**: Text to display to the player.
- int **qty**: Quantity of cards to kill.

----

.. _class_Player_method__on_start_reaction:

- void **_on_start_reaction (** :ref:`Action<class_Action>` calling_action **)**

**Description:** Called from `Board`: Method that ask the view to make a reaction.


**Method parameters:**


- :ref:`Action<class_Action>` **calling_action**: Action made by the current player. Action to react to.

----

.. _class_Player_method__on_end_reaction:

- void **_on_end_reaction (** **)**

**Description:** Called from `Board`: Method to tell the view to stop reaction.

----

.. _class_Player_method__on_end_turn:

- void **_on_end_turn (** **)**

**Description:** Called from `Board`: Method to tell the view it is the end of the turn.

----

.. _class_Player_method__on_choose_action:

- void **_on_choose_action (** **int** action_type, **int** card_type, **Array** targets_id **)**

**Description:** Called from View:


**Method parameters:**


- int **action_type**: 
- int **card_type**: 
- Array **targets_id**: 

----

.. _class_Player_method__on_choose_cards:

- void **_on_choose_cards (** **Array** cards **)**

**Description:** Called from View:


**Method parameters:**


- Array **cards**: 

----

.. _class_Player_method__on_choose_options:

- void **_on_choose_options (** **Array** cards **)**

**Description:** Called from View:


**Method parameters:**


- Array **cards**: 

----

.. _class_Player_method__on_reaction:

- void **_on_reaction (** **int** action_type, :ref:`Action<class_Action>` calling_action, **int** card_type **)**

**Description:** Called from View:


**Method parameters:**


- int **action_type**: 
- :ref:`Action<class_Action>` **calling_action**: 
- int **card_type**: 

----

.. _class_Player_method_connect_signals:

- void **connect_signals (** **Node** view **)**

**Description:** Method to link all needed signals between the player and its view.


**Method parameters:**


- Node **view**: Node that represents the player.


.. _class_Player_signals_description:

Signals Descriptions
--------------------

.. _class_Player_signal_resume:

- **resume (** **)**

**Description:** Signal to wait for the view.

----

.. _class_Player_signal_make_reaction:

- **make_reaction (** :ref:`Action<class_Action>` action **)**

**Description:** Signal to ask the view to make the player reaction (ex: Doubt).


**Signal parameters:**


- :ref:`Action<class_Action>` **action**: Action made by the current player. Action to react to.

----

.. _class_Player_signal_choose_cards:

- **choose_cards (** **Array** cards, **int** qty, **String** text **)**

**Description:** Signal to ask the view to choose **qty** card from the **cards** Array.


**Signal parameters:**


- Array **cards**: Array of cards to choose from.
- int **qty**: Quantity of cards to choose.
- String **text**: Text to display to the player.

----

.. _class_Player_signal_choose_options:

- **choose_options (** **Array** options, **String** text **)**

**Description:** Signal to ask the view to choose an option from the **options** Array.


**Signal parameters:**


- Array **options**: Array of options to choose from.
- String **text**: Text to display to the player.

----

.. _class_Player_signal_chosen_cards:

- **chosen_cards (** **Array** cards **)**

**Description:** Signal to notify the `Board`, that the player chose the card(s).


**Signal parameters:**


- Array **cards**: Array containing the cards indexes.

----

.. _class_Player_signal_chosen_options:

- **chosen_options (** **Array** options **)**

**Description:** Signal to notify the `Board`, that the player chose the option.


**Signal parameters:**


- Array **options**: Array containing the chosen option index.
