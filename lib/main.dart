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
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;

  // 공격력과 방어력 정의
  final List<Map<String, int>> diceStats = [
    {'attack': 9, 'defense': 5}, // 1번 주사위
    {'attack': 6, 'defense': 7}, // 2번 주사위
    {'attack': 8, 'defense': 4}, // 3번 주사위
    {'attack': 7, 'defense': 4}, // 4번 주사위
    {'attack': 4, 'defense': 6}, // 5번 주사위
    {'attack': 8, 'defense': 3}, // 6번 주사위
  ];

  // 첫번째 주사위의 방어력, 두번째 주사위의 공격력으로 승자를 결정
  String determineWinner() {
    int leftDefense = diceStats[leftDiceNumber - 1]['defense']!;
    int rightAttack = diceStats[rightDiceNumber - 1]['attack']!;
    if (leftDefense > rightAttack) {
      return 'Left Wins';
    } else if (rightAttack > leftDefense) {
      return 'Right Wins';
    } else {
      return 'Draw';
    }
  }

  // 왼쪽 주사위 굴리기
  void rollLeftDice() {
    setState(() {
      leftDiceNumber = Random().nextInt(6) + 1;
    });
  }

  // 오른쪽 주사위 굴리기
  void rollRightDice() {
    setState(() {
      rightDiceNumber = Random().nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'), // 배경 이미지
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // 투명 배경 설정
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
                    // 왼쪽 주사위
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset('assets/dice$leftDiceNumber.png'),
                          // 방어력 표시
                          Text(
                            'Defense: ${diceStats[leftDiceNumber - 1]['defense']}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: rollLeftDice,
                            child: const Text('Roll Left Dice'),
                          ),
                        ],
                      ),
                    ),
                    // 오른쪽 주사위
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset('assets/dice$rightDiceNumber.png'),
                          // 공격력 표시
                          Text(
                            'Attack: ${diceStats[rightDiceNumber - 1]['attack']}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: rollRightDice,
                            child: const Text('Roll Right Dice'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 결과 표시
                if (leftDiceNumber != 1 && rightDiceNumber != 1)
                  Text(
                    determineWinner(),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
