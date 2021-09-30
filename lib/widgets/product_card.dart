import 'package:flutter/material.dart';

import 'package:productos/models/models.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: EdgeInsets.only(top: 30.0, bottom: 50.0),
        width: double.infinity,
        height: 400.0,
        decoration: _productCardDecoration(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            _BackgroundImage(product.picture),
            _ProductDetails(
              title: product.name,
              subtitle: product.id!,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(product.price)
            ),

            if(!product.available)
              Positioned(
                top: 0,
                left: 0,
                child: _NotAvailable()
              )
          ],
        ),
      ),
    );
  }

  BoxDecoration _productCardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25.0),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10.0,
        offset: Offset(0.0, 7.0)
      )
    ]
  );
}

class _BackgroundImage extends StatelessWidget {

  final String? image;

  const _BackgroundImage(this.image);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: Container(
        width: size.width,
        height: size.height,
        child: image == null
          ? Image(
              image: AssetImage('assets/no-image.png'),
              fit: BoxFit.cover,
            )
          : FadeInImage(
              placeholder: AssetImage('assets/jar-loading.gif'), 
              image: NetworkImage(image!),
              fit: BoxFit.cover,
            ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ProductDetails({
    required this.title, 
    required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(right: 50.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        width: size.width,
        height: size.height * 0.07,
        decoration: _productDetailsDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle( fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: TextStyle( fontSize: 15.0, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _productDetailsDecoration() => BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))
  );
}

class _PriceTag extends StatelessWidget {
  final double price;

  const _PriceTag(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 70.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            '\$$price',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'No disponible',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}