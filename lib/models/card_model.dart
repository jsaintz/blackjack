import 'package:flutter/material.dart';

enum Suit {
  hearts,
  clubs,
  diamonds,
  spades,
  other,
}

class CardModel {
  final String image;
  final Suit suit;
  final String value;
  final String code;

  CardModel({
    required this.image,
    required this.suit,
    required this.value,
    required this.code,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      image: json['image'],
      suit: stringToSuit(json['suit']),
      value: json['value'],
      code: json['code'],
    );
  }

  static Suit stringToSuit(String suit) {
    switch (suit.toUpperCase().trim()) {
      case "HEARTS":
        return Suit.hearts;
      case "CLUBS":
        return Suit.clubs;
      case "DIAMONDS":
        return Suit.diamonds;
      case "SPADES":
        return Suit.spades;
      default:
        return Suit.other;
    }
  }

  static String suitToString(Suit suit) {
    return suit.toString().split('.').last.capitalize();
  }

  static String suitToUnicode(Suit suit) {
    final unicodeMap = {
      Suit.hearts: "\u2665",
      Suit.clubs: "\u2663",
      Suit.diamonds: "\u2666",
      Suit.spades: "\u2660",
      Suit.other: "Other",
    };
    return unicodeMap[suit] ?? '';
  }

  static Color suitToColor(Suit suit) {
    return [Suit.hearts, Suit.diamonds].contains(suit) ? Colors.red : Colors.black;
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
