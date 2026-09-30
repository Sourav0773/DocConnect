import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/bloc_observer/app_bloc_observer.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/logs/logger.dart';

void main() {

  logger.runLogging(() => runZonedGuarded<Future<void>>( () async {

        //debugRepaintRainbowEnabled = true;

        WidgetsFlutterBinding.ensureInitialized();

        FlutterError.onError = logger.logFlutterError;
        PlatformDispatcher.instance.onError = logger.logPlatformDispatcherError;

        /// Supabase initialization
        await Supabase.initialize(
          url: AppConfig.supabaseUrl,
          publishableKey: AppConfig.supabaseAnonKey,
        );

        /// DI config
        configureDependencies();

        Bloc.observer = const AppBlocObserver();
        Bloc.transformer = sequential();

        runApp(const DoctorAppointmentApp());
      },
              (error, stackTrace) => logger.logZoneError(error, stackTrace),
    ),
  );
}
