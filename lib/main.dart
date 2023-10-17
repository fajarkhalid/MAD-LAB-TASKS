import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CirclePictureApp(),
    );
  }
}

class CirclePictureApp extends StatefulWidget {
  @override
  _CirclePictureAppState createState() => _CirclePictureAppState();
}

class _CirclePictureAppState extends State<CirclePictureApp> {
  int currentImageIndex = 0;
  List<String> images = [
    'assets/babar.jpg',
    'assets/rizwan.jpg',
    'assets/messi.jpg',
    'assets/williamson.jpg',
  ];

  double circlePositionX = 0.0;
  double circlePositionY = 0.0;

  @override
  void initState() {

    super.initState();
    _moveCircle();
  }

  void _moveCircle() {
    final random = Random();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        circlePositionX = random.nextDouble() * 300;
        circlePositionY = random.nextDouble() * 500;
      });
      _moveCircle();
    });
  }

  void _onCircleTap() {
    setState(() {
      currentImageIndex = (currentImageIndex + 1) % images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moving Circle '),
      ),
      body: Stack(
        children: [
          Positioned(
            top: circlePositionY,
            left: circlePositionX,
            child: GestureDetector(
              onTap: _onCircleTap,
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(images[currentImageIndex]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
