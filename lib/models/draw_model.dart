import 'package:blackjack/models/card_model.dart';

class DrawModel {
  final int remaining;
  final List<CardModel> cards;

  DrawModel({
    required this.remaining,
    this.cards = const [],
  });

  factory DrawModel.fromJson(Map<String, dynamic> json) {
    final dynamic jsonCards = json['cards'];
    final List<CardModel> cards = (jsonCards != null && jsonCards is List)
        ? jsonCards.map<CardModel>((card) => CardModel.fromJson(card)).toList()
        : [];

    return DrawModel(remaining: json['remaining'], cards: cards);
  }
}
