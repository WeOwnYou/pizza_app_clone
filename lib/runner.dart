import 'dart:async';

import 'package:address_repository/address_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dodo_clone/src/features/app/domain/bloc/simple_bloc_observer.dart';
import 'package:dodo_clone/src/features/app/ui/app_view.dart';
import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_cubit.dart';
import 'package:dodo_clone/src/features/settings/settings_service.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:person_repository/person_repository.dart';

import 'src/features/settings/settings_controller.dart';

Future<void> run(String url) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // TODO(mes): по хорошему сюда бы накинуть логгер
  _runApp(url);
}

void _runApp(String url) {
  runZonedGuarded<Future<void>>(() async {
    await Firebase.initializeApp();
    Bloc.observer = AppBlocObserver();
    Bloc.transformer = sequential<Object?>();
    await Hive.initFlutter();
    final settingsController = SettingsController(SettingsService());
    final addressRepository = AddressRepository(url: url);
    final personRepository = PersonRepository();
    final dodoCloneRepository = DodoCloneRepository(
      url: url,
    );
    final contactsCubit = ContactsCubit(personRepository);
    final addressCubit = AddressCubit(
      addressRepository: addressRepository,
    );
    await settingsController.loadSettings();
    runApp(
      AppView(
        contactsCubit: contactsCubit,
        settingsController: settingsController,
        addressRepository: addressRepository,
        personRepository: personRepository,
        dodoCloneRepository: dodoCloneRepository,
        addressCubit: addressCubit,
      ),
    );
  }, (error, stack) {
    debugPrint('ERROR');
    debugPrint('$error');
    debugPrint('$stack');
    debugPrint('END ERROR');
  });
}
