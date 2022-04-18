import 'package:flutter/material.dart';
import 'package:tic_tac_game/game_logic.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String activePlayer = 'x';

  bool gameOver = false;

  int turn = 0;

  String result = 'result';

  Game game = Game();

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  ...firstBlock(),
                  _expanded(context),
                  ...lastBlock(),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...firstBlock(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        ...lastBlock(),
                      ],
                    ),
                  ),
                  _expanded(context),
                ],
              ),
      ),
    );
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
        title: const Text(
          'Turn on/off two player',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        value: isSwitched,
        onChanged: (bool newValue) {
          setState(
            () {
              isSwitched = newValue;
            },
          );
        },
      ),
      Text(
        'it \'s $activePlayer turn'.toUpperCase(),
        style: const TextStyle(
          fontSize: 52,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(16),

            onTap: gameOver ? null : () => _onTap(index),

            child: Container(

              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  Player.playerX.contains(index)
                      ? 'x'
                      : Player.playerY.contains(index)
                          ? 'o'
                          : '',
                  style: TextStyle(
                    fontSize: 52,
                    color: Player.playerX.contains(index)
                        ? Colors.blue
                        : Colors.pink,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> lastBlock() {
    return [
      Text(
        result,
        style: const TextStyle(
          fontSize: 42,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
      ),
      ElevatedButton.icon(
        icon: const Icon(Icons.replay),
        onPressed: () {
          setState(() {
            Player.playerX = [];

            Player.playerY = [];

            activePlayer = 'x';

            gameOver = false;

            turn = 0;

            result = '';

            game = Game();

            isSwitched = false;
          });
        },
        label: const Text('Repeat the game'),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      ),
      const SizedBox(height: 30),
    ];
  }

  _onTap(int index) async {



    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerY.isEmpty || !Player.playerY.contains(index))) {
      game.playGame(index, activePlayer);

      updateState();
      if (!isSwitched && !gameOver && turn != 9) {

        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {

    return setState(() {
      activePlayer = (activePlayer == 'x') ? 'o' : 'x';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the winner';
      } else if (!gameOver && turn == 9) {
        result = 'It\'s Draw!';
      }
    });
  }
}
