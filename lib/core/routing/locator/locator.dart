import 'package:get_it/get_it.dart';

import '../../view_model/homescreen_model/homemodel.dart';
import '../../view_model/homescreen_model/solution_homemodel.dart';

final locator = GetIt.instance;

setLocator() {
  locator.registerLazySingleton(() => HomeScreenViewModel());
  locator.registerLazySingleton(() => SolutionHomeScreenViewModel());
}
