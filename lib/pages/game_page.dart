import 'package:blackjack/providers/deck_providder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final DeckProvider _deckProvider;

  @override
  void initState() {
    _deckProvider = Provider.of<DeckProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Game"),
        actions: [
          TextButton(
            onPressed: () async {},
            child: const Text(
              "New Game",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await _deckProvider.shuffleDeck();
            },
            child: const Text('Atualiza'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('drawCard'),
          ),
        ],
      ),
    );
  }
}
