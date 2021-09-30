import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseURL = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCpuMS9qrUC1FwrfLwo6t_d5XqtfN4GMns';

  final FlutterSecureStorage storage = new FlutterSecureStorage();

  // Si retornamos algo hay un error
  Future<String?> createUser({required String email, required String password}) async  {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseURL, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData.containsKey('idToken')) {
      // Se guarda el idToken en un lugar seguro del dispositivo
      await storage.write(key: 'idToken', value: decodedData['idToken']);

      return null;
    } else {
      return decodedData['error']['message'];
    }
  }

  // Si retornamos algo hay un error
  Future<String?> login({required String email, required String password}) async  {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseURL, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData.containsKey('idToken')) {
      // Se guarda el idToken en un lugar seguro del dispositivo
      await storage.write(key: 'idToken', value: decodedData['idToken']);

      return null;
    } else {
      return decodedData['error']['message'];
    }
  }

  // Cerrar sesion
  Future logout() async {
    await storage.delete(key: 'idToken');
  }

  // Check auth
  Future<String> checkAuth() async {
    return await storage.read(key: 'idToken') ?? '';
  }
}