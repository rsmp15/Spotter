import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_config.dart';
import 'package:spotter/models/production_readiness_models.dart';

void main() {
  test('default app config is development release mode', () {
    expect(AppConfig.appName, 'Spott');
    expect(AppConfig.releaseMode.name, AppReleaseMode.development);
    expect(AppConfig.isProduction, isFalse);
  });

  test('release mode parser recognizes production and staging aliases', () {
    final production = ReleaseMode.fromEnvironment(
      environment: 'prod',
      diagnosticsEnabled: true,
    );
    final staging = ReleaseMode.fromEnvironment(
      environment: 'stage',
      diagnosticsEnabled: false,
    );

    expect(production.name, AppReleaseMode.production);
    expect(production.isProduction, isTrue);
    expect(staging.name, AppReleaseMode.staging);
    expect(staging.isProduction, isFalse);
  });

  test('unknown release mode is not production ready', () {
    final unknown = ReleaseMode.fromEnvironment(
      environment: 'qa-preview',
      diagnosticsEnabled: true,
    );

    expect(unknown.name, AppReleaseMode.unknown);
    expect(unknown.isProduction, isFalse);
  });
}
