import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quantum_coherence/app/app.dart';
import 'package:quantum_coherence/app/injector/injector.dart';
import 'package:quantum_coherence/app/observers/app_bloc_observer.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        log(details.exceptionAsString(), stackTrace: details.stack);
      };

      configureInjector();

      await Firebase.initializeApp();

      Bloc.observer = const AppBlocObserver();

      runApp(const App());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
