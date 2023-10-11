import 'package:blackjack/models/card_model.dart';

class DeckModel {
  bool? success;
  String? deckId;
  bool? shuffled;
  int? remaining;
  List<CardModel> cards;

  DeckModel({
    required this.deckId,
    required this.shuffled,
    required this.remaining,
    required this.cards,
    required this.success,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    assert(json['deck_id'] != null, 'deck_id não pode ser nulo');
    assert(json['shuffled'] != null, 'shuffled não pode ser nulo');
    assert(json['remaining'] != null, 'remaining não pode ser nulo');
    assert(json['success'] != null, 'success não pode ser nulo');

    final List<dynamic>? cardJsonList = json['cards'];

    return DeckModel(
      success: json['success'],
      deckId: json['deck_id'],
      shuffled: json['shuffled'],
      remaining: json['remaining'],
      cards: (cardJsonList != null)
          ? cardJsonList.map((cardJson) {
              return CardModel.fromJson(cardJson as Map<String, dynamic>);
            }).toList()
          : <CardModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['deck_id'] = deckId;
    data['shuffled'] = shuffled;
    data['remaining'] = remaining;
    return data;
  }

  void shuffle() {
    if (shuffled != true) {
      cards.shuffle();
      shuffled = true;
    }
  }
}
