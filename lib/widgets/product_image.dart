import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? imageURL;

  const ProductImage({
    Key? key, 
    this.imageURL
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Container(
        width: size.width,
        height: size.height * 0.45,
        decoration: _buildBoxDecoration(),
        child: Opacity(
          opacity: 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0), topRight: Radius.circular(45.0)),
            child: _getImageProduct(this.imageURL) 
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0), topRight: Radius.circular(45.0)),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10.0,
        offset: Offset(0,5)
      )
    ]
  );

  Widget _getImageProduct(String? imagen) {
    if (imagen == null)
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover
      );
    
    if (imagen.startsWith('http'))
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'), 
        image: NetworkImage(imagen),
        fit: BoxFit.cover,
      );
    
    return Image.file(
      File(imagen),
      fit: BoxFit.cover
    );
  }
}