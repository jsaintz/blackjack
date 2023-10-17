import 'dart:developer';

import 'package:blackjack/models/deck_model.dart';
import 'package:blackjack/services/deck_services.dart';
import 'package:flutter/foundation.dart';

class DeckProvider extends ChangeNotifier {
  DeckModel? _deck;

  Future<void> shuffleDeck() async {
    final newDeck = await DeckService().newDeck();
    _deck = newDeck;
    if (_deck != null) {
      log(_deck!.success.toString());
      notifyListeners();
    }
  }

  Future<void> drawCard() async {
    if (_deck != null) {
      final response = await DeckService().drawCards(_deck!, count: 1);
      _deck!.remaining = response.remaining;
      log(_deck!.remaining.toString());
      notifyListeners();
    }
  }

  Future<void> reshuffleCard() async {
    if (_deck != null) {
      final response = await DeckService().reshuffleCards(_deck!, count: 1);
      _deck!.remaining = response.remaining;
      log(_deck!.remaining.toString());
      notifyListeners();
    }
  }

  int calculateScore() {
    if (_deck == null) {
      return 0;
    }

    int score = 0;
    int aceCount = 0;

    for (final card in _deck!.cards) {
      final value = cardValue(card.value);

      if (value == 11) {
        aceCount++;
      }
      score += value;
    }

    while (score > 21 && aceCount > 0) {
      score -= 10;
      aceCount--;
    }
    return score;
  }

  int cardValue(String card) {
    final rank = card.split(' ')[0];

    if (rank == 'ACE') {
      return 1;
    } else if (rank == 'KING' || rank == 'QUEEN' || rank == 'JACK') {
      return 10;
    } else {
      return int.tryParse(rank) ?? 0;
    }
  }

  String evaluateScore() {
    if (_deck == null) {
      return 'Deck não inicializado'; // Ou outra ação apropriada em caso de _deck nulo
    }

    final score = calculateScore();
    if (score > 21) {
      return 'Acima de 21';
    } else if (score < 21) {
      return 'Abaixo de 21';
    } else {
      return 'Igual a 21';
    }
  }
}
