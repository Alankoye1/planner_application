class Excercise {
  final String id;
  final String excerciseTitle;
  final String excerciseImage;
  final String categoryId;
  final String videoUrl;
  bool? isFavorite;

  Excercise({
    required this.id,
    required this.excerciseTitle,
    required this.excerciseImage,
    required this.categoryId,
    required this.videoUrl,
    this.isFavorite,
  });

  // This is the fromJson method you need
  factory Excercise.fromJson(Map<String, dynamic> json) {
    return Excercise(
      id: json['id'] ?? '',
      excerciseTitle: json['excerciseTitle'] ?? '',
      excerciseImage: json['excerciseImage'] ?? '',
      categoryId: json['categoryId'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Optional: toJson method for saving to database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'excerciseTitle': excerciseTitle,
      'excerciseImage': excerciseImage,
      'categoryId': categoryId,
      'videoUrl': videoUrl,
      'isFavorite': isFavorite,
    };
  }
}
