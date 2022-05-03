// ignore_for_file: file_names
import 'Quiz.dart';

class LearningModule {
  final int id;
  final String name;
  String niveau = "";
  String matiere = "";
  late List<Quiz> _trainingQuiz;
  late List<int> _gradedQuiz;

  LearningModule({required this.id, required this.name});

  bool addNewTrainingQuiz(Quiz quizToAdd) {
    if (!_trainingQuiz.contains(quizToAdd)) {
      _trainingQuiz.add(quizToAdd);
      return true;
    }
    return false;
  }

  bool addNewGradedQuiz(int idQuizToAdd) {
    if (!_gradedQuiz.contains(idQuizToAdd)) {
      _gradedQuiz.add(idQuizToAdd);
      // TODO Tester si il a internet, si il ne l'a pas, fonctionne pas.
      // TODO faire un appel api pour modifier le module en bdd.
      return true;
    }
    return false;
  }

  bool deleteNewTrainingQuiz(Quiz quizToDelete) {
    if (_trainingQuiz.contains(quizToDelete)) {
      _trainingQuiz.remove(quizToDelete);
      return true;
    }
    return false;
  }

  bool deleteNewGradedQuiz(int idQuizToDelete) {
    if (!_gradedQuiz.contains(idQuizToDelete)) {
      _gradedQuiz.remove(idQuizToDelete);
      // TODO Tester si il a internet, si il ne l'a pas, fonctionne pas.
      // TODO faire un appel api pour modifier le module en bdd.
      return true;
    }
    return false;
  }
}
