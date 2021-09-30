import 'package:flutter/material.dart';
import 'package:productos/providers/login_form_provider.dart';
import 'package:productos/services/services.dart';
import 'package:provider/provider.dart';

import 'package:productos/ui/input_decorations.dart';
import 'package:productos/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.25),
              CardContainer(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Text('Register', style: Theme.of(context).textTheme.headline4),
                    SizedBox(height: 30.0),
                    
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm()
                    )

                  ],
                ),
              ),
              SizedBox(height: 50.0),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())
                ), 
                child: Text('¿Ya tienes una cuenta?', style: TextStyle(fontSize: 15.0, color: Colors.black87))
              ),
              SizedBox(height: 50.0)
            ],
          ),
        )
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginFormProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: <Widget>[

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: (value) => loginFormProvider.email = value,
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El correo ingresado no es valido';
              },
            ),

            SizedBox(height: 30.0),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: (value) => loginFormProvider.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe de ser mayor o igual a 6';
              },
            ),

            SizedBox(height: 30.0),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Text(
                  loginFormProvider.isLoading
                    ? 'Espere...'
                    : 'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: loginFormProvider.isLoading ? null : () async {
                // Quitar el teclado
                FocusScope.of(context).unfocus();

                if (loginFormProvider.isValidForm()) {
                  loginFormProvider.isLoading = true;

                  final authService = Provider.of<AuthService>(context, listen: false);
                  final error = await authService.createUser(email: loginFormProvider.email, password: loginFormProvider.password);

                  if (error == null) {
                    Navigator.pushReplacementNamed(context, 'home');
                  } else {
                    // TODO: Mostrar el error al usuario
                    print(error);
                    loginFormProvider.isLoading = false;
                  }
                }
              }
            )

          ],
        )
      ),
    );
  }
}