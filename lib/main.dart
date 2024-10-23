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
        body: CardbattlePageStateful(),
      ),
    );
  }
}

class CardbattlePageStateful extends StatefulWidget {
  const CardbattlePageStateful({super.key});

  @override
  _CardbattleStatefulState createState() => _CardbattleStatefulState();
}

class _CardbattleStatefulState extends State<CardbattlePageStateful> {
  int leftCardIndex = 0;
  int rightCardIndex = 0;
  bool isFirstClickDefense = true;
  bool showStats = false;

  String? leftStatType;
  String? rightStatType;
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

  void applyStatsToCard(String card) {
    setState(() {
      if (card == 'left') {
        leftCardIndex = Random().nextInt(16) + 1;
        leftStatType = isFirstClickDefense ? 'Defense' : 'Attack';
        leftStatValue = isFirstClickDefense
            ? cardStats[leftCardIndex - 1]['defense']
            : cardStats[leftCardIndex - 1]['attack'];
      } else if (card == 'right') {
        rightCardIndex = Random().nextInt(16) + 1;
        rightStatType = isFirstClickDefense ? 'Defense' : 'Attack';
        rightStatValue = isFirstClickDefense
            ? cardStats[rightCardIndex - 1]['defense']
            : cardStats[rightCardIndex - 1]['attack'];
      }

      showStats = true;
      isFirstClickDefense = !isFirstClickDefense;

      if (leftCardIndex != 0 && rightCardIndex != 0) {
        determineWinner();
      }
    });
  }

  void determineWinner() {
    if ((leftCardIndex == 1 || leftCardIndex == 9) &&
        (rightCardIndex == 1 || rightCardIndex == 9)) {
      winner = 'draw';
      return;
    }

    if (leftCardIndex == 1 || leftCardIndex == 9) {
      winner = 'left';
      return;
    }

    if (rightCardIndex == 1 || rightCardIndex == 9) {
      winner = 'right';
      return;
    }

    if (leftStatType == 'Defense' && rightStatType == 'Attack') {
      int leftDefense = cardStats[leftCardIndex - 1]['defense']!;
      int rightAttack = cardStats[rightCardIndex - 1]['attack']!;
      if (leftDefense > rightAttack) {
        winner = 'left';
      } else if (rightAttack > leftDefense) {
        winner = 'right';
      } else {
        winner = 'draw';
      }
    } else if (leftStatType == 'Attack' && rightStatType == 'Defense') {
      int leftAttack = cardStats[leftCardIndex - 1]['attack']!;
      int rightDefense = cardStats[rightCardIndex - 1]['defense']!;
      if (leftAttack > rightDefense) {
        winner = 'left';
      } else if (rightDefense > leftAttack) {
        winner = 'right';
      } else {
        winner = 'draw';
      }
    }
  }

  void resetCards() {
    setState(() {
      leftCardIndex = 0;
      rightCardIndex = 0;
      leftStatType = null;
      rightStatType = null;
      leftStatValue = null;
      rightStatValue = null;
      showStats = false;
      isFirstClickDefense = true;
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
                    // 왼쪽 카드
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => applyStatsToCard('left'),
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
                                    leftCardIndex == 0
                                        ? 'assets/card/default.png'
                                        : 'assets/card/card$leftCardIndex.png',
                                    color: winner == 'right'
                                        ? Colors.grey.withOpacity(0.7)
                                        : null,
                                    colorBlendMode: BlendMode.modulate,
                                  ),
                                ),
                                if (winner == 'left') // 승리 텍스트 표시
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
                                if (winner == 'right') // 패배 텍스트 표시
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
                          if (showStats)
                            Text(
                              '$leftStatType: $leftStatValue',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                    // 오른쪽 카드
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => applyStatsToCard('right'),
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
                                    rightCardIndex == 0
                                        ? 'assets/card/default.png'
                                        : 'assets/card/card$rightCardIndex.png',
                                    color: winner == 'left'
                                        ? Colors.grey.withOpacity(0.7)
                                        : null,
                                    colorBlendMode: BlendMode.modulate,
                                  ),
                                ),
                                if (winner == 'right') // 승리 텍스트 표시
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
                                if (winner == 'left') // 패배 텍스트 표시
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
                          if (showStats)
                            Text(
                              '$rightStatType: $rightStatValue',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 카드 초기화 버튼
                ElevatedButton(
                  onPressed: resetCards,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.4),
                    padding: EdgeInsets.zero,
                  ),
                  child: Image.asset(
                    'assets/reset.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
