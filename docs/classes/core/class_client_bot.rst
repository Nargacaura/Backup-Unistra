.. _class_Bot:

Bot
===

**Inherits:** :ref:`Player_Base<class_Player_Base>`


.. _class_Bot_properties:

Properties
----------

+------------+------------------------------------------------------------------+
| Dictionary | :ref:`_game_data<class_Bot_property__game_data>`                 |
+------------+------------------------------------------------------------------+
| int        | :ref:`_bot_difficulty<class_Bot_property__bot_difficulty>`       |
+------------+------------------------------------------------------------------+
| Array      | :ref:`_min_select_time<class_Bot_property__min_select_time>`     |
+------------+------------------------------------------------------------------+
| Array      | :ref:`_max_select_time<class_Bot_property__max_select_time>`     |
+------------+------------------------------------------------------------------+
| Array      | :ref:`_min_action_time<class_Bot_property__min_action_time>`     |
+------------+------------------------------------------------------------------+
| Array      | :ref:`_max_action_time<class_Bot_property__max_action_time>`     |
+------------+------------------------------------------------------------------+
| Array      | :ref:`_min_reaction_time<class_Bot_property__min_reaction_time>` |
+------------+------------------------------------------------------------------+
| Array      | :ref:`_max_reaction_time<class_Bot_property__max_reaction_time>` |
+------------+------------------------------------------------------------------+


.. _class_Bot_methods:

Methods
-------

+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`init_game_data<class_Bot_method_init_game_data>` **(** **Array** players **)**                                                |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`add_card<class_Bot_method_add_card>` **(** :ref:`Card<class_Card>` card **)**                                                 |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`play_turn<class_Bot_method_play_turn>` **(** **Dictionary** players_data **)**                                                |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`select_cards<class_Bot_method_select_cards>` **(** **Array** cards, **int** qty, **String** text **)**                        |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`branch_options<class_Bot_method_branch_options>` **(** **Array** options, **String** text **)**                               |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`request_kill_card<class_Bot_method_request_kill_card>` **(** **String** text, **int** qty **)**                               |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_on_start_reaction<class_Bot_method__on_start_reaction>` **(** :ref:`Action<class_Action>` calling_action **)**               |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_on_resume_wait<class_Bot_method__on_resume_wait>` **(** **)**                                                                |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_on_resolved_action<class_Bot_method__on_resolved_action>` **(** :ref:`Action<class_Action>` action **)**                     |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`connect_signals<class_Bot_method_connect_signals>` **(** **Node** view **)**                                                  |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_process_action<class_Bot_method__process_action>` **(** :ref:`Action<class_Action>` action **)**                             |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_update_player_data<class_Bot_method__update_player_data>` **(** **int** sender_id **)**                                      |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_process_resolved_action<class_Bot_method__process_resolved_action>` **(** :ref:`Action<class_Action>` action **)**           |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_on_player_loose_card<class_Bot_method__on_player_loose_card>` **(** **int** player_id, **int** card_type **)**               |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_print_game_data<class_Bot_method__print_game_data>` **(** **)**                                                              |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`play_turn_easy<class_Bot_method_play_turn_easy>` **(** **Dictionary** players_data **)**                                      |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`play_turn_medium<class_Bot_method_play_turn_medium>` **(** **Dictionary** players_data **)**                                  |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`play_turn_hard<class_Bot_method_play_turn_hard>` **(** **Dictionary** players_data **)**                                      |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| Array | :ref:`select_cards_easy<class_Bot_method_select_cards_easy>` **(** **Array** cards, **int** qty **)**                               |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| Array | :ref:`select_cards_medium<class_Bot_method_select_cards_medium>` **(** **Array** cards, **int** qty **)**                           |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| Array | :ref:`select_cards_hard<class_Bot_method_select_cards_hard>` **(** **Array** cards, **int** qty **)**                               |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| int   | :ref:`branch_options_easy<class_Bot_method_branch_options_easy>` **(** **Array** options **)**                                      |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| int   | :ref:`branch_options_medium<class_Bot_method_branch_options_medium>` **(** **Array** options **)**                                  |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| int   | :ref:`branch_options_hard<class_Bot_method_branch_options_hard>` **(** **Array** options **)**                                      |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| Array | :ref:`request_kill_card_easy<class_Bot_method_request_kill_card_easy>` **(** **Array** cards, **int** qty **)**                     |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| Array | :ref:`request_kill_card_medium<class_Bot_method_request_kill_card_medium>` **(** **Array** cards, **int** qty **)**                 |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| Array | :ref:`request_kill_card_hard<class_Bot_method_request_kill_card_hard>` **(** **Array** cards, **int** qty **)**                     |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_on_start_reaction_easy<class_Bot_method__on_start_reaction_easy>` **(** :ref:`Action<class_Action>` calling_action **)**     |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_on_start_reaction_medium<class_Bot_method__on_start_reaction_medium>` **(** :ref:`Action<class_Action>` calling_action **)** |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+
| void  | :ref:`_on_start_reaction_hard<class_Bot_method__on_start_reaction_hard>` **(** :ref:`Action<class_Action>` calling_action **)**     |
+-------+-------------------------------------------------------------------------------------------------------------------------------------+


.. _class_Bot_signals:

Signals
-------

+--------+------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`wait_for_seconds<class_Bot_signal_wait_for_seconds>` **(** :ref:`Player<class_Player>` player, **int** wait_time **)** |
+--------+------------------------------------------------------------------------------------------------------------------------------+
| signal | :ref:`resume_wait<class_Bot_signal_resume_wait>` **(** **)**                                                                 |
+--------+------------------------------------------------------------------------------------------------------------------------------+


.. _class_Bot_enums:

Enumerations
------------

+------+------------------------------------------------------+
| enum | :ref:`BOT_DIFFICULTY<class_Bot_enum_BOT_DIFFICULTY>` |
+------+------------------------------------------------------+


.. _class_Bot_properties_description:

Properties Descriptions
-----------------------

.. _class_Bot_property__game_data:

- Dictionary **_game_data**

Bots must have a way to store players actions, balance, if they're dead, most likely cards in their hands, ... All this data is stored in _game_data, it's a Dictionary, it has the following structure (it's an example) :

.. code-block:: python

        _game_data = {
                "players": {
                        1: {
                                "is_alive": true,
                                "balance": 3,
                                "is_bot": false,
                                "hand": [
                                        {"card_type": Card.CARD_TYPE.DUKE, "is_dead": false },
                                        {"card_type": Card.CARD_TYPE.CONTESSA, "is_dead": true}
                                ],
                                "announcement": {
                                        Card.CARD_TYPE.HIDDEN: 0,
                                        Card.CARD_TYPE.DUKE: 0,
                                        Card.CARD_TYPE.ASSASSIN: 0,
                                        Card.CARD_TYPE.CONTESSA: 0,
                                        Card.CARD_TYPE.CAPTAIN: 0,
                                        Card.CARD_TYPE.AMBASSADOR: 0,
                                }
                        }
                },
                "current_main_action": null, # Main action of this turn, ex: FOREIGN_AID
                "calling_action": null, # Last action of this turn, ex: COUNTER
        }

----

.. _class_Bot_property__bot_difficulty:

- int **_bot_difficulty**

The difficulty of the bot.

----

.. _class_Bot_property__min_select_time:

- Array **_min_select_time**

Minimum time to select a card to kill, select a target, ...

----

.. _class_Bot_property__max_select_time:

- Array **_max_select_time**

Maximum time to select a card to kill, select a target, ...

----

.. _class_Bot_property__min_action_time:

- Array **_min_action_time**

Minimum time to select the bot action.

----

.. _class_Bot_property__max_action_time:

- Array **_max_action_time**

Maximum time to select the bot action.

----

.. _class_Bot_property__min_reaction_time:

- Array **_min_reaction_time**

Minimum Time to react to an action, COUNTER, DOUBT, PASS

----

.. _class_Bot_property__max_reaction_time:

- Array **_max_reaction_time**

Maximum Time to react to an action, COUNTER, DOUBT, PASS


.. _class_Bot_methods_description:

Methods Descriptions
--------------------

.. _class_Bot_method_init_game_data:

- void **init_game_data (** **Array** players **)**

**Description:** This method is used to initialize the bot's _game_data dictionary.


**Method parameters:**


- Array **players**: List of all players in the game.

----

.. _class_Bot_method_add_card:

- void **add_card (** :ref:`Card<class_Card>` card **)**

**Description:** Override: This method is used to add a card to the player's hand.


**Method parameters:**


- :ref:`Card<class_Card>` **card**: Card to add to the player's hand.

----

.. _class_Bot_method_play_turn:

- void **play_turn (** **Dictionary** players_data **)**

**Description:** Called from `Board`: Method that requests an action from a player when it's their turn to play.


**Method parameters:**


- Dictionary **players_data**: Dictionary containing the minimum info needed to play.

----

.. _class_Bot_method_select_cards:

- void **select_cards (** **Array** cards, **int** qty, **String** text **)**

**Description:** Called from `Board`: Method that requests a choice of cards from the player.


**Method parameters:**


- Array **cards**: Array of cards to choose from.
- int **qty**: Quantity of cards to choose.
- String **text**: Text to display to the player.

----

.. _class_Bot_method_branch_options:

- void **branch_options (** **Array** options, **String** text **)**

**Description:** Called from `Board`: Method that requests a player to pick an option in a list.


**Method parameters:**


- Array **options**: Array of options to choose from.
- String **text**: Text to display to the player.

----

.. _class_Bot_method_request_kill_card:

- void **request_kill_card (** **String** text, **int** qty **)**

**Description:** Called from `Board`: Method that requests a victim from the player.


**Method parameters:**


- String **text**: Text to display to the player.
- int **qty**: Quantity of cards to kill.

----

.. _class_Bot_method__on_start_reaction:

- void **_on_start_reaction (** :ref:`Action<class_Action>` calling_action **)**

**Description:** Called from `Board`: Method that ask the view to make a reaction.


**Method parameters:**


- :ref:`Action<class_Action>` **calling_action**: Action made by the current player. Action to react to.

----

.. _class_Bot_method__on_resume_wait:

- void **_on_resume_wait (** **)**

**Description:** Method that calls the signal ``resume_wait`` after the wait time is over.

----

.. _class_Bot_method__on_resolved_action:

- void **_on_resolved_action (** :ref:`Action<class_Action>` action **)**

**Description:** Method called by the `Board` to update the _game_data.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: The action that has just been resolved.

----

.. _class_Bot_method_connect_signals:

- void **connect_signals (** **Node** view **)**

**Description:** Method to link all needed signals between the bot and its view.


**Method parameters:**


- Node **view**: Node that represents the player.

----

.. _class_Bot_method__process_action:

- void **_process_action (** :ref:`Action<class_Action>` action **)**

**Description:** Method to keep the _game_date updated.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: Action to process.

----

.. _class_Bot_method__update_player_data:

- void **_update_player_data (** **int** sender_id **)**

**Description:** Method to update the player's hand representation with the ID **sender_id** in the _game_data. The player's hand is an estimation.


**Method parameters:**


- int **sender_id**: Player ID of the player to update.

----

.. _class_Bot_method__process_resolved_action:

- void **_process_resolved_action (** :ref:`Action<class_Action>` action **)**

**Description:** Method to process a resolved action.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: Resolved action to process.

----

.. _class_Bot_method__on_player_loose_card:

- void **_on_player_loose_card (** **int** player_id, **int** card_type **)**

**Description:** Method to update _game_data.


**Method parameters:**


- int **player_id**: The ID of the player that just lost a card.
- int **card_type**: The card type of the cart that has been killed.

----

.. _class_Bot_method__print_game_data:

- void **_print_game_data (** **)**

**Description:** Debug method to print the _game_data of the bot.

----

.. _class_Bot_method_play_turn_easy:

- void **play_turn_easy (** **Dictionary** players_data **)**

**Description:** Method to make an action for a bot with an ``easy`` level of difficulty.


**Method parameters:**


- Dictionary **players_data**: Dictionary containing minimum amount of data about all other players.

----

.. _class_Bot_method_play_turn_medium:

- void **play_turn_medium (** **Dictionary** players_data **)**

**Description:** Method to make an action for a bot with a ``medium`` level of difficulty.


**Method parameters:**


- Dictionary **players_data**: Dictionary containing minimum amount of data about all other players.

----

.. _class_Bot_method_play_turn_hard:

- void **play_turn_hard (** **Dictionary** players_data **)**

**Description:** Method to make an action for a bot with a ``hard`` level of difficulty.


**Method parameters:**


- Dictionary **players_data**: Dictionary containing minimum amount of data about all other players.

----

.. _class_Bot_method_select_cards_easy:

- Array **select_cards_easy (** **Array** cards, **int** qty **)**

**Description:** Method to select a card for a bot with an ``easy`` level of difficulty.


**Method parameters:**


- Array **cards**: Array of cards to choose from.
- int **qty**: Quantity of cards to choose.

----

.. _class_Bot_method_select_cards_medium:

- Array **select_cards_medium (** **Array** cards, **int** qty **)**

**Description:** Method to select a card for a bot with a ``medium`` level of difficulty.


**Method parameters:**


- Array **cards**: Array of cards to choose from.
- int **qty**: Quantity of cards to choose.

----

.. _class_Bot_method_select_cards_hard:

- Array **select_cards_hard (** **Array** cards, **int** qty **)**

**Description:** Method to select a card for a bot with a ``hard`` level of difficulty.


**Method parameters:**


- Array **cards**: Array of cards to choose from.
- int **qty**: Quantity of cards to choose.

----

.. _class_Bot_method_branch_options_easy:

- int **branch_options_easy (** **Array** options **)**

**Description:** Method to select an option for a bot with an ``easy`` level of difficulty.


**Method parameters:**


- Array **options**: Array of cards to choose from.

----

.. _class_Bot_method_branch_options_medium:

- int **branch_options_medium (** **Array** options **)**

**Description:** Method to select an option for a bot with a ``medium`` level of difficulty.


**Method parameters:**


- Array **options**: Array of cards to choose from.

----

.. _class_Bot_method_branch_options_hard:

- int **branch_options_hard (** **Array** options **)**

**Description:** Method to select an option for a bot with a ``hard`` level of difficulty.


**Method parameters:**


- Array **options**: Array of cards to choose from.

----

.. _class_Bot_method_request_kill_card_easy:

- Array **request_kill_card_easy (** **Array** cards, **int** qty **)**

**Description:** Method to select <qty> cards to kill for a bot with an ``easy`` level of difficulty.


**Method parameters:**


- Array **cards**: Array of cards to choose from.
- int **qty**: Quantity of cards to choose.

----

.. _class_Bot_method_request_kill_card_medium:

- Array **request_kill_card_medium (** **Array** cards, **int** qty **)**

**Description:** Method to select <qty> cards to kill for a bot with an ``medium`` level of difficulty.


**Method parameters:**


- Array **cards**: Array of cards to choose from.
- int **qty**: Quantity of cards to choose.

----

.. _class_Bot_method_request_kill_card_hard:

- Array **request_kill_card_hard (** **Array** cards, **int** qty **)**

**Description:** Method to select <qty> cards to kill for a bot with a ``hard`` level of difficulty.


**Method parameters:**


- Array **cards**: Array of cards to choose from.
- int **qty**: Quantity of cards to choose.

----

.. _class_Bot_method__on_start_reaction_easy:

- void **_on_start_reaction_easy (** :ref:`Action<class_Action>` calling_action **)**

**Description:** Method to make a reaction to the **calling_action** for a bot with an ``easy`` level of difficulty.


**Method parameters:**


- :ref:`Action<class_Action>` **calling_action**: The action to react to.

----

.. _class_Bot_method__on_start_reaction_medium:

- void **_on_start_reaction_medium (** :ref:`Action<class_Action>` calling_action **)**

**Description:** Method to make a reaction to the **calling_action** for a bot with a ``medium`` level of difficulty.


**Method parameters:**


- :ref:`Action<class_Action>` **calling_action**: The action to react to.

----

.. _class_Bot_method__on_start_reaction_hard:

- void **_on_start_reaction_hard (** :ref:`Action<class_Action>` calling_action **)**

**Description:** Method to make a reaction to the **calling_action** for a bot with an ``hard`` level of difficulty.


**Method parameters:**


- :ref:`Action<class_Action>` **calling_action**: The action to react to.


.. _class_Bot_signals_description:

Signals Descriptions
--------------------

.. _class_Bot_signal_wait_for_seconds:

- **wait_for_seconds (** :ref:`Player<class_Player>` player, **int** wait_time **)**

**Description:** Signal to wait for <wait_time> seconds.


**Signal parameters:**


- :ref:`Player<class_Player>` **player**: The player object itself.
- int **wait_time**: Amount of time to wait.

----

.. _class_Bot_signal_resume_wait:

- **resume_wait (** **)**

**Description:** Signal send after the wait time is over.


.. _class_Bot_enums_description:

Enumerations Descriptions
-------------------------

.. _class_Bot_enum_BOT_DIFFICULTY:

enum **BOT_DIFFICULTY**:

**Description:** Enumeration to store bot difficulty level in a human readable way.

- **EASY**: Bot difficulty ``easy``.
- **MEDIUM**: Bot difficulty ``medium``.
- **HARD**: Bot difficulty ``hard``.
