import 'package:flutter/material.dart';
import 'package:helper_flutter_v2/common/layout/default_layout.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello!"),
          ],
        ),
      ),
    );
  }
}
