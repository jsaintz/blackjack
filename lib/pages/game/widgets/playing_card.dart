import 'package:blackjack/common/constants.dart';
import 'package:blackjack/models/card_model.dart';
import 'package:blackjack/pages/game/widgets/card_back.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlayingCard extends StatelessWidget {
  final CardModel card;
  final double size;
  final bool visible;
  final Function(CardModel)? onPlayCard;

  const PlayingCard({
    Key? key,
    required this.card,
    this.size = 1,
    this.visible = false,
    this.onPlayCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (onPlayCard != null) onPlayCard!(card);
        },
        child: Container(
          width: Constants.cardWidth * size,
          height: Constants.cardHeight * size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: visible
              ? CachedNetworkImage(
                  imageUrl: card.image,
                  width: Constants.cardWidth * size,
                  height: Constants.cardHeight * size,
                )
              : CardBack(size: size),
        ),
      ),
    );
  }
}
