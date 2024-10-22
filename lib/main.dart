import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const CardbattlePageStateful(),
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
  int leftDiceNumber = 0; // 초기값 0으로 설정
  int rightDiceNumber = 0; // 초기값 0으로 설정
  bool isFirstClickDefense = true; // 첫번째 클릭은 방어력 적용
  bool showStats = false; // 수치를 보여줄지 결정하는 변수

  String? leftStatType;
  String? rightStatType;
  String? winner; // 승리 카드 구분

  int? leftStatValue; // 왼쪽 카드의 공격력 또는 방어력
  int? rightStatValue; // 오른쪽 카드의 공격력 또는 방어력

  final List<Map<String, int>> diceStats = [
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
        leftDiceNumber = Random().nextInt(16) + 1;
        leftStatType = isFirstClickDefense ? 'Defense' : 'Attack';
        leftStatValue = isFirstClickDefense
            ? diceStats[leftDiceNumber - 1]['defense']
            : diceStats[leftDiceNumber - 1]['attack'];
      } else if (card == 'right') {
        rightDiceNumber = Random().nextInt(16) + 1;
        rightStatType = isFirstClickDefense ? 'Defense' : 'Attack';
        rightStatValue = isFirstClickDefense
            ? diceStats[rightDiceNumber - 1]['defense']
            : diceStats[rightDiceNumber - 1]['attack'];
      }

      showStats = true;
      isFirstClickDefense = !isFirstClickDefense;

      // 두 카드가 모두 선택된 경우에만 승패를 판단
      if (leftDiceNumber != 0 && rightDiceNumber != 0) {
        determineWinner();
      }
    });
  }

  void determineWinner() {
    // 조커 카드인 경우 무승부 처리
    if ((leftDiceNumber == 1 || leftDiceNumber == 9) &&
        (rightDiceNumber == 1 || rightDiceNumber == 9)) {
      winner = 'draw';
      return;
    }

    if (leftDiceNumber == 1 || leftDiceNumber == 9) {
      // 왼쪽 카드가 조커인 경우
      winner = 'left';
      return;
    }

    if (rightDiceNumber == 1 || rightDiceNumber == 9) {
      // 오른쪽 카드가 조커인 경우
      winner = 'right';
      return;
    }

    if (leftStatType == 'Defense' && rightStatType == 'Attack') {
      int leftDefense = diceStats[leftDiceNumber - 1]['defense']!;
      int rightAttack = diceStats[rightDiceNumber - 1]['attack']!;
      if (leftDefense > rightAttack) {
        winner = 'left';
      } else if (rightAttack > leftDefense) {
        winner = 'right';
      } else {
        winner = 'draw';
      }
    } else if (leftStatType == 'Attack' && rightStatType == 'Defense') {
      int leftAttack = diceStats[leftDiceNumber - 1]['attack']!;
      int rightDefense = diceStats[rightDiceNumber - 1]['defense']!;
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
      leftDiceNumber = 0;
      rightDiceNumber = 0;
      leftStatType = null;
      rightStatType = null;
      leftStatValue = null;
      rightStatValue = null;
      showStats = false;
      isFirstClickDefense = true;
      winner = null; // 승리 정보 초기화
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
                                            BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 15.0,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Image.asset(
                                    leftDiceNumber == 0
                                        ? 'assets/card/default.png'
                                        : 'assets/card/card$leftDiceNumber.png',
                                    color: winner == 'right'
                                        ? Colors.grey.withOpacity(0.7)
                                        : null, // 진 카드의 명도를 낮춤
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
                                            BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 15.0,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Image.asset(
                                    rightDiceNumber == 0
                                        ? 'assets/card/default.png'
                                        : 'assets/card/card$rightDiceNumber.png',
                                    color: winner == 'left'
                                        ? Colors.grey.withOpacity(0.7)
                                        : null, // 진 카드의 명도를 낮춤
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
                // 주사위 초기화 버튼
                ElevatedButton(
                  onPressed: resetDice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue.withOpacity(0.4), // 배경색을 반투명으로 설정
                    padding: EdgeInsets.zero, // 패딩을 0으로 설정하여 이미지 크기에 맞추기
                  ),
                  child: Image.asset(
                    'assets/reset.png', // 이미지 파일 경로
                    width: 24, // 이미지 너비 (필요에 따라 조정)
                    height: 24, // 이미지 높이 (필요에 따라 조정)
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
