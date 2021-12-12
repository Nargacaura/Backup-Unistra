.. _class_Board:

Board
=====


.. _class_Board_constants:

Constants
---------

+-------+----------------------------------------------------------+
| Array | :ref:`DEFAULT_ROLES<class_Board_constant_DEFAULT_ROLES>` |
+-------+----------------------------------------------------------+


.. _class_Board_properties:

Properties
----------

+-------+------------------------------------------------------------------+
| int   | :ref:`_player_count<class_Board_property__player_count>`         |
+-------+------------------------------------------------------------------+
| Array | :ref:`_players<class_Board_property__players>`                   |
+-------+------------------------------------------------------------------+
| Array | :ref:`_deck<class_Board_property__deck>`                         |
+-------+------------------------------------------------------------------+
| Array | :ref:`_roles<class_Board_property__roles>`                       |
+-------+------------------------------------------------------------------+
| Array | :ref:`_actions<class_Board_property__actions>`                   |
+-------+------------------------------------------------------------------+
| int   | :ref:`_active_player_id<class_Board_property__active_player_id>` |
+-------+------------------------------------------------------------------+
| int   | :ref:`_turn_count<class_Board_property__turn_count>`             |
+-------+------------------------------------------------------------------+
| Timer | :ref:`_bluff_timer<class_Board_property__bluff_timer>`           |
+-------+------------------------------------------------------------------+
| Timer | :ref:`_action_timer<class_Board_property__action_timer>`         |
+-------+------------------------------------------------------------------+
| int   | :ref:`_pass_count<class_Board_property__pass_count>`             |
+-------+------------------------------------------------------------------+


.. _class_Board_methods:

Methods
-------

+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| int                                   | :ref:`add_player<class_Board_method_add_player>` **(** :ref:`Player_Base<class_Player_Base>` player **)**                                                            |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`run<class_Board_method_run>` **(** **)**                                                                                                                       |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| bool                                  | :ref:`is_game_over<class_Board_method_is_game_over>` **(** **)**                                                                                                     |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_validate_roles<class_Board_method__validate_roles>` **(** **)**                                                                                               |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_init_game<class_Board_method__init_game>` **(** **)**                                                                                                         |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_create_deck<class_Board_method__create_deck>` **(** **)**                                                                                                     |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_shuffle_deck<class_Board_method__shuffle_deck>` **(** **)**                                                                                                   |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_deal_cards<class_Board_method__deal_cards>` **(** **)**                                                                                                       |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_deal_cards_basic<class_Board_method__deal_cards_basic>` **(** **)**                                                                                           |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_deal_cards_two_players<class_Board_method__deal_cards_two_players>` **(** **)**                                                                               |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_deal_coins<class_Board_method__deal_coins>` **(** **)**                                                                                                       |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| int                                   | :ref:`_count_alive_players<class_Board_method__count_alive_players>` **(** **)**                                                                                     |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_reset_pass_counter<class_Board_method__reset_pass_counter>` **(** **)**                                                                                       |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Dictionary                            | :ref:`get_all_players_data<class_Board_method_get_all_players_data>` **(** **)**                                                                                     |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_end_turn<class_Board_method__end_turn>` **(** **)**                                                                                                           |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_on_player_action<class_Board_method__on_player_action>` **(** :ref:`Action<class_Action>` action **)**                                                        |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_on_player_card_choice<class_Board_method__on_player_card_choice>` **(** **Array** index **)**                                                                 |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_on_player_option_choice<class_Board_method__on_player_option_choice>` **(** **Array** index **)**                                                             |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_on_player_reaction<class_Board_method__on_player_reaction>` **(** :ref:`Action<class_Action>` action **)**                                                    |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_start_timer<class_Board_method__start_timer>` **(** **Timer** timer, **int** wait_time, **String** callback **)**                                             |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_stop_timer<class_Board_method__stop_timer>` **(** **Timer** timer, **String** callback **)**                                                                  |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_on_action_timeout<class_Board_method__on_action_timeout>` **(** **)**                                                                                         |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_on_bluff_timeout<class_Board_method__on_bluff_timeout>` **(** **)**                                                                                           |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_on_choice_timeout<class_Board_method__on_choice_timeout>` **(** **)**                                                                                         |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_on_option_timeout<class_Board_method__on_option_timeout>` **(** **)**                                                                                         |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_add_action<class_Board_method__add_action>` **(** :ref:`Action<class_Action>` action **)**                                                                    |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_emit_action<class_Board_method__emit_action>` **(** :ref:`Action<class_Action>` action **)**                                                                  |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| bool                                  | :ref:`_is_action_valid<class_Board_method__is_action_valid>` **(** :ref:`Action<class_Action>` action **)**                                                          |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :ref:`Action<class_Action>`           | :ref:`get_main_action<class_Board_method_get_main_action>` **(** **)**                                                                                               |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| bool                                  | :ref:`_check_target_validity<class_Board_method__check_target_validity>` **(** **int** action_type, **Array** targets_id **)**                                       |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| bool                                  | :ref:`_set_and_check_action_attributes<class_Board_method__set_and_check_action_attributes>` **(** :ref:`Action<class_Action>` action **)**                          |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_resolve_actions<class_Board_method__resolve_actions>` **(** **)**                                                                                             |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_resolve_action<class_Board_method__resolve_action>` **(** **)**                                                                                               |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`kill_procedure<class_Board_method_kill_procedure>` **(** :ref:`Player_Base<class_Player_Base>` player, **String** ask_message, **String** action_message **)** |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`kill_player_card<class_Board_method_kill_player_card>` **(** :ref:`Player_Base<class_Player_Base>` player, **Array** victim, **String** message **)**          |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :ref:`Player_Base<class_Player_Base>` | :ref:`get_player_by_id<class_Board_method_get_player_by_id>` **(** **int** id **)**                                                                                  |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| String                                | :ref:`get_action_message<class_Board_method_get_action_message>` **(** :ref:`Action<class_Action>` action **)**                                                      |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_print_deck<class_Board_method__print_deck>` **(** **)**                                                                                                       |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| void                                  | :ref:`_print_players<class_Board_method__print_players>` **(** **)**                                                                                                 |
+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+


.. _class_Board_signals:

Signals
-------

+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`player_action_valid<class_Board_signal_player_action_valid>` **(** **)**                                  |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`player_card_choice_valid<class_Board_signal_player_card_choice_valid>` **(** **Array** cards **)**        |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`player_option_choice_valid<class_Board_signal_player_option_choice_valid>` **(** **Array** options **)**  |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`resume<class_Board_signal_resume>` **(** **)**                                                            |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`begin_turn<class_Board_signal_begin_turn>` **(** **)**                                                    |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`end_turn<class_Board_signal_end_turn>` **(** **)**                                                        |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`update_history<class_Board_signal_update_history>` **(** **String** message **)**                         |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`distribution_complete<class_Board_signal_distribution_complete>` **(** **)**                              |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`game_over<class_Board_signal_game_over>` **(** **)**                                                      |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`start_reaction<class_Board_signal_start_reaction>` **(** :ref:`Action<class_Action>` action **)**         |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`end_reaction<class_Board_signal_end_reaction>` **(** **)**                                                |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`end_procedure<class_Board_signal_end_procedure>` **(** **)**                                              |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`end_action<class_Board_signal_end_action>` **(** **)**                                                    |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`end_action_stack<class_Board_signal_end_action_stack>` **(** **)**                                        |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`resolved_action<class_Board_signal_resolved_action>` **(** :ref:`Action<class_Action>` action **)**       |
+--------+-----------------------------------------------------------------------------------------------------------------+
| signal | :ref:`player_loose_card<class_Board_signal_player_loose_card>` **(** **int** player_id, **int** card_type **)** |
+--------+-----------------------------------------------------------------------------------------------------------------+


.. _class_Board_constants_description:

Constants Descriptions
----------------------

.. _class_Board_constant_DEFAULT_ROLES:

- const Array **DEFAULT_ROLES**

The default cards for a game of Complots.

.. code-block:: python

        const DEFAULT_ROLES: Array = [
                Card.CARD_TYPE.DUKE,
                Card.CARD_TYPE.ASSASSIN,
                Card.CARD_TYPE.CONTESSA,
                Card.CARD_TYPE.CAPTAIN,
                Card.CARD_TYPE.AMBASSADOR,
        ]


.. _class_Board_properties_description:

Properties Descriptions
-----------------------

.. _class_Board_property__player_count:

- int **_player_count**

The number of players in the game.

----

.. _class_Board_property__players:

- Array **_players**

Array of all players.

----

.. _class_Board_property__deck:

- Array **_deck**

The deck of the game.

----

.. _class_Board_property__roles:

- Array **_roles**

Array containing all allowed cards for the game.

----

.. _class_Board_property__actions:

- Array **_actions**

Stack of action, it is resolved each turn.

----

.. _class_Board_property__active_player_id:

- int **_active_player_id**

The ID of the current playing player.

----

.. _class_Board_property__turn_count:

- int **_turn_count**

The number of turns of the game.

----

.. _class_Board_property__bluff_timer:

- Timer **_bluff_timer**

Timer Node to stop reaction phase after a given amount of time.

----

.. _class_Board_property__action_timer:

- Timer **_action_timer**

Timer Node to stop play_turn phase after a given amount of time.

----

.. _class_Board_property__pass_count:

- int **_pass_count**

Count how many players pass the reaction phase.


.. _class_Board_methods_description:

Methods Descriptions
--------------------

.. _class_Board_method_add_player:

- int **add_player (** :ref:`Player_Base<class_Player_Base>` player **)**

**Description:** Method called after the constructor to add a player to the game.


**Method parameters:**


- :ref:`Player_Base<class_Player_Base>` **player**: The player to add to the game.

----

.. _class_Board_method_run:

- void **run (** **)**

**Description:** Method to start and run the game.

----

.. _class_Board_method_is_game_over:

- bool **is_game_over (** **)**

**Description:** Getter to know if the game is over (all players are dead except one).

----

.. _class_Board_method__validate_roles:

- void **_validate_roles (** **)**

**Description:** Method called by the constructor to make sure the role array is valid.

----

.. _class_Board_method__init_game:

- void **_init_game (** **)**

**Description:** Game initialisation method called at the beginning of the ``run`` method.

----

.. _class_Board_method__create_deck:

- void **_create_deck (** **)**

**Description:** Method to create the deck depending on the ``_player_count`` property.

----

.. _class_Board_method__shuffle_deck:

- void **_shuffle_deck (** **)**

**Description:** Method to shuffle the deck.

----

.. _class_Board_method__deal_cards:

- void **_deal_cards (** **)**

**Description:** Helper method to deal cards based on player count.

----

.. _class_Board_method__deal_cards_basic:

- void **_deal_cards_basic (** **)**

**Description:** Method to deal 2 cards to each players.

----

.. _class_Board_method__deal_cards_two_players:

- void **_deal_cards_two_players (** **)**

**Description:** Method to deal 1 card to both players and let them choose the second card.

----

.. _class_Board_method__deal_coins:

- void **_deal_coins (** **)**

**Description:** Method to deals coins to all players. There is a difference between 2 players and more.

----

.. _class_Board_method__count_alive_players:

- int **_count_alive_players (** **)**

**Description:** Method to count alive players.

----

.. _class_Board_method__reset_pass_counter:

- void **_reset_pass_counter (** **)**

**Description:** Method to reset pass counter.

----

.. _class_Board_method_get_all_players_data:

- Dictionary **get_all_players_data (** **)**

**Description:** Method to get a dictionary with the minimum info about a player. Returns the following dictionary example:

.. code-block:: python

        players_data {
            "alive": {
                1: {"username": "Player_1", "balance": 3},
                2: {"username": "Player_2", "balance": 5},
            },
            "dead": {
                3: {"username": "Player_3", "balance": 4},
            },
        }

----

.. _class_Board_method__end_turn:

- void **_end_turn (** **)**

**Description:** Method to end the turn, change active player and send a signal to the players.

----

.. _class_Board_method__on_player_action:

- void **_on_player_action (** :ref:`Action<class_Action>` action **)**

**Description:** Method called by the active player through the ``player_action`` signal.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: The player's action.

----

.. _class_Board_method__on_player_card_choice:

- void **_on_player_card_choice (** **Array** index **)**

**Description:** Method called by a player through the ``player_card_choice`` signal when the player has made his choice.


**Method parameters:**


- Array **index**: The chosen card's index.

----

.. _class_Board_method__on_player_option_choice:

- void **_on_player_option_choice (** **Array** index **)**

**Description:** Method called by a player through the ``player_option_choice`` signal when the player has made his choice.


**Method parameters:**


- Array **index**: The chosen option's index.

----

.. _class_Board_method__on_player_reaction:

- void **_on_player_reaction (** :ref:`Action<class_Action>` action **)**

**Description:** This method can be called by any player during reaction phase through the ``player_reaction`` signal.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: The reaction made by the reacting player.

----

.. _class_Board_method__start_timer:

- void **_start_timer (** **Timer** timer, **int** wait_time, **String** callback **)**

**Description:** Helper method to start a timer with wait_time seconds and connect ``timeout`` signal.


**Method parameters:**


- Timer **timer**: The timer node to use to countdown.
- int **wait_time**: The time to wait.
- String **callback**: The method to call on ``timeout``.

----

.. _class_Board_method__stop_timer:

- void **_stop_timer (** **Timer** timer, **String** callback **)**

**Description:** Helper method to stop a timer and disconnect ``timeout`` signal.


**Method parameters:**


- Timer **timer**: The timer node to stop the countdown.
- String **callback**: The method to disconnect.

----

.. _class_Board_method__on_action_timeout:

- void **_on_action_timeout (** **)**

**Description:** Callback method called when active player didn't answer to the call to ``play_turn()``.

----

.. _class_Board_method__on_bluff_timeout:

- void **_on_bluff_timeout (** **)**

**Description:** Callback method called when players didn't react to active player action.

----

.. _class_Board_method__on_choice_timeout:

- void **_on_choice_timeout (** **)**

**Description:** Callback method called when the player didn't made a choice.

----

.. _class_Board_method__on_option_timeout:

- void **_on_option_timeout (** **)**

**Description:** Callback method called when the player didn't choose an option.

----

.. _class_Board_method__add_action:

- void **_add_action (** :ref:`Action<class_Action>` action **)**

**Description:** Method to add an action to the action stack.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: Action to add to the action stack.

----

.. _class_Board_method__emit_action:

- void **_emit_action (** :ref:`Action<class_Action>` action **)**

**Description:** Method to emit the added action to all players.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: Action to emit to all players.

----

.. _class_Board_method__is_action_valid:

- bool **_is_action_valid (** :ref:`Action<class_Action>` action **)**

**Description:** Method to check if the action is valid.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: Action to check.

----

.. _class_Board_method_get_main_action:

- :ref:`Action<class_Action>` **get_main_action (** **)**

**Description:** Method to get the current main action.

----

.. _class_Board_method__check_target_validity:

- bool **_check_target_validity (** **int** action_type, **Array** targets_id **)**

**Description:** Method to check whether the action corresponds to the targets it requires for its execution.


**Method parameters:**


- int **action_type**: The action type of the action to check.
- Array **targets_id**: Array of targets ID to check.

----

.. _class_Board_method__set_and_check_action_attributes:

- bool **_set_and_check_action_attributes (** :ref:`Action<class_Action>` action **)**

**Description:** Method to check check and correct action's attributes.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: The action to check.

----

.. _class_Board_method__resolve_actions:

- void **_resolve_actions (** **)**

**Description:** Helper method to resolve all action stack.

----

.. _class_Board_method__resolve_action:

- void **_resolve_action (** **)**

**Description:** Method to resolve the action on the top of the stack.

----

.. _class_Board_method_kill_procedure:

- void **kill_procedure (** :ref:`Player_Base<class_Player_Base>` player, **String** ask_message, **String** action_message **)**

**Description:** Helper method to start a killing procedure.


**Method parameters:**


- :ref:`Player_Base<class_Player_Base>` **player**: The player object that we want to kill a card from.
- String **ask_message**: Message to display to the player.
- String **action_message**: Message to announce to all players that the player has lost a specific card.

----

.. _class_Board_method_kill_player_card:

- void **kill_player_card (** :ref:`Player_Base<class_Player_Base>` player, **Array** victim, **String** message **)**

**Description:** Helper method to kill a player card.


**Method parameters:**


- :ref:`Player_Base<class_Player_Base>` **player**: The player object that we want to kill a card from.
- Array **victim**: Array containing the card index to kill.
- String **message**: Message to display to all players.

----

.. _class_Board_method_get_player_by_id:

- :ref:`Player_Base<class_Player_Base>` **get_player_by_id (** **int** id **)**

**Description:** Helper method to get the player object with the id passed as a parameter.


**Method parameters:**


- int **id**: Player's ID.

----

.. _class_Board_method_get_action_message:

- String **get_action_message (** :ref:`Action<class_Action>` action **)**

**Description:** Method to get the formated action message.


**Method parameters:**


- :ref:`Action<class_Action>` **action**: Action to get the message from.

----

.. _class_Board_method__print_deck:

- void **_print_deck (** **)**

**Description:** Debug method to print the deck.

----

.. _class_Board_method__print_players:

- void **_print_players (** **)**

**Description:** Debug method to print all players data.


.. _class_Board_signals_description:

Signals Descriptions
--------------------

.. _class_Board_signal_player_action_valid:

- **player_action_valid (** **)**

**Description:** Signal emitted when the active player made a valid action or the timer runout.

----

.. _class_Board_signal_player_card_choice_valid:

- **player_card_choice_valid (** **Array** cards **)**

**Description:** Signal emitted when a player choose a valid card. Example of use: dealing cards to 2 players or in the Ambassador's action.


**Signal parameters:**


- Array **cards**: Array containing the selected card(s).

----

.. _class_Board_signal_player_option_choice_valid:

- **player_option_choice_valid (** **Array** options **)**

**Description:** Signal emitted when a player choose a valid option. Example of use: in the Captain's action.


**Signal parameters:**


- Array **options**: Array containing the selected option(s).

----

.. _class_Board_signal_resume:

- **resume (** **)**

**Description:** Signal to resume the game loop, called on timeout, etc.

----

.. _class_Board_signal_begin_turn:

- **begin_turn (** **)**

**Description:** Signal emitted when it is the beginning of a turn.

----

.. _class_Board_signal_end_turn:

- **end_turn (** **)**

**Description:** Signal emitted when it is the end of a turn.

----

.. _class_Board_signal_update_history:

- **update_history (** **String** message **)**

**Description:** Signal to update server's log in players chat.


**Signal parameters:**


- String **message**: Message to display.

----

.. _class_Board_signal_distribution_complete:

- **distribution_complete (** **)**

**Description:** Signal emitted when the distribution phase is complete.

----

.. _class_Board_signal_game_over:

- **game_over (** **)**

**Description:** Signal emitted when the game is over.

----

.. _class_Board_signal_start_reaction:

- **start_reaction (** :ref:`Action<class_Action>` action **)**

**Description:** This signal is emitted to all players, to let them know they can react to the action passed with it.


**Signal parameters:**


- :ref:`Action<class_Action>` **action**: Action to react to.

----

.. _class_Board_signal_end_reaction:

- **end_reaction (** **)**

**Description:** Signal emitted when players are not allowed to react to the action anymore.

----

.. _class_Board_signal_end_procedure:

- **end_procedure (** **)**

**Description:** Signal called when the kill_card procedure is complete.

----

.. _class_Board_signal_end_action:

- **end_action (** **)**

**Description:** Signal emitted to the board itself when an action is resolved.

----

.. _class_Board_signal_end_action_stack:

- **end_action_stack (** **)**

**Description:** Signal emitted when the action stack is fully resolved.

----

.. _class_Board_signal_resolved_action:

- **resolved_action (** :ref:`Action<class_Action>` action **)**

**Description:** Signal emitted to all players when an action is resolved. So they can update the game state.


**Signal parameters:**


- :ref:`Action<class_Action>` **action**: The resolved action.

----

.. _class_Board_signal_player_loose_card:

- **player_loose_card (** **int** player_id, **int** card_type **)**

**Description:** Signal emitted when a player's card has been killed.


**Signal parameters:**


- int **player_id**: The ID of the player that lost a card.
- int **card_type**: The card type of the lost card.
