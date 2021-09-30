import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos/screens/screens.dart';
import 'package:productos/services/services.dart';
 
void main() => runApp(AppState());
 
class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService()),
        ChangeNotifierProvider(create: ( _ ) => ProductsService())
      ],
      child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos',
      initialRoute: 'check-auth',
      routes: <String, WidgetBuilder>{
        'check-auth': ( _ ) => CheckAuthScreen(),
        'login'     : ( _ ) => LoginScreen(),
        'register'  : ( _ ) => RegisterScreen(),
        'home'      : ( _ ) => HomeScreen(),
        'product'   : ( _ ) => ProductScreen()
      },
      scaffoldMessengerKey: NotificationService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          backgroundColor: Colors.indigo
        )
      ),
    );
  }
}