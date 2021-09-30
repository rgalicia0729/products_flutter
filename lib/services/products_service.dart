import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:productos/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseURL = 'flutter-varios-e1b16-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = false;
  bool isSaving = false;
  File? newPictureFile;

  ProductsService() {
    this.loadProducts();
  }

  loadProducts() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'products.json');
    final response = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(response.body);
    
    productsMap.forEach((key, value) { 
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;

      this.products.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await this.createProduct(product);
    } else {
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseURL, 'products/${product.id}.json');
    final response = await http.put(url, body: product.toJson());
    final updatedProduct = new Product.fromMap(json.decode(response.body));

    final index = products.indexWhere((element) => element.id == product.id);
    updatedProduct.id = product.id;
    products[index] = updatedProduct;

    return product.id!;
  }

  Future createProduct(Product product) async {
    final url = Uri.https(_baseURL, 'products.json');
    final response = await http.post(url, body: product.toJson());
    final decodedData = json.decode(response.body);

    product.id = decodedData['name'];
    this.products.add(product);
  }

  void updateSelectedProductImage( String path ) {
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  // Metodo para subir un archivo al servidor
  Future uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://url.image.com');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    print(response.body);
  }
}