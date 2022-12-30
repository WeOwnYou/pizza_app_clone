import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_names.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_paths.dart';
import 'package:dodo_clone/src/features/splash/ui/view/splash_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const splashRoute = AutoRoute<MaterialWithModalsPageRoute<dynamic>>(
  path: AppRoutePaths.splashPath,
  name: AppRouteNames.splashScreen,
  page: SplashView,
  initial: true,
);
