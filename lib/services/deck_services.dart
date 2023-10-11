import 'dart:developer';

import 'package:blackjack/models/deck_model.dart';
import 'package:blackjack/models/draw_model.dart';
import 'package:blackjack/services/api_service.dart';

class DeckService extends ApiService {
  Future<DeckModel> newDeck([int deckCount = 1]) async {
    const path = '/deck/new/shuffle';
    final params = {'deck_count': deckCount};
    final data = await httpGet(path, params: params);
    log(data.toString());
    if (data != null) {
      return DeckModel.fromJson(data);
    } else {
      throw Exception('Falha ao obter dados para criar um novo baralho.');
    }
  }

  Future<DrawModel> drawCards(DeckModel deck, {int count = 1}) async {
    final path = '/deck/${deck.deckId}/draw';
    final params = {'count': count};
    final data = await httpGet(path, params: params);

    if (data != null) {
      return DrawModel.fromJson(data);
    } else {
      throw Exception('Falha ao obter dados para fazer uma jogada.');
    }
  }
}
