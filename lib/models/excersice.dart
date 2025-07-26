class Excercise {
  final String id;
  final String excerciseTitle;
  final String excerciseImage;
  final String categoryId;
  bool? isFavorite;

  Excercise({
    required this.id,
    required this.excerciseTitle,
    required this.excerciseImage,
    required this.categoryId,
    this.isFavorite,
  });
}
