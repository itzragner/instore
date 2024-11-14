import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:instore/components/home_screen.dart';
import 'package:instore/services/auth.dart';
import 'package:instore/services/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  var obscurePassword = true.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isEmailValid = true.obs;
  var isPasswordValid = true.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  void validateEmail(String email) {
    isEmailValid.value = GetUtils.isEmail(email);
  }

  void validatePassword(String password) {
    isPasswordValid.value = password.isNotEmpty;
  }

  bool validateInputs() {
    validateEmail(emailController.text);
    validatePassword(passwordController.text);
    return isEmailValid.value && isPasswordValid.value;
  }

  _save(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future<void> registerAccountWithJson(
      Map<String, dynamic> jsonBody, File image) async {
    var url = Uri.parse('${baseURL}register');

    try {
      var request = http.MultipartRequest("POST", url);

      request.fields.addAll(jsonBody.map((key, value) =>
          MapEntry(key, value.toString()))); // Convert all values to strings

      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      print("responseString $responseString");
    } on SocketException catch (e) {
      print('Erreur de connexion: $e');
    } on HttpException catch (e) {
      print('Erreur HTTP: $e');
    } on FormatException catch (e) {
      print('Format de réponse invalide: $e');
    } catch (e) {
      print('Erreur inattendue: $e');
    }
  }

  Future<void> registerAccount({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String role,
    required String acountLink,
    required String street,
    required File image,
    required String city,
    required String postCode,
    required String CIN,
    required String taxNumber,
    required String companyName,
    required bool companyUnderConstruction,
  }) async {
    var url = Uri.parse('http://192.168.1.14:8000/api/register');
    print('URL: $url'); // Affichage de l'URL dans le terminal

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'role': 'provider-intern',
        'acountLink': acountLink,
        'street': street,
        'city': city,
        'post_code': postCode,
        'CIN': CIN,
        'TAXNumber': taxNumber,
        'companyName': companyName,
        'companyUnderConstruction': companyUnderConstruction.toString(),
      });

      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Partenaire enregistré avec succès!');
      } else {
        print(
            'Erreur lors de l\'enregistrement du instagrammeur: ${response.statusCode}');
        print('Message d\'erreur: ${await response.stream.bytesToString()}');
      }
    } on SocketException catch (e) {
      print('Erreur de connexion: $e');
    } on HttpException catch (e) {
      print('Erreur HTTP: $e');
    } on FormatException catch (e) {
      print('Format de réponse invalide: $e');
    } catch (e) {
      print('Erreur inattendue: $e');
    }
  }

  Future<void> loginUser() async {
    isLoading.value = true;

    final dynamic email = emailController.text.trim();
    final dynamic password = passwordController.text.trim();

    const String apiUrl = '${baseURL}login';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'email': email, 'password': password}),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map responseMap = jsonDecode(response.body);

        final responseStatus = responseMap['status'];
        if (responseStatus != 401) {
          String token = responseMap['token'];
          Map<String, dynamic> user = responseMap['user'];
          controller.setToken(token);
          _save(token, user);
          isLoading.value = false;
          errorMessage.value = '';
          Get.off(() => HomeView());
        } else {
          Get.snackbar("warn", "Your account is not active",
              backgroundColor: Colors.orange[300]);
        }
      } else {
        isLoading.value = false;
        Get.snackbar("error",
            "Identifiants incorrects. Veuillez réessayer. in with success",
            backgroundColor: Colors.red[300]);
        errorMessage.value = 'Identifiants incorrects. Veuillez réessayer.';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Une erreur s\'est produite. Veuillez réessayer.';
    }
  }
}
