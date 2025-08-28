import 'package:planner/models/category.dart';
import 'package:planner/models/excersice.dart';

final List<Excercise> allExercises = [
  Excercise(
    id: 'e1',
    excerciseTitle: 'Plank',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c1',
    videoUrl: 'https://www.youtube.com/watch?v=pSHjTRCQxIw',
  ),
  Excercise(
    id: 'e2',
    excerciseTitle: 'Push Ups',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c1',
    videoUrl: 'https://www.youtube.com/watch?v=_l3ySVKYVJ8',
  ),
  Excercise(
    id: 'e3',
    excerciseTitle: 'Chest Dips',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c1',
    videoUrl: 'https://www.youtube.com/watch?v=2z8JmcrW-As',
  ),
  Excercise(
    id: 'e4',
    excerciseTitle: 'Incline Push Ups',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c1',
    videoUrl: 'https://www.youtube.com/watch?v=E9LVk3kBUd8',
  ),

  // Back exercises
  Excercise(
    id: 'e5',
    excerciseTitle: 'Pull Ups',
    excerciseImage: 'assets/images/lat.jpg',
    categoryId: 'c2',
    videoUrl: 'https://www.youtube.com/watch?v=eGo4IYlbE5g',
  ),
  Excercise(
    id: 'e6',
    excerciseTitle: 'Superman',
    excerciseImage: 'assets/images/lat.jpg',
    categoryId: 'c2',
    videoUrl: 'https://www.youtube.com/watch?v=z6PJMT2y8GQ',
  ),
  Excercise(
    id: 'e7',
    excerciseTitle: 'Lat Pulldowns',
    excerciseImage: 'assets/images/lat.jpg',
    categoryId: 'c2',
    videoUrl: 'https://www.youtube.com/watch?v=CAwf7n6Luuc',
  ),

  // Leg exercises
  Excercise(
    id: 'e8',
    excerciseTitle: 'Squats',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c3',
    videoUrl: 'https://www.youtube.com/watch?v=aclHkVaku9U',
  ),
  Excercise(
    id: 'e9',
    excerciseTitle: 'Lunges',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c3',
    videoUrl: 'https://www.youtube.com/watch?v=QOVaHwm-Q6U',
  ),
  // Shoulder exercises
  Excercise(
    id: 'e12',
    excerciseTitle: 'Shoulder Press',
    excerciseImage: 'assets/images/shoulder.jpg',
    categoryId: 'c4',
    videoUrl: 'https://www.youtube.com/watch?v=B-aVuyhvLHU',
  ),
  Excercise(
    id: 'e13',
    excerciseTitle: 'Lateral Raises',
    excerciseImage: 'assets/images/shoulder.jpg',
    categoryId: 'c4',
    videoUrl: 'https://www.youtube.com/watch?v=3VcKaXpzqRo',
  ),
  Excercise(
    id: 'e14',
    excerciseTitle: 'Front Raises',
    excerciseImage: 'assets/images/shoulder.jpg',
    categoryId: 'c4',
    videoUrl: 'https://www.youtube.com/watch?v=-t7fuZ0KhDA',
  ),

  // Triceps exercises
  Excercise(
    id: 'e15',
    excerciseTitle: 'Tricep Dips',
    excerciseImage: 'assets/images/triceps.jpg',
    categoryId: 'c5',
    videoUrl: 'https://www.youtube.com/watch?v=0326dy_-CzM',
  ),
  Excercise(
    id: 'e16',
    excerciseTitle: 'Diamond Push Ups',
    excerciseImage: 'assets/images/triceps.jpg',
    categoryId: 'c5',
    videoUrl: 'https://www.youtube.com/watch?v=J0DnG1_S92I',
  ),
  Excercise(
    id: 'e17',
    excerciseTitle: 'Overhead Extension',
    excerciseImage: 'assets/images/triceps.jpg',
    categoryId: 'c5',
    videoUrl: 'https://www.youtube.com/watch?v=YbX7Wd8jQ-Q',
  ),

  // Abs exercises
  Excercise(
    id: 'e18',
    excerciseTitle: 'Crunches',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c6',
    videoUrl: 'https://www.youtube.com/watch?v=Xyd_fa5zoEU',
  ),
  Excercise(
    id: 'e19',
    excerciseTitle: 'Mountain Climbers',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c6',
    videoUrl: 'https://www.youtube.com/watch?v=nmwgirgXLYM',
  ),
  Excercise(
    id: 'e20',
    excerciseTitle: 'Russian Twists',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c6',
    videoUrl: 'https://www.youtube.com/watch?v=wkD8rjkodUI',
  ),
  Excercise(
    id: 'e21',
    excerciseTitle: 'Bicycle Crunches',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c6',
    videoUrl: 'https://www.youtube.com/watch?v=9FGilxCbdz8',
  ),
  Excercise(
    id: 'e22',
    excerciseTitle: 'Plank',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c6',
    videoUrl: 'https://www.youtube.com/watch?v=pSHjTRCQxIw',
  ),
  Excercise(
    id: 'e23',
    excerciseTitle: 'Dead Bug',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c6',
    videoUrl: 'https://www.youtube.com/watch?v=4pLRM2V-MQ0',
  ),
  Excercise(
    id: 'e24',
    excerciseTitle: 'Leg Raises',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c6',
    videoUrl: 'https://www.youtube.com/watch?v=JB2oyawG9KI',
  ),

  // Biceps exercises
  Excercise(
    id: 'e25',
    excerciseTitle: 'Bicep Curls',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c7',
    videoUrl: 'https://www.youtube.com/watch?v=ykJmrZ5v0Oo',
  ),
  Excercise(
    id: 'e26',
    excerciseTitle: 'Hammer Curls',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c7',
    videoUrl: 'https://www.youtube.com/watch?v=zC3nLlEvin4',
  ),
  Excercise(
    id: 'e27',
    excerciseTitle: 'Chin Ups',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c7',
    videoUrl: 'https://www.youtube.com/watch?v=b-ztMQpj8yc',
  ),
  Excercise(
    id: 'e28',
    excerciseTitle: 'Preacher Curls',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c7',
    videoUrl: 'https://www.youtube.com/watch?v=2K-o5dQG0w4',
  ),

  // Cardio exercises
  Excercise(
    id: 'e29',
    excerciseTitle: 'Jumping Jacks',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c8',
    videoUrl: 'https://www.youtube.com/watch?v=c4DAnQ6DtF8',
  ),
  Excercise(
    id: 'e30',
    excerciseTitle: 'Burpees',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c8',
    videoUrl: 'https://www.youtube.com/watch?v=TU8QYVW0gDU',
  ),
  Excercise(
    id: 'e31',
    excerciseTitle: 'High Knees',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c8',
    videoUrl: 'https://www.youtube.com/watch?v=OAJ_J3EZkdY',
  ),
  Excercise(
    id: 'e32',
    excerciseTitle: 'Jump Rope',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c8',
    videoUrl: 'https://www.youtube.com/watch?v=1BZMwQ6yC6o',
  ),
  Excercise(
    id: 'e33',
    excerciseTitle: 'Running in Place',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c8',
    videoUrl: 'https://www.youtube.com/watch?v=QW4l8Io6zAk',
  ),
  Excercise(
    id: 'e34',
    excerciseTitle: 'Box Jumps',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c8',
    videoUrl: 'https://www.youtube.com/watch?v=52r_Ul5kq2c',
  ),

  // Full Body exercises
  Excercise(
    id: 'e35',
    excerciseTitle: 'Deadlifts',
    excerciseImage: 'assets/images/lat.jpg',
    categoryId: 'c9',
  videoUrl: 'https://www.youtube.com/watch?v=op9kVnSso6Q',
  ),
  Excercise(
    id: 'e36',
    excerciseTitle: 'Clean and Press',
    excerciseImage: 'assets/images/shoulder.jpg',
    categoryId: 'c9',
  videoUrl: 'https://www.youtube.com/watch?v=35n4C1EoYwI',
  ),
  Excercise(
    id: 'e37',
    excerciseTitle: 'Turkish Get-ups',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c9',
  videoUrl: 'https://www.youtube.com/watch?v=0vhJza-2xiI',
  ),
  Excercise(
    id: 'e38',
    excerciseTitle: 'Man Makers',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c9',
  videoUrl: 'https://www.youtube.com/watch?v=4tYJmQmZ-h0',
  ),
  Excercise(
    id: 'e39',
    excerciseTitle: 'Thrusters',
    excerciseImage: 'assets/images/shoulder.jpg',
    categoryId: 'c9',
  videoUrl: 'https://www.youtube.com/watch?v=2SHsk9AzdjA',
  ),

  // Yoga/Stretching exercises
  Excercise(
    id: 'e40',
    excerciseTitle: 'Downward Dog',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c10',
  videoUrl: 'https://www.youtube.com/watch?v=EC7RGJ3c8w8',
  ),
  Excercise(
    id: 'e41',
    excerciseTitle: 'Warrior Pose',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c10',
  videoUrl: 'https://www.youtube.com/watch?v=U9dAnYt81Vw',
  ),
  Excercise(
    id: 'e42',
    excerciseTitle: 'Child Pose',
    excerciseImage: 'assets/images/abs.jpg',
    categoryId: 'c10',
  videoUrl: 'https://www.youtube.com/watch?v=ZC3wL4mNQz0',
  ),
  Excercise(
    id: 'e43',
    excerciseTitle: 'Cat Cow Stretch',
    excerciseImage: 'assets/images/lat.jpg',
    categoryId: 'c10',
  videoUrl: 'https://www.youtube.com/watch?v=kqnua4rHVVA',
  ),
  Excercise(
    id: 'e44',
    excerciseTitle: 'Cobra Pose',
    excerciseImage: 'assets/images/lat.jpg',
    categoryId: 'c10',
  videoUrl: 'https://www.youtube.com/watch?v=JDcdhTuycOI',
  ),

  // Glutes exercises
  Excercise(
    id: 'e45',
    excerciseTitle: 'Glute Bridges',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c11',
  videoUrl: 'https://www.youtube.com/watch?v=8bbE64NuDTU',
  ),
  Excercise(
    id: 'e46',
    excerciseTitle: 'Hip Thrusts',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c11',
  videoUrl: 'https://www.youtube.com/watch?v=SEdqd1n0cvg',
  ),
  Excercise(
    id: 'e47',
    excerciseTitle: 'Clamshells',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c11',
  videoUrl: 'https://www.youtube.com/watch?v=FxHqHBO1C-4',
  ),
  Excercise(
    id: 'e48',
    excerciseTitle: 'Fire Hydrants',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c11',
  videoUrl: 'https://www.youtube.com/watch?v=J4hHyhK0-l8',
  ),

  // HIIT exercises
  Excercise(
    id: 'e49',
    excerciseTitle: 'Tabata Squats',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c12',
  videoUrl: 'https://www.youtube.com/watch?v=aclHkVaku9U',
  ),
  Excercise(
    id: 'e50',
    excerciseTitle: 'Sprint Intervals',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c12',
  videoUrl: 'https://www.youtube.com/watch?v=ZpdELZQ2l4s',
  ),
  Excercise(
    id: 'e51',
    excerciseTitle: 'Battle Ropes',
    excerciseImage: 'assets/images/shoulder.jpg',
    categoryId: 'c12',
  videoUrl: 'https://www.youtube.com/watch?v=6JtP6ju0IMw',
  ),
  Excercise(
    id: 'e52',
    excerciseTitle: 'Kettlebell Swings',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c12',
  videoUrl: 'https://www.youtube.com/watch?v=YSxHifyI1JY',
  ),

  // Forearms exercises
  Excercise(
    id: 'e53',
    excerciseTitle: 'Wrist Curls',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c13',
  videoUrl: 'https://www.youtube.com/watch?v=Oq6bFi3qJ2g',
  ),
  Excercise(
    id: 'e54',
    excerciseTitle: 'Farmer Walks',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c13',
  videoUrl: 'https://www.youtube.com/watch?v=1c1FSn4d0do',
  ),
  Excercise(
    id: 'e55',
    excerciseTitle: 'Grip Squeezes',
    excerciseImage: 'assets/images/chest.jpg',
    categoryId: 'c13',
  videoUrl: 'https://www.youtube.com/watch?v=Y0mqsMgvjIc',
  ),

  // Calves exercises
  Excercise(
    id: 'e56',
    excerciseTitle: 'Standing Calf Raises',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c14',
  videoUrl: 'https://www.youtube.com/watch?v=YMmgqO8Jo-k',
  ),
  Excercise(
    id: 'e57',
    excerciseTitle: 'Seated Calf Raises',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c14',
  videoUrl: 'https://www.youtube.com/watch?v=YuxGzdr1V10',
  ),
  Excercise(
    id: 'e58',
    excerciseTitle: 'Jump Calf Raises',
    excerciseImage: 'assets/images/leg.jpg',
    categoryId: 'c14',
  videoUrl: 'https://www.youtube.com/watch?v=DNrwOx8sZJM',
  ),
];

final List<Category> categories = [
  Category(
    id: 'c1',
    categoryTitle: 'Chest',
    categoryImage: 'assets/images/chest.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c1')
        .toList(),
  ),
  Category(
    id: 'c2',
    categoryTitle: 'Back',
    categoryImage: 'assets/images/lat.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c2')
        .toList(),
  ),
  Category(
    id: 'c3',
    categoryTitle: 'Legs',
    categoryImage: 'assets/images/leg.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c3')
        .toList(),
  ),
  Category(
    id: 'c4',
    categoryTitle: 'Shoulders',
    categoryImage: 'assets/images/shoulder.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c4')
        .toList(),
  ),
  Category(
    id: 'c5',
    categoryTitle: 'Triceps',
    categoryImage: 'assets/images/triceps.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c5')
        .toList(),
  ),
  Category(
    id: 'c6',
    categoryTitle: 'Abs',
    categoryImage: 'assets/images/abs.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c6')
        .toList(),
  ),
  Category(
    id: 'c7',
    categoryTitle: 'Biceps',
    categoryImage: 'assets/images/chest.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c7')
        .toList(),
  ),
  Category(
    id: 'c8',
    categoryTitle: 'Cardio',
    categoryImage: 'assets/images/leg.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c8')
        .toList(),
  ),
  Category(
    id: 'c9',
    categoryTitle: 'Full Body',
    categoryImage: 'assets/images/chest.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c9')
        .toList(),
  ),
  Category(
    id: 'c10',
    categoryTitle: 'Yoga/Stretching',
    categoryImage: 'assets/images/abs.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c10')
        .toList(),
  ),
  Category(
    id: 'c11',
    categoryTitle: 'Glutes',
    categoryImage: 'assets/images/leg.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c11')
        .toList(),
  ),
  Category(
    id: 'c12',
    categoryTitle: 'HIIT',
    categoryImage: 'assets/images/leg.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c12')
        .toList(),
  ),
  Category(
    id: 'c13',
    categoryTitle: 'Forearms',
    categoryImage: 'assets/images/chest.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c13')
        .toList(),
  ),
  Category(
    id: 'c14',
    categoryTitle: 'Calves',
    categoryImage: 'assets/images/leg.jpg',
    excercises: allExercises
        .where((exercise) => exercise.categoryId == 'c14')
        .toList(),
  ),
];

final Map<String, List<Excercise>> scheduledExercises = {
  'Monday': [
    allExercises[0], // Plank
    allExercises[1], // Push Ups
    allExercises[4], // Pull Ups
  ],
  'Tuesday': [
    allExercises[8], // Squats (assuming it exists)
    allExercises[9], // Lunges (assuming it exists)
  ],
  'Wednesday': [
    allExercises[2], // Chest Dips
    allExercises[5], // Superman
  ],
  'Thursday': [
    allExercises[0], // Plank
    allExercises[4], // Pull Ups
  ],
  'Friday': [
    allExercises[1], // Push Ups
    allExercises[3], // Incline Push Ups
  ],
  'Saturday': [
    allExercises[6], // Lat Pulldowns
  ],
  'Sunday': [], // Rest day
};

final Map<String, List<Excercise>> customExercises = {};
