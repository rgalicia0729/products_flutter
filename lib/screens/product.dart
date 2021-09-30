import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:productos/providers/providers.dart';
import 'package:productos/services/products_service.dart';
import 'package:productos/widgets/widgets.dart';
import 'package:productos/ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider(productsService.selectedProduct),
      child: _ProductScreenBody(productsService: productsService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ProductImage(
                  imageURL: productsService.selectedProduct.picture,
                ),
                Positioned(
                  top: 60.0,
                  left: 20.0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, size: 40.0, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ),
                Positioned(
                  top: 60.0,
                  right: 20.0,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt_outlined, size: 40.0, color: Colors.white),
                    onPressed: () async {
                      final picker = new ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

                      // Utilizar la camara para tomar una foto
                      // final XFile? pickedFile = await picker.pickImage(source: ImageSource.camara);

                      if (pickedFile == null) {
                        print('No selecciono nada');
                        return;
                      }

                      productsService.updateSelectedProductImage(pickedFile.path);
                    },
                  ),
                )
              ],
            ),

            _ProductForm(),

            SizedBox(height: 100.0)
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_outlined),
        onPressed: () async {
          if (!productFormProvider.isValidForm()) return;
          
          await productsService.saveOrCreateProduct(productFormProvider.product);
        },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    final product = productFormProvider.product;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        width: size.width,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productFormProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre del producto es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Nombre del producto'
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  double.tryParse(value) == null 
                    ? product.price = 0 
                    : product.price = double.parse(value);
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  labelText: 'Precio',
                  hintText: '\$150'
                ),
              ),
              SizedBox(height: 30.0),
              SwitchListTile.adaptive(
                value: product.available,
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productFormProvider.updateAvailability,
              ),
              SizedBox(height: 30.0)
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))
  );
}