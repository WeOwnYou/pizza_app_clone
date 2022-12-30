import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_names.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_paths.dart';
import 'package:dodo_clone/src/features/contacts/ui/view/about_app_view.dart';
import 'package:dodo_clone/src/features/contacts/ui/view/contacts_view.dart';
import 'package:dodo_clone/src/features/contacts/ui/view/legal_documents_view.dart';

const contactsRoutes = AutoRoute<dynamic>(
  path: AppRoutePaths.contactsPath,
  name: AppRouteNames.contactsScreen,
  page: EmptyRouterPage,
  children: [
    AutoRoute<dynamic>(
      name: 'ContactsRouter',
      initial: true,
      page: ContactsView,
    ),
    AutoRoute<dynamic>(
      path: AppRoutePaths.legalDocumentsPath,
      name: AppRouteNames.legalDocumentsScreen,
      page: LegalDocumentsView,
    ),
    AutoRoute<dynamic>(
      path: AppRoutePaths.aboutAppPath,
      name: AppRouteNames.aboutAppScreen,
      page: AboutAppView,
    ),
  ],
);
