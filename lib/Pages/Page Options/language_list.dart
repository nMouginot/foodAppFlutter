import 'package:flutter/material.dart';
import 'package:flutter_food_app/Mock%20Data/Langue.dart';

class LanguageList extends StatefulWidget {
  const LanguageList({Key? key}) : super(key: key);

  @override
  _LanguageListState createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  final List<Langues> _langues = sample_data_langues
      .map(
          (json) => Langues(value: json['langues'], selected: json['selected']))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Options")),
        body: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _langues.length,
            itemBuilder: (context, index) {
              return (_langues[index].selected)
                  ? Card(
                      child: ListTile(
                          title: Text(_langues[index].value),
                          trailing: const Icon(Icons.check)))
                  : Card(
                      child: ListTile(
                      title: Text(_langues[index].value),
                      onTap: () {
                        Navigator.of(context).pop();
                        // TODO : Changer la langue en fonction de celle qui a été nouvellement selectionné. (Stockage local json fichier "settings.json", parametre : selectedLanguage.)
                      },
                    ));
            }));
  }
}

void updateTheQnNum(int index) {
  if (true) {}
}
