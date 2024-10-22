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
        backgroundColor: Color.fromARGB(255, 208, 194, 255),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 177, 154, 255),
          elevation: 10.0,
          title: const Text('Double Dices'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: const DicePageStateful(),
      ),
    );
  }
}

class DicePageStateful extends StatefulWidget {
  const DicePageStateful({super.key});

  @override
  _DicePageStatefulState createState() => _DicePageStatefulState();
}

class _DicePageStatefulState extends State<DicePageStateful> {
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;
  String resultMessage = '';

  // 주사위 굴리기
  void rollDice() {
    setState(() {
      leftDiceNumber = Random().nextInt(6) + 1;
      rightDiceNumber = Random().nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      TextButton(
                        onPressed: rollDice,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset('assets/dice$leftDiceNumber.png'),
                        ),
                      ),

                      // Winner Loser 표시
                      Text(
                        leftDiceNumber > rightDiceNumber
                            ? 'Winner'
                            : leftDiceNumber < rightDiceNumber
                                ? 'Loser'
                                : '',
                        style: TextStyle(
                          color: leftDiceNumber > rightDiceNumber
                              ? Colors.yellow
                              : Color.fromARGB(255, 63, 63, 63),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // 오른쪽 주사위
                Expanded(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: rollDice,
                        child: Image.asset('assets/dice$rightDiceNumber.png'),
                      ),
                      // Winner Loser 표시
                      Text(
                        rightDiceNumber > leftDiceNumber
                            ? 'Winner'
                            : rightDiceNumber < leftDiceNumber
                                ? 'Loser'
                                : '',
                        style: TextStyle(
                          color: rightDiceNumber > leftDiceNumber
                              ? Colors.yellow
                              : Color.fromARGB(255, 63, 63, 63),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 무승부
            if (leftDiceNumber == rightDiceNumber)
              const Text(
                '무승부',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: rollDice,
              backgroundColor: Color.fromARGB(255, 166, 138, 255),
              child: const Icon(Icons.casino),
            ),
          ],
        ),
      ),
    );
  }
}
