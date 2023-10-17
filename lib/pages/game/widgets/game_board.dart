import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blackjack/providers/blackjack_provider.dart';
import 'package:blackjack/models/player_model.dart';
import 'package:blackjack/models/card_model.dart';
import 'package:blackjack/pages/game/widgets/card_list.dart';
import 'package:blackjack/pages/game/widgets/deck_pile.dart';
import 'package:blackjack/pages/game/widgets/discard_pile.dart';
import 'package:blackjack/pages/game/widgets/player_info.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BlackJackProvider>(
        builder: (context, model, child) {
          return model.currentDeck != null ? _buildGameContent(model, context) : _buildNewGameButton(model);
        },
      ),
    );
  }

  Widget _buildGameContent(BlackJackProvider model, BuildContext context) {
    PlayerModel player = PlayerModel(name: 'Jonatas');
    PlayerModel playerbank = PlayerModel(name: 'Banca');

    if (model.players.isNotEmpty) {
      player = model.players[0];
    }
    if (model.players.length > 1) {
      playerbank = model.players[1];
    }

    int playerScore = model.calculateAccumulatedPoints(player);
    int playerBankScore = model.calculateAccumulatedPoints(playerbank);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/tp-game.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          PlayerInfo(turn: model.turn),
          Expanded(
            child: Stack(
              children: [
                _buildGameCenterContent(model),
                Align(
                  alignment: Alignment.topCenter,
                  child: CardList(
                    player: model.players[1],
                    onPlayCard: (CardModel card) {
                      model.playCard(player: model.players[1], card: card);

                      if (model.gameIsOver) {
                        if (playerScore == 21) {
                          _showVictoryDialog(context);
                        } else {
                          _showDefeatDialog(context);
                        }
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    '${playerbank.name} - Pontuação: $playerBankScore',
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildGameBottomContent(model, context, player, playerScore),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCenterContent(BlackJackProvider model) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  await model.drawCards(model.turn.currentPlayer);
                },
                child: DeckPile(
                  remaining: model.currentDeck!.remaining!,
                ),
              ),
              const SizedBox(width: 8),
              DiscardPile(
                cards: model.discards,
                onPressed: (card) {
                  model.drawCardsFromDiscard(model.turn.currentPlayer);
                },
              ),
            ],
          ),
          if (model.bottomWidget != null && model.showBottomWidget) model.bottomWidget!,
        ],
      ),
    );
  }

  Widget _buildGameBottomContent(BlackJackProvider model, BuildContext context, PlayerModel player, int playerScore) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Text(
                  '${player.name} - Pontuação: $playerScore',
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
                if (model.turn.currentPlayer == model.players[0]) _buildPlayerControls(model, context),
              ],
            ),
          ),
          CardList(
            player: model.players[0],
            onPlayCard: (CardModel card) {
              model.playCard(player: model.players[0], card: card);

              if (model.gameIsOver) {
                if (playerScore == 21) {
                  _showVictoryDialog(context);
                } else {
                  _showDefeatDialog(context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerControls(BlackJackProvider model, BuildContext context) {
    final player = model.players[0];
    final playerScore = model.calculateAccumulatedPoints(player);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...model.additionalButtons
            .map((button) => Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                  ),
                  child: ElevatedButton(
                    onPressed: button.enabled && !model.gameIsOver ? button.onPressed : null,
                    child: Text(button.label),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildNewGameButton(BlackJackProvider model) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg-home.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            final players = [
              PlayerModel(name: "Jonatas", isHuman: true),
              PlayerModel(name: "Banca", isHuman: false),
            ];
            model.newGame(players);
          },
          child: const Text("Novo Jogo"),
        ),
      ),
    );
  }

  Future<void> _showVictoryDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vitória!'),
          content: const Text('Você ganhou a rodada!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDefeatDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Derrota!'),
          content: const Text('Você perdeu a rodada. Ultrapassou 21 pontos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
