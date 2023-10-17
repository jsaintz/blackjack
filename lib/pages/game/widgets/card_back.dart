import 'package:blackjack/common/constants.dart';
import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
  final double size;
  final Widget? child;

  const CardBack({Key? key, this.size = 1, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.cardWidth * size,
      height: Constants.cardHeight * size,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: child ?? Container(),
    );
  }
}
