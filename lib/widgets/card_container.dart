import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final Widget child;

  const CardContainer({
    Key? key, 
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        width: size.width,
        decoration: _createCardShape(),
        child: this.child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25.0),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15.0,
        offset: Offset(0, 5)
      )
    ]
  );
}