import 'dart:math';
import 'package:blackjack/common/constants.dart';
import 'package:blackjack/models/action_button_model.dart';
import 'package:blackjack/models/card_model.dart';
import 'package:blackjack/models/player_model.dart';
import 'package:blackjack/providers/deck_provider.dart';

class BlackJackProvider extends DeckProvider {
  @override
  Future<void> setupBoard() async {
    for (var player in players) {
      await drawCards(player, count: 1, allowAnyTime: true);
    }

    await drawCardToDiscardPile();

    turn.drawCount = 0;
  }

  @override
  bool get canEndTurn => turn.drawCount == 1 && turn.actionCount == 1;

  @override
  bool get canDrawCard => turn.drawCount < 1;

  @override
  bool canPlayCard(CardModel card) => turn.drawCount == 1 && turn.actionCount < 1;

  @override
  bool get gameIsOver {
    int playerScore = calculateAccumulatedPoints(players[0]);
    int dealerScore = calculateAccumulatedPoints(players[1]);

    if (dealerScore == 21 || playerScore == 21) {
      return true;
    }

    if (dealerScore > 21 || playerScore > 21) {
      return true;
    }
    return false;
  }

  String evaluateScore(int score) {
    if (score > 21) {
      return 'Acima de 21';
    } else if (score < 21) {
      return 'Abaixo de 21';
    } else {
      return 'Igual a 21';
    }
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
          default:
        }
      }

      final totalPoints = [spadesPoints, heartsPoints, diamondsPoints, clubsPoints].fold(spadesPoints, max);

      p.score = totalPoints;
      evaluateScore(p.score);
    }

    notifyListeners();
  }

  @override
  bool get showBottomWidget => false;

  @override
  Future<void> botTurn() async {
    if (gameIsOver) {
      return;
    }

    super.botTurn();
  }

  @override
  List<ActionButton> get additionalButtons => [
        ActionButton(
          label: "Encerar turno",
          onPressed: () {
            gameState[Constants.GS_PLAYER_HAS_KNOCKED] = turn.currentPlayer;

            endTurn();
          },
        ),
      ];

  int calculateAccumulatedPoints(PlayerModel player) {
    int points = 0;

    for (final card in player.cards) {
      switch (card.value) {
        case "KING":
        case "QUEEN":
        case "JACK":
          points += 10;
          break;
        case "ACE":
          points += 11;
          break;
        default:
          points += int.parse(card.value);
      }
    }
    return points;
  }

  Future<void> shuffleCurrentDecks() async {
    await shuffleCurrentDeck();
    notifyListeners();
  }
}
