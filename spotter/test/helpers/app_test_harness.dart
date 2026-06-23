import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';
import 'package:spotter/controllers/ride_controller.dart';
import 'package:spotter/helper.dart';
import 'package:spotter/models/spott_models.dart';
import 'package:spotter/repositories/ride_repository.dart';
import 'package:spotter/repositories/remote_config_repository.dart';

Future<RideController> pumpSpotterRoute(
  WidgetTester tester,
  String routeName, {
  RideRepository? repository,
  RemoteConfigRepository? remoteConfigRepository,
  UserRole? overrideRole,
}) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final controller = RideController(repository: repository);
  


  await controller.initialize();

  final configRepo = remoteConfigRepository ?? RemoteConfigRepository();

  await tester.pumpWidget(
    RemoteConfigScope(
      repository: configRepo,
      child: RideScope(
        controller: controller,
        child: MaterialApp(
          theme: Helper.theme,
          initialRoute: routeName,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return controller;
}

