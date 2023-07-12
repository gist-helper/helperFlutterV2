import '../../common/const/types.dart';

class MealModel {
  late final String breakfast,
      breakfastCorner,
      lunch,
      lunchCorner,
      lunchBldg1_2,
      dinner;

  MealModel.fromJson(Map<String, dynamic> json)
      : breakfast = json['breakfast'],
        breakfastCorner = json['breakfast_corner'],
        lunch = json['lunch'],
        lunchCorner = json['lunch_corner'],
        lunchBldg1_2 = json['lunch_bldg1_2'],
        dinner = json['dinner'];

  MealModel(int langType) {
    if (langType == LANG_KOR) {
      breakfast = EMPTY_MEAL_KOR;
      lunch = EMPTY_MEAL_KOR;
      lunchCorner = EMPTY_MEAL_KOR;
      lunchBldg1_2 = EMPTY_MEAL_KOR;
      dinner = EMPTY_MEAL_KOR;
    } else if (langType == LANG_ENG) {
      breakfast = EMPTY_MEAL_ENG;
      lunch = EMPTY_MEAL_ENG;
      lunchCorner = EMPTY_MEAL_ENG;
      lunchBldg1_2 = EMPTY_MEAL_ENG;
      dinner = EMPTY_MEAL_ENG;
    }
  }
}
