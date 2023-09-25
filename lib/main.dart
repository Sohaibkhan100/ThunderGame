import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: MyGame(),
    );
  }
}

class MyGame extends StatefulWidget {
  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  double characterY = 0.5;
  double characterX = 0.5;
  double characterSize = 0.1;
  double obstacleY = 0;
  double obstacleX = 0;
  double obstacleSize = 0.2;
  double obstacleSpeed = 0.01;
  int score = 0;
  bool isGameOver = false;
  bool isWin = false; // Add a win flag
  int leftTapCount = 0; // Counter for left taps

  void jump() {
    if (!isGameOver && !isWin) {
      setState(() {
        characterY -= 0.1;
        // Check if character reached the top
        if (characterY <= 0) {
          isWin = true;
          score++;
          isGameOver = true;
        }
      });
    }
  }

  void moveLeft() {
    if (!isGameOver && characterX > 0) {
      setState(() {
        characterX -= 0.1;
      });
    }
  }

  void moveRight() {
    if (!isGameOver && characterX < 1 - characterSize) {
      setState(() {
        characterX += 0.1;
      });
    }
  }

  void onTapLeft() {
    if (!isGameOver && !isWin) {
      leftTapCount++;
      if (leftTapCount >= 3) {
        // Move left when tapped three times
        moveLeft();
        leftTapCount = 0; // Reset the counter
      }
    }
  }

  void startGame() {
    Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (!isGameOver && !isWin) {
        setState(() {
          obstacleY += obstacleSpeed;

          // Check for collision with obstacle
          if ((characterX + characterSize > obstacleX &&
              characterX < obstacleX + obstacleSize) &&
              (characterY + characterSize > obstacleY &&
                  characterY < obstacleY + obstacleSize)) {
            isGameOver = true;
            timer.cancel();
          }

          // Check for scoring
          if (obstacleY > 1) {
            score++;
            obstacleX = Random().nextDouble();
            obstacleY = -obstacleSize;
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void restartGame() {
    setState(() {
      characterY = 0.5;
      characterX = 0.5;
      score = 0;
      isGameOver = false;
      isWin = false;
      obstacleX = Random().nextDouble();
      obstacleY = -obstacleSize;
    });
    startGame();
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GestureDetector(
        // onTap: jump,
        // onDoubleTap: moveRight,
        // onLongPress: onTapLeft, // Handle long press as left tap
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/background.jpeg"),fit: BoxFit.fill)),
          child: Stack(
            children: [
              Positioned(
                top: characterY * MediaQuery.of(context).size.height,
                left: characterX * MediaQuery.of(context).size.width,
                child: Container(
                  width: characterSize * MediaQuery.of(context).size.width,
                  height: characterSize * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/car.png"),fit: BoxFit.fill)),
                ),
              ),
              Positioned(
                top: obstacleY * MediaQuery.of(context).size.height,
                left: obstacleX * MediaQuery.of(context).size.width,
                child: Container(
                  width: obstacleSize * MediaQuery.of(context).size.width,
                  height: obstacleSize * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/pipe.png"),fit: BoxFit.fill)),
                ),
              ),
              Positioned(
                  left:  MediaQuery.of(context).size.width*0.35,

                bottom: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                    IconButton(onPressed: (){moveLeft();}, icon: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade300,
                        child: Icon(Icons.keyboard_arrow_left))),
                    IconButton(onPressed: (){jump();}, icon: CircleAvatar(                        backgroundColor: Colors.deepPurple.shade300,
                        child: Icon(Icons.arrow_upward))),
                    IconButton(onPressed: (){moveRight();}, icon: CircleAvatar(                        backgroundColor: Colors.deepPurple.shade300,
                         child: Icon(Icons.keyboard_arrow_right)))
                  ],)),
              Center(
                child: isGameOver
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isWin ? 'You Win!' : 'Game Over',
                      style: TextStyle(fontSize: 32
                      ,color: Colors.white),
                    ),
                    Text(
                      'Score: $score',
                      style: TextStyle(fontSize: 24,color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        restartGame();
                      },

                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade300,
                          radius: 50,
                          child: Text('Restart')),
                    ),
                  ],
                )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
