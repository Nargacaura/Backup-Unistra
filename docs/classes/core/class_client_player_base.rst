.. _class_Player_Base:

Player_Base
===========

**Inherited By:** :ref:`Player<class_Player>`, :ref:`Bot<class_Bot>`


.. _class_Player_Base_properties:

Properties
----------

+-----------------------------+--------------------------------------------------------+
| int                         | :ref:`_id<class_Player_Base_property__id>`             |
+-----------------------------+--------------------------------------------------------+
| String                      | :ref:`_username<class_Player_Base_property__username>` |
+-----------------------------+--------------------------------------------------------+
| int                         | :ref:`_balance<class_Player_Base_property__balance>`   |
+-----------------------------+--------------------------------------------------------+
| Array                       | :ref:`_hand<class_Player_Base_property__hand>`         |
+-----------------------------+--------------------------------------------------------+
| :ref:`Action<class_Action>` | :ref:`_action<class_Player_Base_property__action>`     |
+-----------------------------+--------------------------------------------------------+
| String                      | :ref:`_color<class_Player_Base_property__color>`       |
+-----------------------------+--------------------------------------------------------+
| bool                        | :ref:`_passed<class_Player_Base_property__passed>`     |
+-----------------------------+--------------------------------------------------------+
| Array                       | :ref:`_roles<class_Player_Base_property__roles>`       |
+-----------------------------+--------------------------------------------------------+


.. _class_Player_Base_methods:

Methods
-------

+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`set_balance<class_Player_Base_method_set_balance>` **(** **int** amount **)**                                                  |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`change_balance<class_Player_Base_method_change_balance>` **(** **int** amount **)**                                            |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`add_card<class_Player_Base_method_add_card>` **(** :ref:`Card<class_Card>` card **)**                                          |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`remove_card<class_Player_Base_method_remove_card>` **(** **int** index **)**                                                   |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`stop_reaction<class_Player_Base_method_stop_reaction>` **(** **)**                                                             |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`play_turn<class_Player_Base_method_play_turn>` **(** **Dictionary** player_data **)**                                          |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`kill_card<class_Player_Base_method_kill_card>` **(** **int** card_index **)**                                                  |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`select_cards<class_Player_Base_method_select_cards>` **(** **Array** cards, **int** qty, **String** text **)**                 |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`branch_options<class_Player_Base_method_branch_options>` **(** **Array** options, **String** text **)**                        |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`request_kill_card<class_Player_Base_method_request_kill_card>` **(** **String** text, **Array** qty **)**                      |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_start_reaction<class_Player_Base_method__on_start_reaction>` **(** :ref:`Action<class_Action>` calling_action **)**        |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_end_reaction<class_Player_Base_method__on_end_reaction>` **(** **)**                                                       |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_end_turn<class_Player_Base_method__on_end_turn>` **(** **)**                                                               |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_resolved_action<class_Player_Base_method__on_resolved_action>` **(** :ref:`Action<class_Action>` resolved_action **)**     |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_player_loose_card<class_Player_Base_method__on_player_loose_card>` **(** :ref:`Action<class_Action>` resolved_action **)** |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_on_hand_updated<class_Player_Base_method__on_hand_updated>` **(** **)**                                                       |
+------+--------------------------------------------------------------------------------------------------------------------------------------+
| void | :ref:`_print<class_Player_Base_method__print>` **(** **)**                                                                           |
+------+--------------------------------------------------------------------------------------------------------------------------------------+


.. _class_Player_Base_signals:

Signals
-------

+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`play_turn<class_Player_Base_signal_play_turn>` **(** :ref:`Player<class_Player>` player, **Array** roles, **Dictionary** players_data **)** |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`player_action<class_Player_Base_signal_player_action>` **(** :ref:`Action<class_Action>` action **)**                                       |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`player_card_choice<class_Player_Base_signal_player_card_choice>` **(** **Array** cards **)**                                                |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`player_option_choice<class_Player_Base_signal_player_option_choice>` **(** **Array** options **)**                                          |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`player_reaction<class_Player_Base_signal_player_reaction>` **(** :ref:`Action<class_Action>` action **)**                                   |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`end_reaction<class_Player_Base_signal_end_reaction>` **(** **)**                                                                            |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`init_player<class_Player_Base_signal_init_player>` **(** :ref:`Player<class_Player>` player **)**                                           |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`add_card<class_Player_Base_signal_add_card>` **(** :ref:`Card<class_Card>` card **)**                                                       |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`remove_card<class_Player_Base_signal_remove_card>` **(** **int** card_id **)**                                                              |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`kill_card<class_Player_Base_signal_kill_card>` **(** **int** card_index, **int** card_type, **bool** is_alive **)**                         |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`change_balance<class_Player_Base_signal_change_balance>` **(** **int** balance **)**                                                        |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`hand_updated<class_Player_Base_signal_hand_updated>` **(** **)**                                                                            |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`end_turn<class_Player_Base_signal_end_turn>` **(** **)**                                                                                    |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`stop_reaction<class_Player_Base_signal_stop_reaction>` **(** **)**                                                                          |
+--------+---------------------------------------------------------------------------------------------------------------------------------------------------+


.. _class_Player_Base_properties_description:

Properties Descriptions
-----------------------

.. _class_Player_Base_property__id:

- int **_id**

A unique number to identify the player.

----

.. _class_Player_Base_property__username:

- String **_username**

The username of the player.

----

.. _class_Player_Base_property__balance:

- int **_balance**

The amount of coins of the player.

----

.. _class_Player_Base_property__hand:

- Array **_hand**

The player’s hand composed of two cards.

----

.. _class_Player_Base_property__action:

- :ref:`Action<class_Action>` **_action**

The current action of the player.

----

.. _class_Player_Base_property__color:

- String **_color**

Each player has a color to make it easier to identify the players.

----

.. _class_Player_Base_property__passed:

- bool **_passed**

Boolean to check if the player has passed the current action.

----

.. _class_Player_Base_property__roles:

- Array **_roles**

List of all available roles in the current game.


.. _class_Player_Base_methods_description:

Methods Descriptions
--------------------

.. _class_Player_Base_method_set_balance:

- void **set_balance (** **int** amount **)**

**Description:** Setter of the property _balance.


**Method parameters:**


- int **amount**: 

----

.. _class_Player_Base_method_change_balance:

- void **change_balance (** **int** amount **)**

**Description:** Method to increase or decrease the player’s _balance.


**Method parameters:**


- int **amount**: 

----

.. _class_Player_Base_method_add_card:

- void **add_card (** :ref:`Card<class_Card>` card **)**

**Description:** Method to add a card to the player’s _hand.


**Method parameters:**


- :ref:`Card<class_Card>` **card**: 

----

.. _class_Player_Base_method_remove_card:

- void **remove_card (** **int** index **)**

**Description:** Method to remove the card at position **index** from the player’s hand.


**Method parameters:**


- int **index**: 

----

.. _class_Player_Base_method_stop_reaction:

- void **stop_reaction (** **)**

**Description:** Method to let the player know he cannot react to the current action anymore.

----

.. _class_Player_Base_method_play_turn:

- void **play_turn (** **Dictionary** player_data **)**

**Description:** The main method for the player to make his action. The method is called by the `Board`.


**Method parameters:**


- Dictionary **player_data**: This is the minimum amount of data about the players needed to make an action.

----

.. _class_Player_Base_method_kill_card:

- void **kill_card (** **int** card_index **)**

**Description:** Method called by the `Board` to tell the player he has lost the card of position **card_index**.


**Method parameters:**


- int **card_index**: 

----

.. _class_Player_Base_method_select_cards:

- void **select_cards (** **Array** cards, **int** qty, **String** text **)**

**Description:** Method called by the `Board` to ask the player to select **qty** cards form the **cards** Array. A message is passed with it in the variable **text**.


**Method parameters:**


- Array **cards**: 
- int **qty**: 
- String **text**: 

----

.. _class_Player_Base_method_branch_options:

- void **branch_options (** **Array** options, **String** text **)**

**Description:** Method called by the `Board` to ask the player to select an option form the **options** Array. A message is passed with it in the variable **text**.


**Method parameters:**


- Array **options**: 
- String **text**: 

----

.. _class_Player_Base_method_request_kill_card:

- void **request_kill_card (** **String** text, **Array** qty **)**

**Description:** Method called by the `Board` to ask the player to kill **qty** cards form the player's hand.


**Method parameters:**


- String **text**: 
- Array **qty**: 

----

.. _class_Player_Base_method__on_start_reaction:

- void **_on_start_reaction (** :ref:`Action<class_Action>` calling_action **)**

**Description:** Method called by the `Board` to ask the player to make a reaction to the current action.


**Method parameters:**


- :ref:`Action<class_Action>` **calling_action**: 

----

.. _class_Player_Base_method__on_end_reaction:

- void **_on_end_reaction (** **)**

**Description:** Method called by the `Board` to tell the player’s view to stop displaying the reaction screen.

----

.. _class_Player_Base_method__on_end_turn:

- void **_on_end_turn (** **)**

**Description:** Method called by the `Board` to tell the player’s view that the turn has ended.

----

.. _class_Player_Base_method__on_resolved_action:

- void **_on_resolved_action (** :ref:`Action<class_Action>` resolved_action **)**

**Description:** Method called by the `Board` used by the Bots to update the _game_data.


**Method parameters:**


- :ref:`Action<class_Action>` **resolved_action**: 

----

.. _class_Player_Base_method__on_player_loose_card:

- void **_on_player_loose_card (** :ref:`Action<class_Action>` resolved_action **)**

**Description:** Method called by the `Board` used by the Bots to update the _game_data.


**Method parameters:**


- :ref:`Action<class_Action>` **resolved_action**: 

----

.. _class_Player_Base_method__on_hand_updated:

- void **_on_hand_updated (** **)**

**Description:** Method called by the player’s view to let the `Board` know that the player’s hand was updated.

----

.. _class_Player_Base_method__print:

- void **_print (** **)**

**Description:** Debug method to print the player’s info in the console.


.. _class_Player_Base_signals_description:

Signals Descriptions
--------------------

.. _class_Player_Base_signal_play_turn:

- **play_turn (** :ref:`Player<class_Player>` player, **Array** roles, **Dictionary** players_data **)**

**Description:** **Game Loop** signal: Signal that ask the view to make an action.


**Signal parameters:**


- :ref:`Player<class_Player>` **player**: The player object itself.
- Array **roles**: Array containing the list of valid cards for this game.
- Dictionary **players_data**: The minimum amount of info, about all players, needed to make an action.

----

.. _class_Player_Base_signal_player_action:

- **player_action (** :ref:`Action<class_Action>` action **)**

**Description:** **Game Loop** signal: Signal to send player’s action to the `Board`. It is called after the view choose the action.


**Signal parameters:**


- :ref:`Action<class_Action>` **action**: The action made by the player.

----

.. _class_Player_Base_signal_player_card_choice:

- **player_card_choice (** **Array** cards **)**

**Description:** **Game Loop** signal: Signal to ask the view to choose a card from the card **Array**.


**Signal parameters:**


- Array **cards**: The list of cards indexes to choose from.

----

.. _class_Player_Base_signal_player_option_choice:

- **player_option_choice (** **Array** options **)**

**Description:** **Game Loop** signal: Signal to ask the view to choose an option from the options **Array**.


**Signal parameters:**


- Array **options**: The list of options to choose from.

----

.. _class_Player_Base_signal_player_reaction:

- **player_reaction (** :ref:`Action<class_Action>` action **)**

**Description:** **Reaction** signal: Signal emitted from _on_start_reaction, to let the player react to the **action**.


**Signal parameters:**


- :ref:`Action<class_Action>` **action**: The action to react to.

----

.. _class_Player_Base_signal_end_reaction:

- **end_reaction (** **)**

**Description:** **Reaction** signal: Signal called when the player cannot react anymore to the current action.

----

.. _class_Player_Base_signal_init_player:

- **init_player (** :ref:`Player<class_Player>` player **)**

**Description:** **View** signal: Signal to init the player’s view with the player’s data.


**Signal parameters:**


- :ref:`Player<class_Player>` **player**: The player object itself.

----

.. _class_Player_Base_signal_add_card:

- **add_card (** :ref:`Card<class_Card>` card **)**

**Description:** **View** signal: Signal to notify the view to add a card in player’s hand.


**Signal parameters:**


- :ref:`Card<class_Card>` **card**: The card to add to the player's hand visual.

----

.. _class_Player_Base_signal_remove_card:

- **remove_card (** **int** card_id **)**

**Description:** **View** signal: Signal to notify the view to remove the card of index **card_id** in player’s hand.


**Signal parameters:**


- int **card_id**: The index of the card to remove from the player's hand visual.

----

.. _class_Player_Base_signal_kill_card:

- **kill_card (** **int** card_index, **int** card_type, **bool** is_alive **)**

**Description:** **View** signal: Signal to notify the view to kill the card of index **card_index** in player’s hand.


**Signal parameters:**


- int **card_index**: The index of the card to kill from the player's hand visual.
- int **card_type**: The type of the card to kill.
- bool **is_alive**: ``true`` if the player is alive else ``false``.

----

.. _class_Player_Base_signal_change_balance:

- **change_balance (** **int** balance **)**

**Description:** **View** signal: Signal to notify the view to change player’s balance.


**Signal parameters:**


- int **balance**: The player's balance.

----

.. _class_Player_Base_signal_hand_updated:

- **hand_updated (** **)**

**Description:** **View** signal: Signal to notify the `Board` that the player’s hand was updated.

----

.. _class_Player_Base_signal_end_turn:

- **end_turn (** **)**

**Description:** **View** signal: Signal to notify the view that the turn has ended.

----

.. _class_Player_Base_signal_stop_reaction:

- **stop_reaction (** **)**

**Description:** **View** signal: Signal to notify the view that the player cannot react anymore.
