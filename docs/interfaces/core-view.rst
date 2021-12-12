.. _interface_core_view:

Core - View
===========

In this section we will see the minimum functions that needs to be implemented by the **View** for the game to be playable.


.. _interface_core_view_player_turn:

Player Turn
-----------

The **Game Loop** calls the method :ref:`play_turn<class_Player_Base_method_play_turn>` of the active player.
This method emits the ":ref:`play_turn<class_Player_Base_signal_play_turn>`" signal (from the :ref:`Player<class_Player>` class).


.. _interface_core_view_player_turn_entry:

Player Turn: Entry Signal
*************************

The ``play_turn`` signal needs to be handled by the view, to do so, the view needs to have a function called ``_on_play_turn`` with the following parameters as inputs.

+------------------------------------------------------+-----------------------------------------------------------------------------------+
| **Signal**                                           | **Parameters**                                                                    |
+------------------------------------------------------+-----------------------------------------------------------------------------------+
| :ref:`play_turn<class_Player_Base_signal_play_turn>` | :ref:`player<interface_core_view_player_turn_entry_parameter_player>`             |
+                                                      +-----------------------------------------------------------------------------------+
|                                                      | :ref:`roles<interface_core_view_player_turn_entry_parameter_roles>`               |
+                                                      +-----------------------------------------------------------------------------------+
|                                                      | :ref:`players_data<interface_core_view_player_turn_entry_parameter_players_data>` |
+------------------------------------------------------+-----------------------------------------------------------------------------------+

.. _interface_core_view_player_turn_entry_parameter_player:

- :ref:`Player_Base<class_Player_Base>` player

This is the player object itself.

----

.. _interface_core_view_player_turn_entry_parameter_roles:

- **Array** roles

This array contains the list of valid roles, values have the type **int** (see :ref:`CARD_TYPE<class_Card_enum_card_type>` enum).

----

.. _interface_core_view_player_turn_entry_parameter_players_data:

- **Dictionary** players_data

This dictionary contains the minimum amount of data needed about a player, it has the following structure:

.. code-block:: python
    
    players_data {
        "alive": {
            # <player_id>: {"username": <player_username>, "balance": <player_balance>}
            1: {"username": "Player_1", "balance": 3},
            2: {"username": "Player_2", "balance": 5},
        },
        "dead": {
            3: {"username": "Player_3", "balance": 4},
        },
    }


.. _interface_core_view_player_turn_return:

Player Turn: Return Signal
**************************

To let the player object know wich action was selected, the view needs to emit the signal ``choose_action`` with the following parameters.

+--------------------------------------------------------------+-----------------------------------------------------------------------------------+
| **Signal**                                                   | **Parameters**                                                                    |
+--------------------------------------------------------------+-----------------------------------------------------------------------------------+
| :ref:`choose_action<class_Player_Hand_signal_choose_action>` | :ref:`action_type<interface_core_view_player_turn_return_parameter_action_type>`  |
+                                                              +-----------------------------------------------------------------------------------+
|                                                              | :ref:`card_type<interface_core_view_player_turn_return_parameter_card_type>`      |
+                                                              +-----------------------------------------------------------------------------------+
|                                                              | :ref:`targets<interface_core_view_player_turn_return_parameter_targets>`          |
+--------------------------------------------------------------+-----------------------------------------------------------------------------------+

.. _interface_core_view_player_turn_return_parameter_action_type:

- :ref:`ACTION_TYPE<class_Action_enum_action_type>` action_type

Chosen action type (**int**).

----

.. _interface_core_view_player_turn_return_parameter_card_type:

- :ref:`CARD_TYPE<class_Card_enum_card_type>` card_type

Card type (**int**) corresponding to the action. This is important when countering because on action can be countered by multiple cards.

----

.. _interface_core_view_player_turn_return_parameter_targets:

- **Array** targets

Array of targets IDs (**int**). ID **0** is reserved for the *Court*.


.. _interface_core_view_reaction_phase:

Reaction Phase
--------------

When an action is made by a player, if this action can be doubted or countered, all other players enter the **reaction phase**.

In this phase all other player can **doubt** (if the action can be doubted), **counter** (if the action can be countered) or **pass**.

If a player doesn't make any reaction, the reaction phase will end after a given amount of time (see :ref:`ACTION_TIMEOUT<class_Action_constant_ACTION_TIMEOUT>`).
To avoid waiting this amount of time, if **all players** in the reaction phase ``PASS``, the timer is stopped and the game enters the next phase.


.. _interface_core_view_reaction_phase_entry:

Reaction Phase: Entry Signal
****************************

The ``make_reaction`` signal needs to be handled by the view, to do so, the view needs to have a function called ``_on_make_reaction`` with the following parameters as inputs.

+----------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| **Signal**                                                     | **Parameters**                                                                            |
+----------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| :ref:`make_reaction<class_Player_signal_make_reaction>`        | :ref:`calling_action<interface_core_view_reaction_phase_entry_parameter_calling_action>`  |
+                                                                +-------------------------------------------------------------------------------------------+
|                                                                | :ref:`roles<interface_core_view_reaction_phase_entry_parameter_roles>`                    |
+----------------------------------------------------------------+-------------------------------------------------------------------------------------------+

.. _interface_core_view_reaction_phase_entry_parameter_calling_action:

- :ref:`Action<class_Action>` calling_action

This is the action that the player need to react to.

.. _interface_core_view_reaction_phase_entry_parameter_roles:

- **Array** roles

This array contains the list of valid roles, values have the type **int** (see :ref:`CARD_TYPE<class_Card_enum_card_type>` enum).


.. _interface_core_view_reaction_phase_return:

Reaction Phase: Return Signal
*****************************

To let the player object know wich reaction was made, the view needs to emit the signal ``reaction`` with the following parameters.

+----------------------------------------------------+--------------------------------------------------------------------------------------------+
| **Signal**                                         | **Parameters**                                                                             |
+----------------------------------------------------+--------------------------------------------------------------------------------------------+
| :ref:`reaction<class_Player_Hand_signal_reaction>` | :ref:`action_type<interface_core_view_reaction_phase_return_parameter_action_type>`        |
+                                                    +--------------------------------------------------------------------------------------------+
|                                                    | :ref:`calling_action<interface_core_view_reaction_phase_return_parameter_calling_action>`  |
+                                                    +--------------------------------------------------------------------------------------------+
|                                                    | :ref:`card_type<interface_core_view_reaction_phase_return_parameter_card_type>`            |
+----------------------------------------------------+--------------------------------------------------------------------------------------------+

.. _interface_core_view_reaction_phase_return_parameter_action_type:

- :ref:`ACTION_TYPE<class_Action_enum_action_type>` action_type

This is the action type that the player choose, a reaction can only be of the following types:

.. code-block:: python

    Action.ACTION_TYPE.PASS # Action to say that you don't want to react to the action
    Action.ACTION_TYPE.DOUBT
    Action.ACTION_TYPE.COUNTER

.. _interface_core_view_reaction_phase_return_parameter_calling_action:

- :ref:`Action<class_Action>` calling_action

The action that was passed to the entry signal.

.. _interface_core_view_reaction_phase_return_parameter_card_type:

- :ref:`CARD_TYPE<class_Card_enum_card_type>` card_type

This parameter is important when countering an action. Indeed an action can be countered with more than one card. The :ref:`Board<class_Board>` need to know with what card the action was countered.


.. _interface_core_view_choose_cards:

Choose Cards
------------

Sometimes during a game of Complots, a player must choose a card from a selection of cards (Ambassador's action, killing a cards, etc).
To do so we use the **choose cards** procedure.


.. _interface_core_view_choose_cards_entry:

Choose Cards: Entry Signal
**************************

The ``choose_cards`` signal needs to be handled by the view, to do so, the view needs to have a function called ``_on_choose_cards`` with the following parameters as inputs.

+----------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| **Signal**                                                     | **Parameters**                                                                            |
+----------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| :ref:`choose_cards<class_Player_signal_choose_cards>`          | :ref:`cards<interface_core_view_choose_cards_entry_parameter_cards>`                      |
+                                                                +-------------------------------------------------------------------------------------------+
|                                                                | :ref:`qty<interface_core_view_choose_cards_entry_parameter_qty>`                          |
+                                                                +-------------------------------------------------------------------------------------------+
|                                                                | :ref:`text<interface_core_view_choose_cards_entry_parameter_text>`                        |
+----------------------------------------------------------------+-------------------------------------------------------------------------------------------+

.. _interface_core_view_choose_cards_entry_parameter_cards:

- **Array** cards

The array containing all cards to choose from.

.. _interface_core_view_choose_cards_entry_parameter_qty:

- **int** qty

Number of cards to choose.

.. _interface_core_view_choose_cards_entry_parameter_text:

- **String** text

Text to display to the player.

.. _interface_core_view_choose_cards_return:

Choose Cards: Return Signal
***************************

To let the player object know wich card was chosen, the view needs to emit the signal ``choose_cards`` with the following parameter.

+------------------------------------------------------------+--------------------------------------------------------------------------------------------+
| **Signal**                                                 | **Parameter**                                                                              |
+------------------------------------------------------------+--------------------------------------------------------------------------------------------+
| :ref:`choose_cards<class_Player_Hand_signal_choose_cards>` | :ref:`select<interface_core_view_choose_cards_return_parameter_select>`                    |
+------------------------------------------------------------+--------------------------------------------------------------------------------------------+

.. _interface_core_view_choose_cards_return_parameter_select:

- **Array** select

This is an array containing the cards indexes chosen by the player.


.. _interface_core_view_choose_options:

Choose Options
--------------

Sometimes during a game of Complots, a player must choose an option from a selection of options (Inquisitor's second ability, etc).
To do so we use the **choose options** procedure.


.. _interface_core_view_choose_options_entry:

Choose Options: Entry Signal
****************************

The ``choose_options`` signal needs to be handled by the view, to do so, the view needs to have a function called ``_on_choose_options`` with the following parameters as inputs.

+----------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| **Signal**                                                     | **Parameters**                                                                            |
+----------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| :ref:`choose_options<class_Player_signal_choose_options>`      | :ref:`options<interface_core_view_choose_options_entry_parameter_options>`                |
+                                                                +-------------------------------------------------------------------------------------------+
|                                                                | :ref:`text<interface_core_view_choose_options_entry_parameter_text>`                      |
+----------------------------------------------------------------+-------------------------------------------------------------------------------------------+

.. _interface_core_view_choose_options_entry_parameter_options:

- **Array** options

The array containing all options to choose from.

.. _interface_core_view_choose_options_entry_parameter_text:

- **String** text

Text to display to the player.

.. _interface_core_view_choose_options_return:

Choose Options: Return Signal
*****************************

To let the player object know wich option was chosen, the view needs to emit the signal ``choose_options`` with the following parameter.

+----------------------------------------------------------------+--------------------------------------------------------------------------------------------+
| **Signal**                                                     | **Parameter**                                                                              |
+----------------------------------------------------------------+--------------------------------------------------------------------------------------------+
| :ref:`choose_options<class_Player_Hand_signal_choose_options>` | :ref:`option<interface_core_view_choose_options_return_parameter_option>`                  |
+----------------------------------------------------------------+--------------------------------------------------------------------------------------------+

.. _interface_core_view_choose_options_return_parameter_option:

- **Array** option

This is an array containing the option's index chosen by the player.


.. _interface_core_view_hand_updated:

Hand Updated
------------

When **adding**, **removing**, or **killing** a card, the view needs to notify the player object that the hand has been successfuly updated.

The view needs to emit the ``hand_updated`` signal at the end of each of the following methods (they need to be implemented too):

- ``_on_add_card``
- ``_on_remove_card``
- ``_on_kill_card``


.. _interface_core_view_update_visual:

Update Visual
-------------

.. _interface_core_view_update_visual_init_player:

Player Initialization
*********************

At the beginning of a game, the view needs to have the basic information about the player.
To do so, the player object associated with the view emit the ":ref:`init_player<class_Player_Base_signal_init_player>`" signal passing itself, so the view can get all the info about the player (username, amount of cards, balance, etc).

+----------------------------------------------------------+--------------------------------------------------------------------------------------------+
| **Signal**                                               | **Parameter**                                                                              |
+----------------------------------------------------------+--------------------------------------------------------------------------------------------+
| :ref:`init_player<class_Player_Base_signal_init_player>` | :ref:`player<interface_core_view_update_visual_init_player_parameter_player>`              |
+----------------------------------------------------------+--------------------------------------------------------------------------------------------+

.. _interface_core_view_update_visual_init_player_parameter_player:

- :ref:`Player_Base<class_Player_Base>` player

The player object itself.

.. _interface_core_view_update_visual_player_balance:

Player's Balance
****************

During a game, the player's balance is going to change a lot, to notify the view, the player object emit the ":ref:`change_balance<class_Player_Base_signal_change_balance>`" signal along with the balance of the player.

+----------------------------------------------------------------+--------------------------------------------------------------------------------------------+
| **Signal**                                                     | **Parameter**                                                                              |
+----------------------------------------------------------------+--------------------------------------------------------------------------------------------+
| :ref:`change_balance<class_Player_Base_signal_change_balance>` | :ref:`balance<interface_core_view_update_visual_player_balance_parameter_balance>`         |
+----------------------------------------------------------------+--------------------------------------------------------------------------------------------+

.. _interface_core_view_update_visual_player_balance_parameter_balance:

- **int** balance

Player's balance.

.. _interface_core_view_update_visual_player_hand:

Player's Hand
*************

During a game the player's hand is also going to change, by loosing, adding or removing a card.
To notify the view about all of these changes, the player object emit the following signals:

.. _interface_core_view_update_visual_player_hand_add_card:

- :ref:`add_card<class_Player_Base_signal_add_card>` **(** :ref:`Card<class_Card>` card **)**

Signal to notify the view to add a card in player’s hand.

**Parameter:**

- :ref:`Card<class_Card>` card: Card to add to the player's hand visual.

----

.. _interface_core_view_update_visual_player_hand_remove_card:

- :ref:`remove_card<class_Player_Base_signal_remove_card>` **(** **int** card_id **)**

Signal to notify the view to remove the card of index **card_id** in player’s hand.

**Parameter:**

- **int** card_id: Index of the card to remove from the player's hand visual.

----

.. _interface_core_view_update_visual_player_hand_kill_card:

- :ref:`kill_card<class_Player_Base_signal_kill_card>` **(** **int** card_index, :ref:`CARD_TYPE<class_Card_enum_CARD_TYPE>` card_type, **bool** is_alive **)**

Signal to notify the view to kill the card of index **card_index** in player’s hand.

**Parameters:**

- **int** card_index: Index of the card to kill in the player's hand visual.
- :ref:`CARD_TYPE<class_Card_enum_CARD_TYPE>` card_type: The card type of the card that as been killed.
- **bool** is_alive: ``true`` if the player is alive else ``false``.


.. _interface_core_view_update_visual_hide_action_reaction:

Hide Action - Reaction
**********************

After an action or a reaction is made by the player, or when the action/reaction timer timeout the player is not allowed to make another action until the next "phase".
The Core send the following signals to notify the view when to stop giving options to the player.

.. _interface_core_view_update_visual_hide_action_reaction_end_reaction:

- :ref:`end_reaction<class_Player_Base_signal_end_reaction>` **(** **)**

Signal called when the player cannot react anymore to the current action.

----

.. _interface_core_view_update_visual_hide_action_reaction_end_turn:

- :ref:`end_turn<class_Player_Base_signal_end_turn>` **(** **)**

Signal called when it's the end of the player's turn.

----

.. _interface_core_view_update_visual_hide_action_reaction_player_action:

- :ref:`player_action<class_Player_Base_signal_player_action>` **(** :ref:`Action<class_Action>` action **)**

Signal when the action is sent to the board (you can disable action selection).

----

.. _interface_core_view_update_visual_hide_action_reaction_stop_reaction:

- :ref:`stop_reaction<class_Player_Base_signal_stop_reaction>` **(** **)**

Signal to hide player reaction screen (or disable reaction buttons).
