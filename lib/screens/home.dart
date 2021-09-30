import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos/models/models.dart';
import 'package:productos/screens/screens.dart';
import 'package:productos/services/services.dart';
import 'package:productos/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final products = productsService.products;

    final authService = Provider.of<AuthService>(context, listen: false);

    if (productsService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: ( _ , int index) => GestureDetector(
          onTap: () {
            productsService.selectedProduct = products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(product: products[index])
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          productsService.selectedProduct = new Product(
            available: false, 
            name: '', 
            price: 0.0
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}