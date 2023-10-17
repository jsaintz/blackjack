import 'package:blackjack/common/constants.dart';
import 'package:blackjack/models/card_model.dart';
import 'package:blackjack/models/player_model.dart';
import 'package:blackjack/pages/game/widgets/playing_card.dart';
import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final double size;
  final PlayerModel player;
  final Function(CardModel)? onPlayCard;

  const CardList({
    Key? key,
    required this.player,
    this.size = 1,
    this.onPlayCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: player.isBot ? 75 : 0,
        left: 100,
        bottom: player.isBot ? 0 : 70,
      ),
      child: SizedBox(
        height: Constants.cardHeight * size,
        width: double.infinity,
        child: Stack(
          children: player.cards.map((card) {
            final index = player.cards.indexOf(card);
            final leftPosition = index * 30.0;
            return Positioned(
              left: leftPosition,
              child: PlayingCard(
                card: card,
                size: size,
                visible: true,
                onPlayCard: onPlayCard,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
