import 'package:blackjack/common/constants.dart';
import 'package:blackjack/models/card_model.dart';
import 'package:blackjack/pages/game/widgets/playing_card.dart';
import 'package:flutter/material.dart';

class DiscardPile extends StatelessWidget {
  final List<CardModel> cards;
  final double size;
  final Function(CardModel)? onPressed;

  const DiscardPile({
    Key? key,
    required this.cards,
    this.size = 1,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!(cards.last);
        }
      },
      child: Container(
        width: Constants.cardWidth * size,
        height: Constants.cardHeight * size,
        decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 2)),
        child: IgnorePointer(
          ignoring: true,
          child: Stack(
            children: cards
                .map((card) => PlayingCard(
                      card: card,
                      visible: true,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
