import 'dart:io';
import 'package:flutter_food_app/test.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../Model/serverCoursModel.dart';
import '../../utils/AppPreferences .dart';
import '../../utils/constants.dart';
import '../admin/adminPannel.dart';
import '../coursPDF/cours_pdf_handler.dart';
import 'profil.dart';

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  bool jsonUpdate = false;

  @override
  Widget build(BuildContext context) {
    // Met a jour le json une fois lors de l'arrivé sur la page home. SI on a internet !
    if (false) {
      if (!jsonUpdate) {
        updateJsonInventoryWithDbData();
        jsonUpdate = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            splittedProfileSection("Panneau administrateur",
                "Profil administrateur", Colors.red, Colors.grey, context),
            GestureDetector(
              onTap: () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Test()))
              },
              child: profileSection("Page de test", "", Colors.green),
            ),
            profileSection("Module d'apprentissage en cours", "", Colors.blue),
            adminSection,
          ],
        ),
      ),
    );
  }
}

// permet de mettre a jour les données liée au support de cours. (Met a jour le json sans mettre a jour les supports de cours.)
Future<void> updateJsonInventoryWithDbData() async {
// Récupération de la liste des cours côté serveurs
  final url = Uri.parse("$serverHttp$serverBaseUrl/Cours/ServerListCours");
  var responseListCours = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader:
          'Bearer ${AppPreferences().login_access_token}',
    },
  );

  final serverListCours =
      ServerCoursModel.fromListJsonDecoded(responseListCours.body);

// Récupération de la liste des cours côté local (sur le téléphone de l'utilisateur)
  var localCours = await CoursPdfHandler.getJsonInventory();

// Si aucun cours est en local, pas besoin de comparaison.
  if (localCours.isEmpty) {
    for (var i = 0; i < serverListCours.length; i++) {
      await CoursPdfHandler.addFileToJsonInventory(
          serverListCours[i].id,
          serverListCours[i].name,
          serverListCours[i].matiere,
          serverListCours[i].level,
          serverListCours[i].accessibility,
          serverListCours[i].freemiumAccess);
    }
  }
  // Si il y a déjà des cours en local, test la différence pour savoir quoi télécharger.
  else {
    // Test si les cours du serveur son présent sur le stockage local
    for (var i = 0; i < serverListCours.length; i++) {
      if (!localCours.any((element) => element.id == serverListCours[i].id)) {
        await CoursPdfHandler.addFileToJsonInventory(
            serverListCours[i].id,
            serverListCours[i].name,
            serverListCours[i].matiere,
            serverListCours[i].level,
            serverListCours[i].accessibility,
            serverListCours[i].freemiumAccess);
      }
    }
  }

  //TODO faire les tests pour le passage d'un abonné en freemium aussi quand le systeme sera mise en place
  // Vérifie que l'utilisateur n'a pas des supports de cours en local qui ont été supprimer du serveur
  // for (var i = 0; i < localCours.length; i++) {
  //   if (!serverListCours.any((element) => element.id == localCours[i].id)) {
  //     CoursPdfHandler.deleteFileToJsonInventory(localCours[i].id);
  //   }
  // }
}

Widget profileSection(String title, String description, MaterialColor color) =>
    Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color[300]!, color[100]!])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          Text(description),
        ],
      ),
    );

Widget splittedProfileSection(
        String titleLeft,
        String titleRight,
        MaterialColor colorLeft,
        MaterialColor colorRight,
        BuildContext context) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPannel(),
                  ))
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 5, 3, 5),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colorLeft[300]!, colorLeft[100]!])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    titleLeft,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
            child: GestureDetector(
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilPage(),
                          ))
                    },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(3, 5, 20, 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [colorRight[300]!, colorRight[100]!])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        titleRight,
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ))),
      ],
    );

Widget adminSection = Container();
