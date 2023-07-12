import 'package:flutter/material.dart';

import '../../meal/model/meal_model.dart';
import '../../meal/service/meal_service.dart';
import '../const/colors.dart';
import '../const/types.dart';

const List<List<Widget>> bldgNameWidget = [
  <Widget>[
    Text(
      '1학생식당',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      '2학생식당',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ],
  <Widget>[
    Text(
      'Std.Bldg.1',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      'Std.Bldg.2',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ],
];

class DefaultLayout extends StatefulWidget {
  final Widget child;

  const DefaultLayout({
    super.key,
    required this.child,
  });

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

// ignore: constant_identifier_names
enum LangTypeEnum { LANG_KOR, LANG_ENG }

class _DefaultLayoutState extends State<DefaultLayout> {
  int bottomSelectedIndex = 0;
  int globalLangType = 0;
  int globalBldgType = 0;
  List<bool> selectedBldg = <bool>[false, true];
  late final List<List<Map<String, dynamic>>> nextFiveDays;
  late final Future<List<List<List<MealModel>>>> nextFiveDaysMeals;
  void onBottomTab(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void onToggleTab(int index) {
    setState(() {
      globalBldgType = index;
      for (int i = 0; i < selectedBldg.length; i++) {
        selectedBldg[i] = i == index;
      }
    });
  }

  void onHorizontalDargStart(DragStartDetails dragStartDetails) {
    //print(dragStartDetails.globalPosition);
  }

  void onHorizontalDragEnd(DragEndDetails dragEndDetails) {
    setState(() {
      if (dragEndDetails.velocity.pixelsPerSecond.dx > 0) {
        globalBldgType = BLDG_2 - 1;
        for (int i = 0; i < selectedBldg.length; i++) {
          selectedBldg[i] = i == BLDG_2 - 1;
        }
      } else {
        globalBldgType = BLDG_1 - 1;
        for (int i = 0; i < selectedBldg.length; i++) {
          selectedBldg[i] = i == BLDG_1 - 1;
        }
      }
    });
  }

  String getDayString(int langType, DateTime nowDate) {
    int month = nowDate.month;
    int day = nowDate.day;
    int weekday = nowDate.weekday;
    if (langType == LANG_KOR) {
      return "$month월 $day일 (${DATE_STR[langType][weekday - 1]})";
    } else {
      return "${DATE_STR[langType][weekday - 1]}, ${MONTH_ABBR_ENG[month - 1]} $day";
    }
  }

  @override
  void initState() {
    super.initState();
    var nowDate = DateTime.now();
    List<List<Map<String, dynamic>>> nextFiveDaysTemp = [];
    for (int langType in LANG_ARRAY) {
      nowDate = DateTime.now();
      List<Map<String, dynamic>> nextFiveDaysLangTypeTemp = [];
      for (int i = 0; i < 5; i++) {
        Map<String, dynamic> daysInfo = {
          "year": nowDate.year,
          "month": nowDate.month,
          "day": nowDate.day,
          "weekday": nowDate.weekday,
          "dayString": getDayString(langType, nowDate)
        };
        nextFiveDaysLangTypeTemp.add(daysInfo);
        nowDate = nowDate.add(const Duration(days: 1));
      }
      nextFiveDaysTemp.add(nextFiveDaysLangTypeTemp);
    }
    nextFiveDays = nextFiveDaysTemp;
    nextFiveDaysMeals = MealService.getTodayMeal(nextFiveDays);
    //print(nextFiveDays);
    print(nextFiveDaysMeals);
    setState(() {});
  }

  LangTypeEnum? _character = LangTypeEnum.LANG_KOR;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: HELPER_BACKGROUND_COLOR,
          elevation: 0,
          actions: const [],
          flexibleSpace: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: 0,
                    icon: const Icon(
                      Icons.settings,
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    nextFiveDays[globalLangType][bottomSelectedIndex]
                        ['dayString'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('언어 선택 / Select Language'),
                        content: Column(
                          children: <Widget>[
                            ListTile(
                              title: const Text('한국어 / Korean'),
                              leading: Radio<LangTypeEnum>(
                                value: LangTypeEnum.LANG_KOR,
                                groupValue: _character,
                                onChanged: (LangTypeEnum? value) {
                                  setState(() {
                                    _character = value;
                                    globalLangType = LANG_KOR;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('영어 / English'),
                              leading: Radio<LangTypeEnum>(
                                value: LangTypeEnum.LANG_ENG,
                                groupValue: _character,
                                onChanged: (LangTypeEnum? value) {
                                  setState(() {
                                    _character = value;
                                    globalLangType = LANG_ENG;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('Done'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: onToggleTab,
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    selectedColor: Colors.white,
                    selectedBorderColor: HELPER_RED_COLOR,
                    color: HELPER_GREY_COLOR,
                    fillColor: HELPER_RED_COLOR,
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 170.0,
                    ),
                    isSelected: selectedBldg,
                    children: bldgNameWidget[globalLangType],
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: HELPER_BACKGROUND_COLOR,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragStart: onHorizontalDargStart,
                  onHorizontalDragEnd: onHorizontalDragEnd,
                  child: FutureBuilder(
                    future: nextFiveDaysMeals,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (globalBldgType == BLDG_1 - 1) {
                          if (nextFiveDays[globalLangType][bottomSelectedIndex]
                                      ['weekday'] ==
                                  DateTime.saturday ||
                              nextFiveDays[globalLangType][bottomSelectedIndex]
                                      ['weekday'] ==
                                  DateTime.sunday) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 300),
                                  child: Text(
                                    globalLangType == LANG_KOR
                                        ? WEEKEND_BLDG_1_KOR
                                        : WEEKEND_BLDG_1_ENG,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MealCard(
                                  globalLangType: globalLangType,
                                  globalBldgType: globalBldgType,
                                  bottomSelectedIndex: bottomSelectedIndex,
                                  showString: snapshot
                                      .data![globalLangType][globalBldgType]
                                          [bottomSelectedIndex]
                                      .breakfast,
                                  kindType: 0,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MealCard(
                                  globalLangType: globalLangType,
                                  globalBldgType: globalBldgType,
                                  bottomSelectedIndex: bottomSelectedIndex,
                                  showString: snapshot
                                      .data![globalLangType][globalBldgType]
                                          [bottomSelectedIndex]
                                      .lunch,
                                  kindType: 1,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MealCard(
                                  globalLangType: globalLangType,
                                  globalBldgType: globalBldgType,
                                  bottomSelectedIndex: bottomSelectedIndex,
                                  showString: snapshot
                                      .data![globalLangType][globalBldgType]
                                          [bottomSelectedIndex]
                                      .lunchCorner,
                                  kindType: 2,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MealCard(
                                  globalLangType: globalLangType,
                                  globalBldgType: globalBldgType,
                                  bottomSelectedIndex: bottomSelectedIndex,
                                  showString: snapshot
                                      .data![globalLangType][globalBldgType]
                                          [bottomSelectedIndex]
                                      .lunchBldg1_2,
                                  kindType: 3,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MealCard(
                                  globalLangType: globalLangType,
                                  globalBldgType: globalBldgType,
                                  bottomSelectedIndex: bottomSelectedIndex,
                                  showString: snapshot
                                      .data![globalLangType][globalBldgType]
                                          [bottomSelectedIndex]
                                      .dinner,
                                  kindType: 4,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          }
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MealCard(
                                globalLangType: globalLangType,
                                globalBldgType: globalBldgType,
                                bottomSelectedIndex: bottomSelectedIndex,
                                showString: snapshot
                                    .data![globalLangType][globalBldgType]
                                        [bottomSelectedIndex]
                                    .breakfast,
                                kindType: 0,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MealCard(
                                globalLangType: globalLangType,
                                globalBldgType: globalBldgType,
                                bottomSelectedIndex: bottomSelectedIndex,
                                showString: snapshot
                                    .data![globalLangType][globalBldgType]
                                        [bottomSelectedIndex]
                                    .lunch,
                                kindType: 1,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MealCard(
                                globalLangType: globalLangType,
                                globalBldgType: globalBldgType,
                                bottomSelectedIndex: bottomSelectedIndex,
                                showString: snapshot
                                    .data![globalLangType][globalBldgType]
                                        [bottomSelectedIndex]
                                    .lunchCorner,
                                kindType: 2,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MealCard(
                                globalLangType: globalLangType,
                                globalBldgType: globalBldgType,
                                bottomSelectedIndex: bottomSelectedIndex,
                                showString: snapshot
                                    .data![globalLangType][globalBldgType]
                                        [bottomSelectedIndex]
                                    .dinner,
                                kindType: 4,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }
                      }
                      return const Column(
                        children: [
                          SizedBox(
                            height: 300,
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              for (int i = 0; i < 5; i++)
                BottomNavigationBarItem(
                  icon: Text(
                    "${nextFiveDays[globalLangType][i]['day']}\n${DATE_STR[globalLangType][nextFiveDays[globalLangType][i]['weekday'] - 1]}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: HELPER_GREY_COLOR,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  activeIcon: Text(
                    "${nextFiveDays[globalLangType][i]['day']}\n${DATE_STR[globalLangType][nextFiveDays[globalLangType][i]['weekday'] - 1]}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: HELPER_RED_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  label: '',
                  backgroundColor: Colors.white,
                ),
            ],
            currentIndex: bottomSelectedIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: onBottomTab,
          ),
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.globalLangType,
    required this.globalBldgType,
    required this.bottomSelectedIndex,
    required this.showString,
    required this.kindType,
  });

  final int globalLangType;
  final int globalBldgType;
  final int bottomSelectedIndex;
  final String showString;
  final int kindType;

  String cutLastString(String s) {
    return s.substring(0, s.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: HELPER_GREY_COLOR.withOpacity(0.3),
        width: 1,
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  MEAL_NAME[globalLangType][kindType],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(MEAL_TIME[kindType],
                    style: const TextStyle(color: HELPER_GREY_COLOR)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(cutLastString(showString)),
          ],
        ),
      ),
    );
  }
}
