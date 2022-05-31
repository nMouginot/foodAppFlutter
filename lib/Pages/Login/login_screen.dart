import 'dart:convert';
import 'dart:io';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Pages/Page%20Home/main_home.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;

import '../../Model/connexionTokenModel.dart';
import '../../utils/AppPreferences .dart';
import '../../utils/constants.dart';
import '../../utils/internetCheck.dart';
import '../Page Home/app_home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/auth';

  Future<String?> _loginUser(LoginData data) async {
// TODO a retirer plus tard, connexion en dur car le serveur est K.O
    if (data.name == "test@test.fr" && data.password == "Test@12") {
      return null;
    }

    // Si internet n'est pas disponible, check les données de session locals.
    if (!await InternetCheck.checkInternet()) {
      // Comparaison avec l'email et le password utilisé par le dernier compte connecté
      if (data.name == AppPreferences().userEmail &&
          Crypt(AppPreferences().userPasswordHash).match(data.password)) {
        return null;
      }

      return "Email ou mdp invalide.";
    }

// Si internet est disponible, ce connecte normalement et met a jour les données de session.

// Requete au serveur pour le login
    final url = Uri.parse("$serverHttp/connect/token");
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {
      'grant_type': 'password',
      'username': data.name,
      'password': data.password,
      'scope': 'offline_access'
    };

    var response = await http.post(
      url,
      headers: headers,
      encoding: Encoding.getByName('utf-8'),
      body: body,
    );

// Traitement de la réponse.
    if (response.statusCode == 200) {
// Sauvegardes des données local de session (email & password)
      AppPreferences().userEmail = data.name;
      AppPreferences().userPasswordHash =
          Crypt.sha512(data.password).toString();

// Sauvgarde des données de connexion (Token)
      final connexionData = ConnexionTokenModel.fromJsonDecoded(response.body);
      AppPreferences().login_access_token = connexionData.access_token;
      AppPreferences().login_refresh_token = connexionData.refresh_token;

// Sauvgarde des données de rôle
      final url = Uri.parse("$serverHttp$serverBaseUrl/role");
      var responseRole = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${connexionData.access_token}',
        },
      );

      if (responseRole.statusCode == 200) {
        AppPreferences().userRole = responseRole.body.toLowerCase();
      }

      if (responseRole.statusCode == 400) {
        AppPreferences().userRole = "none";
      }
      return null;
    }

    if (response.statusCode != 200) {
      return "Email ou mdp invalide.";
    }
    return "Auto-reconnexion invalide.";
  }

  Future<String?> _signupUser(SignupData data) async {
    final url = Uri.parse("$serverHttp$serverBaseUrl/user/register");
    final headers = {'Content-Type': 'application/json'};
    final body = {'Email': data.name, 'Password': data.password};
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      AppPreferences().userEmail = data.name ?? "";
      AppPreferences().userPasswordHash =
          Crypt.sha512(data.password ?? "").toString();
      return null;
    }

    if (response.statusCode == 409) {
      return "Email déjà utilisé.";
    }

    if (response.statusCode != 200) {
      return "Erreur de connexion.";
    }
    return null;
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(const Duration(seconds: 1)).then((_) {
      return null;
    });
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(const Duration(seconds: 1)).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Auto reconexion, défini par une variable en json dans le fichier "generalSettings.json" Les valeurs aussi sont stocker dans ce fichier.
    if (false) {
      _loginUser(LoginData(name: "", password: ""));
    }

    return FlutterLogin(
      title: appName,
      logo: const AssetImage('assets/images/logoECL.png'),
      logoTag: logoTag,
      titleTag: titleTag,
      navigateBackAfterRecovery: true,
      onConfirmRecover: _signupConfirm,
      loginAfterSignUp: true,
      hideForgotPasswordButton:
          true, // TODO : Potentiellement a changer plus tard avec une gestion d'email pour récupérer le mot de passe.
      termsOfService: [
        TermOfService(
            id: 'general-term',
            mandatory: true,
            text: 'Term of services',
            linkUrl: ''),
      ],
      initialAuthMode: AuthMode.login,

      // Validator
      userValidator: (value) {
        if (!value!.contains('@')) {
          return "L'email doit contenir le caractère '@'";
        }
        if (!value.contains('.')) {
          return "L'email doit contenir le caractère '.'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Le champ mot de passe est vide';
        }
        if (value.length < 7) {
          return 'Le mdp doit faire plus de 7 caractères';
        }
        if (!value.contains(RegExp(r'[A-Z]'))) {
          return 'Le mdp doit contenir une majuscule (A-Z)';
        }
        if (!value.contains(RegExp(r'[a-z]'))) {
          return 'Le mdp doit contenir une minuscule (a-z)';
        }
        if (!value.contains(RegExp(r'[0-9]'))) {
          return 'Le mdp doit contenir au moins un chiffre';
        }
        if (!value.contains(RegExp(r'[.*?[!@#${}&*~\\]'))) {
          return 'Le mdp doit contenir un caractère spécial';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        return _loginUser(loginData);
      },

      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Name: ${signupData.name}');
        debugPrint('Password: ${signupData.password}');

        if (signupData.termsOfService.isNotEmpty) {
          debugPrint('Terms of service: ');
          for (var element in signupData.termsOfService) {
            debugPrint(
                ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}');
          }
        }
        return _signupUser(signupData);
      },

      onSubmitAnimationCompleted: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainHome()));
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: false,
    );
  }
}
