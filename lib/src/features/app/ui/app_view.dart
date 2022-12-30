import 'package:address_repository/address_repository.dart';
import 'package:dodo_clone/generated/l10n.dart';
import 'package:dodo_clone/src/config/app_config.dart';
import 'package:dodo_clone/src/config/debug_options.dart';
import 'package:dodo_clone/src/config/environment/environment.dart';
import 'package:dodo_clone/src/core/ui/theme/app_theme.dart';
import 'package:dodo_clone/src/features/app/domain/di/app_scope.dart';
import 'package:dodo_clone/src/features/common/ui/widgets/di_scope.dart';
import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_cubit.dart';
import 'package:dodo_clone/src/features/settings/settings_controller.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:person_repository/person_repository.dart';

class AppView extends StatefulWidget {
  final SettingsController settingsController;
  final IAddressRepository addressRepository;
  final PersonRepository personRepository;
  final IDodoCloneRepository dodoCloneRepository;
  final AddressCubit addressCubit;
  final ContactsCubit contactsCubit;
  const AppView({
    required this.settingsController,
    required this.addressRepository,
    required this.personRepository,
    required this.dodoCloneRepository,
    required this.addressCubit,
    required this.contactsCubit,
    super.key,
  });

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late IAppScope _scope;

  @override
  void initState() {
    super.initState();
    _scope = AppScope(applicationRebuilder: _rebuildApplication);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => widget.addressRepository,
          lazy: false,
        ),
        RepositoryProvider(
          create: (context) => widget.dodoCloneRepository,
        ),
        RepositoryProvider(
          create: (context) => widget.personRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => widget.addressCubit,
            lazy: false,
          ),
          BlocProvider(
            create: (context) => widget.contactsCubit,
            lazy: false,
          ),
        ],
        child: AnimatedBuilder(
          animation: widget.settingsController,
          builder: (context, child) => DiScope(
            key: ObjectKey(_scope),
            factory: () {
              return _scope;
            },
            child: MaterialApp.router(
              /// Debug configuration.
              showPerformanceOverlay: _getDebugConfig().showPerformanceOverlay,
              debugShowMaterialGrid: _getDebugConfig().debugShowMaterialGrid,
              checkerboardOffscreenLayers:
                  _getDebugConfig().checkerboardOffscreenLayers,
              showSemanticsDebugger: _getDebugConfig().showSemanticsDebugger,
              debugShowCheckedModeBanner:
                  _getDebugConfig().debugShowCheckedModeBanner,

              /// Theme
              theme: AppTheme.light,
              darkTheme: AppTheme.light, //AppTheme.dart,
              themeMode: widget.settingsController.themeMode,
              builder: AppTheme.iosLight,
              /// Locale
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              /// Navigation
              routeInformationParser: _scope.router.defaultRouteParser(),
              routerDelegate: _scope.router.delegate(),
            ),
          ),
        ),
      ),
    );
  }

  DebugOptions _getDebugConfig() {
    return Environment<AppConfig>.instance().config.debugOptions;
  }

  void _rebuildApplication() {
    setState(() {
      _scope = AppScope(applicationRebuilder: _rebuildApplication);
    });
  }
}
