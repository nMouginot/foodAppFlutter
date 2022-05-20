// ignore_for_file: file_names

class QuizFilters {
  bool isTraining;
  bool isGraded;
  String? matiere; // Si la matière est null, affiche toutes les matières.
  String? level; // Si le niveau est null, affiche tout les niveaux.
  String?
      name; // Si name est null, affiche tout les quiz peut importe leurs nom.
  int?
      numberOfQuestions; // Si le nombre de questions est null, affiche tout les quizs peut importe leurs nombre de questions.
  int?
      timer; // Si timer est null, affiche tout les quiz peut import le delai entre les questions.

  QuizFilters({
    this.isTraining = true,
    this.isGraded = true,
    this.level,
    this.matiere,
    this.name,
    this.numberOfQuestions,
    this.timer,
  });
}
