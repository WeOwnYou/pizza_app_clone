import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_names.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_paths.dart';
import 'package:dodo_clone/src/features/location/ui/view/select_city_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const selectCityRoute = AutoRoute<MaterialWithModalsPageRoute<dynamic>>(
  path: AppRoutePaths.selectCityPath,
  name: AppRouteNames.selectCityScreen,
  page: SelectCityView,
);
