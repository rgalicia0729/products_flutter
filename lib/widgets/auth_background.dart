import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({
    Key? key, 
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: Stack(
        children: <Widget>[
          _PurpleBox(),
          _HeaderIcon(),
          this.child
        ],
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.4,
      width: size.width,
      decoration: _purpleBackground(),
      child: Stack(
        children: <Widget>[
          Positioned(child: _Bubble(), top: 90, left: 30),
          Positioned(child: _Bubble(), top: -40, left: -30),
          Positioned(child: _Bubble(), top: -50, right: -20),
          Positioned(child: _Bubble(), bottom: -50, left: 10),
          Positioned(child: _Bubble(), bottom: 120, right: 20)
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
    gradient: LinearGradient(
      colors: <Color> [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]
    )
  );
}

class _Bubble extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      decoration: _circularBubble(),
    );
  }

  BoxDecoration _circularBubble() => BoxDecoration(
    borderRadius: BorderRadius.circular(100.0),
    color: Color.fromRGBO(255, 255, 255, 0.05)
  );
}

class _HeaderIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        width: size.width,
        margin: EdgeInsets.only(top: 30.0),
        child: Icon(Icons.person_pin, color: Colors.white, size: 100.0),
      )
    );
  }
}