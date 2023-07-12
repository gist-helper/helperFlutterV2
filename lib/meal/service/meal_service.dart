import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/const/types.dart';
import '../model/meal_model.dart';

class MealService {
  static const String baseUrl = "http://43.201.94.123:8080";
  static const String mealDatePath = "meals/date";

  static Future<List<List<List<MealModel>>>> getTodayMeal(
      List<List<Map<String, dynamic>>> nextFiveDays) async {
    late List<List<List<MealModel>>> nextFiveDaysMeals = [];

    for (int langType in LANG_ARRAY) {
      List<List<MealModel>> nextFiveDaysLangTypeMeals = [];
      for (int bldgType in BLDG_ARRAY) {
        List<MealModel> nextFiveDaysLangTypeBldgTypeMeals = [];
        for (int i = 0; i < 5; i++) {
          int? year = nextFiveDays[langType][i]['year'];
          int? month = nextFiveDays[langType][i]['month'];
          int? day = nextFiveDays[langType][i]['day'];
          int? weekday = nextFiveDays[langType][i]['weekday'];
          final url = Uri.parse(
              '$baseUrl/$mealDatePath/$year/$month/$day/$bldgType/$langType');
          final response = await http.get(url);
          if (response.statusCode == 200) {
            final dynamic mealModel = jsonDecode(response.body);
            if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
              mealModel['lunch_corner'] = langType == LANG_KOR
                  ? WEEKEND_BLDG_2_CONER_KOR
                  : WEEKEND_BLDG_2_CONER_ENG;
            }
            nextFiveDaysLangTypeBldgTypeMeals
                .add(MealModel.fromJson(mealModel));
          } else {
            nextFiveDaysLangTypeBldgTypeMeals.add(MealModel(langType));
          }
        }
        nextFiveDaysLangTypeMeals.add(nextFiveDaysLangTypeBldgTypeMeals);
      }
      nextFiveDaysMeals.add(nextFiveDaysLangTypeMeals);
    }
    return nextFiveDaysMeals;
  }
}
