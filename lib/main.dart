import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/app_config.dart';
import 'app/app_crash_reporter.dart';
import 'app/app_error_screen.dart';
import 'app/app_readiness.dart';
import 'app/app_routes.dart';
import 'controllers/ride_controller.dart';
import 'helper.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = AppCrashReporter.recordFlutterError;
      PlatformDispatcher.instance.onError =
          AppCrashReporter.recordPlatformError;
      final readiness = AppReadiness.evaluate();
      if (kDebugMode && !readiness.isProductionReady) {
        debugPrint(
          'Production readiness blocked: '
          '${readiness.blockingChecks.map((check) => check.label).join(', ')}',
        );
      }

      ErrorWidget.builder = (details) {
        if (kDebugMode) {
          return ErrorWidget(details.exception);
        }

        return const AppErrorScreen();
      };

      runApp(const MyApp());
    },
    (error, stackTrace) {
      AppCrashReporter.recordPlatformError(error, stackTrace);
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final RideController _rideController;

  @override
  void initState() {
    super.initState();
    _rideController = RideController();
    unawaited(_rideController.initialize());
  }

  @override
  void dispose() {
    _rideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RideScope(
      controller: _rideController,
      child: ListenableBuilder(
        listenable: _rideController,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConfig.appName,
            theme: Helper.buildTheme(isDarkMode: _rideController.isDarkMode),
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
