import 'app_config_test.dart' as app_config_test;
import 'app_crash_reporter_test.dart' as app_crash_reporter_test;
import 'app_readiness_test.dart' as app_readiness_test;
import 'driver_flow_test.dart' as driver_flow_test;
import 'incident_recovery_test.dart' as incident_recovery_test;
import 'ride_recovery_test.dart' as ride_recovery_test;
import 'rider_flow_test.dart' as rider_flow_test;
import 'route_coverage_test.dart' as route_coverage_test;
import 'support_case_test.dart' as support_case_test;
import 'support_dispute_flow_test.dart' as support_dispute_flow_test;

void main() {
  app_config_test.main();
  app_crash_reporter_test.main();
  app_readiness_test.main();
  driver_flow_test.main();
  incident_recovery_test.main();
  ride_recovery_test.main();
  rider_flow_test.main();
  route_coverage_test.main();
  support_case_test.main();
  support_dispute_flow_test.main();
}
