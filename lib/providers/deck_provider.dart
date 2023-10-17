import 'dart:developer';

import 'package:blackjack/common/constants.dart';
import 'package:blackjack/main.dart';
import 'package:blackjack/models/action_button_model.dart';
import 'package:blackjack/models/card_model.dart';
import 'package:blackjack/models/deck_model.dart';
import 'package:blackjack/models/player_model.dart';
import 'package:blackjack/models/turn_model.dart';
import 'package:blackjack/services/deck_services.dart';
import 'package:flutter/material.dart';

class DeckProvider with ChangeNotifier {
  late DeckService _service;

  DeckProvider() {
    _service = DeckService();
  }

  late Turn _turn;
  Turn get turn => _turn;

  DeckModel? _currentDeck;
  DeckModel? get currentDeck => _currentDeck;

  List<PlayerModel> _players = [];
  List<PlayerModel> get players => _players;

  List<CardModel> _discards = [];
  List<CardModel> get discards => _discards;
  CardModel? get discardTop => _discards.isEmpty ? null : _discards.last;

  Map<String, dynamic> gameState = {};
  Widget? bottomWidget;

  List<ActionButton> additionalButtons = [];

  Future<void> newGame(List<PlayerModel> players) async {
    final deck = await _service.newDeck();
    _currentDeck = deck;
    _players = players;
    _discards = [];
    setupBoard();
    _turn = Turn(players: players, currentPlayer: players.first);

    notifyListeners();
  }

  Future<void> setupBoard() async {}

  Future<void> drawCardToDiscardPile({int count = 1}) async {
    final draw = await _service.drawCards(_currentDeck!, count: count);

    _currentDeck!.remaining = draw.remaining;
    _discards.addAll(draw.cards);

    notifyListeners();
  }

  void setBottomWidget(Widget? widget) {
    bottomWidget = widget;
    notifyListeners();
  }

  void setTrump(Suit suit) {
    setBottomWidget(
      Card(
        child: Text(
          CardModel.suitToUnicode(suit),
          style: TextStyle(
            fontSize: 24,
            color: CardModel.suitToColor(suit),
          ),
        ),
      ),
    );
  }

  bool get showBottomWidget {
    return true;
  }

  void setLastPlayed(CardModel card) {
    gameState[Constants.GS_LAST_SUIT] = card.suit;
    gameState[Constants.GS_LAST_VALUE] = card.value;

    setTrump(card.suit);

    notifyListeners();
  }

  bool get canDrawCard {
    return turn.drawCount < 1;
  }

  Future<void> drawCards(
    PlayerModel player, {
    int count = 1,
    bool allowAnyTime = false,
  }) async {
    if (currentDeck == null) return;
    if (!allowAnyTime && !canDrawCard) return;

    final draw = await _service.drawCards(_currentDeck!, count: count);

    player.addCards(draw.cards);

    _turn.drawCount += count;

    _currentDeck!.remaining = draw.remaining;

    notifyListeners();
  }

  bool canPlayCard(CardModel card) {
    if (gameIsOver) return false;

    return _turn.actionCount < 1;
  }

  Future<void> playCard({
    required PlayerModel player,
    required CardModel card,
  }) async {
    if (!canPlayCard(card)) return;

    player.removeCard(card);

    _discards.add(card);

    if (player.isBot) {
      _discards.addAll(player.cards);
    }

    _turn.actionCount += 1;

    setLastPlayed(card);

    await applyCardSideEffects(card);

    if (gameIsOver) {
      finishGame();
    }
  }

  bool canDrawCardsFromDiscardPile({int count = 1}) {
    if (!canDrawCard) return false;

    return discards.length >= count;
  }

  void drawCardsFromDiscard(PlayerModel player, {int count = 1}) {
    if (!canDrawCardsFromDiscardPile(count: count)) {
      return;
    }

    final start = discards.length - count;
    final end = discards.length;
    final cards = discards.getRange(start, end).toList();

    discards.removeRange(start, end);

    player.addCards(cards);

    turn.drawCount += count;

    notifyListeners();
  }

  Future<void> applyCardSideEffects(CardModel card) async {}

  bool get canEndTurn {
    return turn.drawCount > 0;
  }

  void endTurn() {
    _turn.nextTurn();

    if (_turn.currentPlayer.isBot) {
      botTurn();
    }

    notifyListeners();
  }

  bool get gameIsOver {
    return currentDeck!.remaining! < 1;
  }

  void finishGame() {
    notifyListeners();
  }

  Future<void> botTurn() async {
    await Future.delayed(const Duration(seconds: 1));
    await drawCards(_turn.currentPlayer);
    final currentPlayer = _turn.currentPlayer;
    if (currentPlayer.cards.isNotEmpty) {
      for (int index = 0; index < currentPlayer.cards.length; index++) {
        await Future.delayed(const Duration(seconds: 1));
        playCard(
          player: currentPlayer,
          card: currentPlayer.cards[index],
        );
      }
    }
    if (canEndTurn) {
      Future.microtask(() {
        endTurn();
      });
    }
    notifyListeners();
  }

  void showToast(String message, {int seconds = 3, SnackBarAction? action}) {
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
        action: action,
      ),
    );
  }

  Future<void> shuffleCurrentDeck() async {
    if (_currentDeck != null) {
      final response = await _service.reshuffleCards(_currentDeck!, count: 1);
      _currentDeck!.remaining = response.remaining;
      log(_currentDeck!.remaining.toString());
      notifyListeners();
    }
  }
}
