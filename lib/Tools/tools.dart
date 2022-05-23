import 'dart:math';

/// classe qui contient plein de petites fonctions utiles.
class Tools {
  ///Génère un nombre aléatoire compris entre [min](inclusif) et [max](exclusif).
  static int randomNumber(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}
