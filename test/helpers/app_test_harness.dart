import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';
import 'package:spotter/controllers/ride_controller.dart';
import 'package:spotter/helper.dart';
import 'package:spotter/repositories/ride_repository.dart';

Future<RideController> pumpSpotterRoute(
  WidgetTester tester,
  String routeName, {
  RideRepository? repository,
}) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final controller = RideController(repository: repository);
  await controller.initialize();

  await tester.pumpWidget(
    RideScope(
      controller: controller,
      child: MaterialApp(
        theme: Helper.theme,
        initialRoute: routeName,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return controller;
}
