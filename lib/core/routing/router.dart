import 'package:flutter/material.dart';
import 'package:flutter_text_to_speech/core/routing/routes.dart';

import '../../ui/home_screen.dart';
import '../../ui/solution_homescreen.dart';

class PageRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case Routes.solutionHomeScreen:
        return MaterialPageRoute(builder: (context) => const SolutionHomeScreen());
      default:
        return MaterialPageRoute(builder: (context) {
          return const Scaffold(
            body: Center(child: Text("no page found")),
          );
        });
    }
  }
}
