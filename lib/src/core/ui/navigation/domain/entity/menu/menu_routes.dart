import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_names.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_paths.dart';
import 'package:dodo_clone/src/features/menu/ui/view/menu_view/menu_view.dart';
import 'package:dodo_clone/src/features/menu/ui/view/search_view.dart';
import 'package:dodo_clone/src/features/menu/ui/view/story_view/story_view.dart';

const menuRoutes = AutoRoute<dynamic>(
  path: AppRoutePaths.menuPath,
  name: AppRouteNames.menuScreen,
  page: EmptyRouterPage,
  children: [
    AutoRoute<dynamic>(
      name: 'MenuRouter',
      initial: true,
      page: MenuView,
    ),
    AutoRoute<dynamic>(
      path: AppRoutePaths.searchPath,
      name: AppRouteNames.searchScreen,
      page: SearchView,
    )
  ],
);

const storyRoute = CustomRoute<List<int>?>(
  name: AppRouteNames.storyScreen,
  path: AppRoutePaths.storyPath,
  page: StoryView,
  fullscreenDialog: true,
  opaque: false,
  transitionsBuilder: TransitionsBuilders.zoomIn,
);
