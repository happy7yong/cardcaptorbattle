import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: CardBattlePageStateful(),
      ),
    );
  }
}

class CardBattlePageStateful extends StatefulWidget {
  const CardBattlePageStateful({super.key});

  @override
  _CardBattleStatefulState createState() => _CardBattleStatefulState();
}

class _CardBattleStatefulState extends State<CardBattlePageStateful> {
  int leftCardNumber = 0;
  int rightCardNumber = 0;
  bool isFirstClickForDefense = true;
  bool isStatsVisible = false;

  String? leftCardStatType;
  String? rightCardStatType;
  String? winner;

  int? leftStatValue;
  int? rightStatValue;

  final List<Map<String, int>> cardStats = [
    {'attack': 9, 'defense': 5},
    {'attack': 8, 'defense': 4},
    {'attack': 8, 'defense': 3},
    {'attack': 7, 'defense': 6},
    {'attack': 7, 'defense': 4},
    {'attack': 6, 'defense': 5},
    {'attack': 6, 'defense': 4},
    {'attack': 5, 'defense': 4},
    {'attack': 5, 'defense': 9},
    {'attack': 2, 'defense': 9},
    {'attack': 5, 'defense': 8},
    {'attack': 6, 'defense': 7},
    {'attack': 4, 'defense': 7},
    {'attack': 3, 'defense': 7},
    {'attack': 5, 'defense': 6},
    {'attack': 4, 'defense': 6},
  ];

  void applyStatsTo(String card) {
    setState(() {
      if (card == 'left') {
        leftCardNumber = Random().nextInt(16) + 1;
        leftCardStatType = isFirstClickForDefense ? 'Defense' : 'Attack';
        leftStatValue = isFirstClickForDefense
            ? cardStats[leftCardNumber - 1]['defense']
            : cardStats[leftCardNumber - 1]['attack'];
      } else if (card == 'right') {
        rightCardNumber = Random().nextInt(16) + 1;
        rightCardStatType = isFirstClickForDefense ? 'Defense' : 'Attack';
        rightStatValue = isFirstClickForDefense
            ? cardStats[rightCardNumber - 1]['defense']
            : cardStats[rightCardNumber - 1]['attack'];
      }

      isStatsVisible = true;
      isFirstClickForDefense = !isFirstClickForDefense;

      // 양쪽 카드가 선택되었을 때 승자를 결정
      if (leftCardNumber != 0 && rightCardNumber != 0) {
        determineWinner();
      }
    });
  }

  void determineWinner() {
    // 양쪽 조커 카드를 무승부 처리
    if ((leftCardNumber == 1 || leftCardNumber == 9) &&
        (rightCardNumber == 1 || rightCardNumber == 9)) {
      winner = 'draw';
      return;
    }

    if (leftCardNumber == 1 || leftCardNumber == 9) {
      winner = 'left';
      return;
    }

    if (rightCardNumber == 1 || rightCardNumber == 9) {
      winner = 'right';
      return;
    }

    if (leftCardStatType == 'Defense' && rightCardStatType == 'Attack') {
      int leftDefense = cardStats[leftCardNumber - 1]['defense']!;
      int rightAttack = cardStats[rightCardNumber - 1]['attack']!;
      if (leftDefense > rightAttack) {
        winner = 'left';
      } else if (rightAttack > leftDefense) {
        winner = 'right';
      } else {
        winner = 'draw';
      }
    } else if (leftCardStatType == 'Attack' && rightCardStatType == 'Defense') {
      int leftAttack = cardStats[leftCardNumber - 1]['attack']!;
      int rightDefense = cardStats[rightCardNumber - 1]['defense']!;
      if (leftAttack > rightDefense) {
        winner = 'left';
      } else if (rightDefense > leftAttack) {
        winner = 'right';
      } else {
        winner = 'draw';
      }
    }
  }

  void resetDice() {
    setState(() {
      leftCardNumber = 0;
      rightCardNumber = 0;
      leftCardStatType = null;
      rightCardStatType = null;
      leftStatValue = null;
      rightStatValue = null;
      isStatsVisible = false;
      isFirstClickForDefense = true;
      winner = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 10.0,
          title: const Text('Crow Card Battle'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => applyStatsTo('left'),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: winner == 'left'
                                        ? [
                                            const BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 15.0,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Image.asset(
                                    leftCardNumber == 0
                                        ? 'assets/card/default.png'
                                        : 'assets/card/card$leftCardNumber.png',
                                    color: winner == 'right'
                                        ? Colors.grey.withOpacity(0.7)
                                        : null,
                                    colorBlendMode: BlendMode.modulate,
                                  ),
                                ),
                                if (winner == 'left')
                                  const Text(
                                    'Win',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (winner == 'right')
                                  const Text(
                                    'Lose',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (isStatsVisible)
                            Text(
                              '$leftCardStatType: $leftStatValue',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => applyStatsTo('right'),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: winner == 'right'
                                        ? [
                                            const BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 15.0,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Image.asset(
                                    rightCardNumber == 0
                                        ? 'assets/card/default.png'
                                        : 'assets/card/card$rightCardNumber.png',
                                    color: winner == 'left'
                                        ? Colors.grey.withOpacity(0.7)
                                        : null,
                                    colorBlendMode: BlendMode.modulate,
                                  ),
                                ),
                                if (winner == 'right')
                                  const Text(
                                    'Win',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (winner == 'left')
                                  const Text(
                                    'Lose',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (isStatsVisible)
                            Text(
                              '$rightCardStatType: $rightStatValue',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: resetDice,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
