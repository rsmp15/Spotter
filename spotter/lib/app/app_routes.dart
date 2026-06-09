import 'package:flutter/material.dart';

import '../models/spott_models.dart';
import '../controllers/ride_controller.dart';
import '../core/theme/animations.dart';
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
import '../screens/safety_toolkit_screen.dart';
import '../screens/share_trip_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/support_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/vehicle_management_screen.dart';
import '../screens/trip_search_screen.dart';
import '../screens/passenger_requests_screen.dart';
import '../screens/booking_success_screen.dart';
import 'app_error_screen.dart';
import 'spotter_overlay_shell.dart';
import '../screens/main_navigation_shell.dart';
// Nav components are now integrated, no need to import rider_bottom_nav
import '../screens/parcel_booking_screen.dart';
import '../screens/parcel_tracking_screen.dart';
import '../screens/parcel_complete_screen.dart';
import '../screens/figma_plugin_sandbox_screen.dart';
import '../screens/search_results_screen.dart';
import '../screens/verification_pending_screen.dart';
import '../screens/maintenance_screen.dart';
import '../screens/no_results_screen.dart';
import '../screens/network_error_screen.dart';
import '../screens/trip_details_screen.dart';
import '../screens/passenger_trips_screen.dart';
import '../screens/parcel_history_screen.dart';
import '../screens/traveler_trips_screen.dart';
import '../screens/active_trip_screen.dart';

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
  static const String activity = '/activity';
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String safetyToolkit = '/safety-toolkit';
  static const String services = '/services';
  static const String parking = '/parking';
  static const String offers = '/offers';
  static const String scheduleRide = '/schedule-ride';
  static const String intercity = '/intercity';
  static const String rentals = '/rentals';
  static const String settings = '/settings';
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
  static const String parcelBooking = '/parcel-booking';
  static const String parcelTracking = '/parcel-tracking';
  static const String parcelComplete = '/parcel-complete';
  static const String vehicleManagement = '/vehicle-management';
  static const String tripSearch = '/trip-search';
  static const String passengerRequests = '/passenger-requests';
  static const String bookingSuccess = '/booking-success';
  static const String figmaPluginSandbox = '/figma-plugin-sandbox';
  static const String searchResults = '/search-results';
  static const String verificationPending = '/verification-pending';
  static const String maintenance = '/maintenance';
  static const String noResults = '/no-results';
  static const String networkError = '/network-error';
  static const String tripDetails = '/trip-details';
  static const String passengerTrips = '/passenger-trips';
  static const String parcelHistory = '/parcel-history';
  static const String travelerTrips = '/traveler-trips';
  static const String activeTrip = '/active-trip';

  static const List<String> allRoutes = [
    parcelBooking,
    parcelTracking,
    parcelComplete,
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
    activity,
    notifications,
    support,
    safetyToolkit,
    services,
    parking,
    offers,
    scheduleRide,
    intercity,
    rentals,
    settings,
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
    vehicleManagement,
    tripSearch,
    passengerRequests,
    bookingSuccess,
    figmaPluginSandbox,
    searchResults,
    verificationPending,
    maintenance,
    noResults,
    networkError,
    tripDetails,
    passengerTrips,
    parcelHistory,
    travelerTrips,
    activeTrip,
  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    PageRouteBuilder buildRoute(Widget child) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: SpottPageTransitions.fadeSlideUp,
        transitionDuration: SpottAnimations.medium,
        reverseTransitionDuration: SpottAnimations.medium,
      );
    }

    return buildRoute(_screenFor(settings.name));
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
        return const RoleGuard(
          allowedRoles: [UserRole.passenger, UserRole.parcelSender],
          child: MainNavigationShell(initialTab: 0),
        );
      case pickup:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case destination:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case fare:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case drivers:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case driverProfile:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case confirmRide:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case payment:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case tracking:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case rideOtp:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case rideComplete:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case wallet:
        return const SettingsScreen();
      case profile:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger, UserRole.parcelSender],
          child: MainNavigationShell(initialTab: 4),
        );
      case chat:
        return const ChatScreen();
      case shareTrip:
        return const ShareTripScreen();
      case cancelRide:
        return const CancelRideScreen();
      case rating:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SpotterOverlayShell(),
        );
      case activity:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger, UserRole.parcelSender],
          child: MainNavigationShell(initialTab: 2),
        );
      case notifications:
        return const NotificationsScreen();
      case support:
        return const SupportScreen();
      case safetyToolkit:
        return const PremiumSosAlertScreen();
      case services:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger, UserRole.parcelSender],
          child: MainNavigationShell(initialTab: 1),
        );
      case parking:
        return const AppErrorScreen(
          title: 'Out of scope',
          message: 'Parking is out of scope for the Spott MVP.',
        );
      case offers:
        return const AppErrorScreen(
          title: 'Out of scope',
          message: 'Offers are out of scope for the Spott MVP.',
        );
      case scheduleRide:
        return const AppErrorScreen(
          title: 'Out of scope',
          message: 'Scheduled rides are out of scope for the Spott MVP.',
        );
      case intercity:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: TripSearchScreen(),
        );
      case rentals:
        return const AppErrorScreen(
          title: 'Out of scope',
          message: 'Rentals are out of scope for the Spott MVP.',
        );
      case settings:
        return const SettingsScreen();
      case dispute:
        return const DisputeCaseScreen();
      case empty:
        return const EmptyStateScreen();
      case kyc:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: KycVerificationScreen(),
        );
      case driverHome:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: DriverHomeScreen(),
        );
      case createTrip:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler, UserRole.passenger],
          child: CreateTripScreen(),
        );
      case jobRequests:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: JobRequestsScreen(),
        );
      case jobDetail:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: JobDetailScreen(),
        );
      case pickupTask:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: PickupTaskScreen(),
        );
      case dropTask:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: DropTaskScreen(),
        );
      case adminReview:
        return const AdminReviewScreen();
      case parcelBooking:
        return const RoleGuard(
          allowedRoles: [UserRole.parcelSender, UserRole.passenger],
          child: ParcelBookingScreen(),
        );
      case parcelTracking:
        return const RoleGuard(
          allowedRoles: [UserRole.parcelSender],
          child: ParcelTrackingScreen(),
        );
      case parcelComplete:
        return const RoleGuard(
          allowedRoles: [UserRole.parcelSender],
          child: ParcelCompleteScreen(),
        );
      case vehicleManagement:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: VehicleManagementScreen(),
        );
      case tripSearch:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: TripSearchScreen(),
        );
      case passengerRequests:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: PassengerRequestsScreen(),
        );
      case bookingSuccess:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: BookingSuccessScreen(),
        );
      case figmaPluginSandbox:
        return const FigmaPluginSandboxScreen();
      case searchResults:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: SearchResultsScreen(),
        );
      case verificationPending:
        return const VerificationPendingScreen();
      case maintenance:
        return const MaintenanceScreen();
      case noResults:
        return const NoResultsScreen();
      case networkError:
        return const NetworkErrorScreen();
      case tripDetails:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: TripDetailsScreen(),
        );
      case passengerTrips:
        return const RoleGuard(
          allowedRoles: [UserRole.passenger],
          child: PassengerTripsScreen(),
        );
      case parcelHistory:
        return const RoleGuard(
          allowedRoles: [UserRole.parcelSender],
          child: ParcelHistoryScreen(),
        );
      case travelerTrips:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: TravelerTripsScreen(),
        );
      case activeTrip:
        return const RoleGuard(
          allowedRoles: [UserRole.traveler],
          child: ActiveTripScreen(),
        );
      default:
        return const AppErrorScreen(
          title: 'Page not found',
          message:
              'The screen you requested is not available. Return home to continue safely.',
        );
    }
  }
}

class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<UserRole> allowedRoles;

  const RoleGuard({super.key, required this.child, required this.allowedRoles});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final userRole = ride.currentUserRole;

    if (allowedRoles.contains(userRole)) {
      return child;
    }

    return const RoleMismatchScreen();
  }
}

class RoleMismatchScreen extends StatelessWidget {
  const RoleMismatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppErrorScreen(
      title: 'Role Mismatch',
      message: 'This screen is not available for your current selected role.',
      showHomeAction: true,
    );
  }
}
