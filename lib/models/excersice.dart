
class Excercise {
  final String id;
  final String excerciseTitle;
  final String excerciseImage;
  final String categoryId;

  Excercise({
    required this.id,
    required this.excerciseTitle,
    required this.excerciseImage,
    required this.categoryId,
  });

  // Excercise findById(String id) {
  //   return excercises.firstWhere((element) => element.id == id);
  // }
}

