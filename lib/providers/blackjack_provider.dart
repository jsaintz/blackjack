import 'dart:math';

import 'package:blackjack/common/constants.dart';
import 'package:blackjack/models/action_button_model.dart';
import 'package:blackjack/models/card_model.dart';
import 'package:blackjack/providers/game_provider.dart';

class BlackJackProvider extends GameProvider {
  @override
  Future<void> setupBoard() async {
    for (var player in players) {
      await drawCards(player, count: 3, allowAnyTime: true);
    }

    await drawCardToDiscardPile();

    turn.drawCount = 0;
  }

  @override
  bool get canEndTurn {
    return turn.drawCount == 1 && turn.actionCount == 1;
  }

  @override
  bool get canDrawCard {
    return turn.drawCount < 1;
  }

  @override
  bool canPlayCard(CardModel card) {
    return turn.drawCount == 1 && turn.actionCount < 1;
  }

  @override
  bool get gameIsOver {
    if (gameState[Constants.GS_PLAYER_HAS_KNOCKED] != null &&
        gameState[Constants.GS_PLAYER_HAS_KNOCKED] == turn.currentPlayer) {
      return true;
    }

    return false;
  }

  @override
  void finishGame() {
    for (final p in players) {
      int diamondsPoints = 0;
      int spadesPoints = 0;
      int clubsPoints = 0;
      int heartsPoints = 0;

      for (final c in p.cards) {
        int points = 0;
        switch (c.value) {
          case "KING":
          case "QUEEN":
          case "JACK":
            points += 10;
            break;
          case "ACE":
            points += 11;
            break;
          default:
            points += int.parse(c.value);
        }
        switch (c.suit) {
          case Suit.clubs:
            clubsPoints += points;
            break;
          case Suit.diamonds:
            diamondsPoints += points;
            break;
          case Suit.hearts:
            heartsPoints += points;
            break;
          case Suit.spades:
            spadesPoints += points;
            break;
          case Suit.other:
        }
      }

      final totalPoints = [spadesPoints, heartsPoints, diamondsPoints, clubsPoints].fold(spadesPoints, max);
      log(totalPoints);

      p.score = totalPoints;
    }

    notifyListeners();
  }

  @override
  bool get showBottomWidget => false;

  @override
  Future<void> botTurn() async {
    print("TODO: bot turn"); //TODO: update bot logic
    super.botTurn();
  }

  @override
  // TODO: implement additionalButtons
  List<ActionButton> get additionalButtons {
    return [
      ActionButton(
        label: "Knock",
        onPressed: () {
          gameState[Constants.GS_PLAYER_HAS_KNOCKED] = turn.currentPlayer;

          endTurn();
        },
      ),
    ];
  }
}
