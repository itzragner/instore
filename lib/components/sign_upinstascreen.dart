import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instore/components/login_instascreen.dart';

import '../components/controllers/Auth_controller.dart';

class SignUpInstaScreen extends StatefulWidget {
  const SignUpInstaScreen({super.key});

  @override
  _SignUpInstaScreenState createState() => _SignUpInstaScreenState();
}

class _SignUpInstaScreenState extends State<SignUpInstaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final TextEditingController _nomInstagrammeurController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numeroTelephoneController =
      TextEditingController();
  final TextEditingController _matriculeFiscaleController =
      TextEditingController();
  final TextEditingController _lienInstagramController =
      TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _confirmMotDePasseController =
      TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();

  bool _companyUnderConstruction = false;
  final AuthController _signUpController = AuthController();
  late File _image;

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      obscureConfirmPassword = !obscureConfirmPassword;
    });
  }

  void resetFields() {
    _nomInstagrammeurController.clear();
    _emailController.clear();
    _numeroTelephoneController.clear();
    _matriculeFiscaleController.clear();
    _lienInstagramController.clear();
    _motDePasseController.clear();
    _confirmMotDePasseController.clear();
    _streetController.clear();
    _cityController.clear();
    _postCodeController.clear();
    _cinController.clear();
    _companyNameController.clear();
    setState(() {
      _companyUnderConstruction = false;
    });
  }

  Future<void> _selectAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {}
  }

  Future<void> _registerAccountWithImage() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> payload = {
        "name": _nomInstagrammeurController.text,
        "phone": _numeroTelephoneController.text,
        "email": _emailController.text,
        "password": _motDePasseController.text,
        "role": 'provider-intern',
        "acountLink": _lienInstagramController.text,
        "street": _streetController.text,
        "city": _cityController.text,
        "post_code": _postCodeController.text,
        "CIN": _cinController.text,
        "taxNumber": _matriculeFiscaleController.text,
        "companyName": _companyNameController.text,
        "companyUnderConstruction": _companyUnderConstruction ? 1 : 0,
      };
      _signUpController
          .registerAccountWithJson(payload, _image)
          .then((response) {
        Get.snackbar("success", "register with success",
            colorText: Colors.green[600]);
        Get.to(LoginInstaScreen());
      }).catchError((error) {
        print('Erreur lors de la création du compte: $error');
      });
    } else {
      Get.snackbar("warn !",
          "Impossible de créer le compte. Veuillez remplir tous les champs.",
          colorText: Colors.red[600]);
      print('Erreur: ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Créer un compte',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () {
              _selectAndUploadImage();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.0),
              CustomTextField(
                controller: _nomInstagrammeurController,
                labelText: 'Nom Instagrammeur',
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _numeroTelephoneController,
                labelText: 'Numéro de téléphone',
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _cinController,
                labelText: 'CIN',
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre CIN';
                  }
                  if (value.length < 8) {
                    return 'Le CIN doit avoir au moins 8 chiffres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre adresse email';
                  }
                  if (!RegExp(
                          r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                      .hasMatch(value)) {
                    return 'Veuillez entrer une adresse email valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _streetController,
                labelText: 'Adresse',
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _cityController,
                labelText: 'Ville',
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _postCodeController,
                labelText: 'Code Postale',
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre code postale';
                  }
                  if (value.length < 4) {
                    return 'Le code postale doit avoir au moins 4 chiffres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _lienInstagramController,
                labelText: 'Lien du compte Instagram',
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _companyNameController,
                labelText: 'Nom de l\'entreprise',
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    'L\'entreprise est en construction?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Checkbox(
                    value: _companyUnderConstruction,
                    onChanged: (value) {
                      setState(() {
                        _companyUnderConstruction = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _motDePasseController,
                labelText: 'Mot de passe',
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  onPressed: togglePasswordVisibility,
                  icon: Icon(obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit avoir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              CustomTextField(
                controller: _confirmMotDePasseController,
                labelText: 'Confirmer le mot de passe',
                obscureText: obscureConfirmPassword,
                suffixIcon: IconButton(
                  onPressed: toggleConfirmPasswordVisibility,
                  icon: Icon(obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  if (value != _motDePasseController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  _registerAccountWithImage();
                },
                child: Text('Créer le compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        suffixIcon: widget.suffixIcon,
        errorStyle: TextStyle(color: Colors.red),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: widget.validator,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpInstaScreen(),
  ));
}
