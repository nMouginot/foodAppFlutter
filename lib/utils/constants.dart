import 'package:flutter/material.dart';

const String appName = 'ECL';
const String logoTag = 'const logo tag';
const String titleTag = 'const title';

/* Serveur local pour les tests et le développement. */
//  const String serverHttp = 'https://192.168.0.27:5000';
//  const String serverAutority = '192.168.0.27:5000';

/* Serveur de production de l'application. */
const String serverHttp = 'https://apischoolecl.azurewebsites.net';
const String serverAutority = 'apischoolecl.azurewebsites.net';

const String serverBaseUrl = '/api';

// Colors
const kSecondaryColor = Color(0xFF8B94BC);
const kGreenColor = Color(0xFF6AC259);
const kRedColor = Color(0xFFE92E30);
const kGrayColor = Color(0xFFC1C1C1);
const kBlackColor = Color(0xFF101010);
const kPrimaryGradient = LinearGradient(
  colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const double kDefaultPadding = 20.0;
