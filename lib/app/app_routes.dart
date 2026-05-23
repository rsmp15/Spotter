import 'package:flutter/material.dart';

import '../screens/admin_review_screen.dart';
import '../screens/cancel_ride_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/choose_role_screen.dart';
import '../screens/create_trip_screen.dart';
import '../screens/dispute_case_screen.dart';
import '../screens/driver_home_screen.dart';
import '../screens/drop_task_screen.dart';
import '../screens/empty_state_screen.dart';
import '../screens/job_detail_screen.dart';
import '../screens/job_requests_screen.dart';
import '../screens/kyc_verification_screen.dart';
import '../screens/login_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/otp_verification_screen.dart';
import '../screens/pickup_task_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/share_trip_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/services_screen.dart';
import '../screens/support_screen.dart';
import '../screens/wallet_screen.dart';
import 'app_error_screen.dart';
import 'spotter_overlay_shell.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String chooseRole = '/choose-role';
  static const String home = '/home';
  static const String pickup = '/pickup';
  static const String destination = '/destination';
  static const String fare = '/fare';
  static const String drivers = '/drivers';
  static const String driverProfile = '/driver-profile';
  static const String confirmRide = '/confirm-ride';
  static const String payment = '/payment';
  static const String tracking = '/tracking';
  static const String rideOtp = '/ride-otp';
  static const String rideComplete = '/ride-complete';
  static const String wallet = '/wallet';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String shareTrip = '/share-trip';
  static const String cancelRide = '/cancel-ride';
  static const String rating = '/rating';
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String services = '/services';
  static const String dispute = '/dispute';
  static const String empty = '/empty';
  static const String kyc = '/kyc';
  static const String driverHome = '/driver-home';
  static const String createTrip = '/create-trip';
  static const String jobRequests = '/job-requests';
  static const String jobDetail = '/job-detail';
  static const String pickupTask = '/pickup-task';
  static const String dropTask = '/drop-task';
  static const String adminReview = '/admin-review';

  static const List<String> allRoutes = [
    splash,
    onboarding,
    login,
    otp,
    chooseRole,
    home,
    pickup,
    destination,
    fare,
    drivers,
    driverProfile,
    confirmRide,
    payment,
    tracking,
    rideOtp,
    rideComplete,
    wallet,
    profile,
    chat,
    shareTrip,
    cancelRide,
    rating,
    notifications,
    support,
    services,
    dispute,
    empty,
    kyc,
    driverHome,
    createTrip,
    jobRequests,
    jobDetail,
    pickupTask,
    dropTask,
    adminReview,
  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => _screenFor(settings.name),
    );
  }

  static Widget _screenFor(String? routeName) {
    switch (routeName) {
      case splash:
        return const SplashScreen();
      case onboarding:
        return const OnboardingScreen();
      case login:
        return const LoginScreen();
      case otp:
        return const OtpVerificationScreen();
      case chooseRole:
        return const ChooseRoleScreen();
      case home:
        return const SpotterOverlayShell();
      case pickup:
        return const SpotterOverlayShell();
      case destination:
        return const SpotterOverlayShell();
      case fare:
        return const SpotterOverlayShell();
      case drivers:
        return const SpotterOverlayShell();
      case driverProfile:
        return const SpotterOverlayShell();
      case confirmRide:
        return const SpotterOverlayShell();
      case payment:
        return const SpotterOverlayShell();
      case tracking:
        return const SpotterOverlayShell();
      case rideOtp:
        return const SpotterOverlayShell();
      case rideComplete:
        return const SpotterOverlayShell();
      case wallet:
        return const WalletScreen();
      case profile:
        return const ProfileScreen();
      case chat:
        return const ChatScreen();
      case shareTrip:
        return const ShareTripScreen();
      case cancelRide:
        return const CancelRideScreen();
      case rating:
        return const SpotterOverlayShell();
      case notifications:
        return const NotificationsScreen();
      case support:
        return const SupportScreen();
      case services:
        return const ServicesScreen();
      case dispute:
        return const DisputeCaseScreen();
      case empty:
        return const EmptyStateScreen();
      case kyc:
        return const KycVerificationScreen();
      case driverHome:
        return const DriverHomeScreen();
      case createTrip:
        return const CreateTripScreen();
      case jobRequests:
        return const JobRequestsScreen();
      case jobDetail:
        return const JobDetailScreen();
      case pickupTask:
        return const PickupTaskScreen();
      case dropTask:
        return const DropTaskScreen();
      case adminReview:
        return const AdminReviewScreen();
      default:
        return const AppErrorScreen(
          title: 'Page not found',
          message:
              'The screen you requested is not available. Return home to continue safely.',
        );
    }
  }
}
