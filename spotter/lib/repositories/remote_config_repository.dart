import 'dart:convert';
import 'package:flutter/material.dart';

/// Defines the available configuration flags and their default values.
class RemoteConfigState {
  final bool showPromoBanner;
  final String promoBannerText;
  final bool maintenanceMode;
  final bool showOffers;
  final String offerTitle;
  final String offerSubtitle;

  const RemoteConfigState({
    this.showPromoBanner = false,
    this.promoBannerText = '',
    this.maintenanceMode = false,
    this.showOffers = true,
    this.offerTitle = '20% off your next trip',
    this.offerSubtitle = 'Use code SPOTT20. Max discount ₹100.',
  });

  factory RemoteConfigState.fromJson(Map<String, dynamic> json) {
    return RemoteConfigState(
      showPromoBanner: json['show_promo_banner'] as bool? ?? false,
      promoBannerText: json['promo_banner_text'] as String? ?? '',
      maintenanceMode: json['maintenance_mode'] as bool? ?? false,
      showOffers: json['show_offers'] as bool? ?? true,
      offerTitle: json['offer_title'] as String? ?? '20% off your next trip',
      offerSubtitle:
          json['offer_subtitle'] as String? ??
          'Use code SPOTT20. Max discount ₹100.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show_promo_banner': showPromoBanner,
      'promo_banner_text': promoBannerText,
      'maintenance_mode': maintenanceMode,
      'show_offers': showOffers,
      'offer_title': offerTitle,
      'offer_subtitle': offerSubtitle,
    };
  }
}

/// A mock repository that simulates fetching remote config flags from a backend.
class RemoteConfigRepository extends ChangeNotifier {
  RemoteConfigState _currentState = const RemoteConfigState();

  RemoteConfigState get currentState => _currentState;

  /// Simulates fetching the latest config from the server.
  Future<void> fetchAndActivate() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock JSON response that would normally come from the server
    const mockJsonResponse = '''
    {
      "show_promo_banner": true,
      "promo_banner_text": "Get 20% off your next ride!",
      "maintenance_mode": false,
      "show_offers": true,
      "offer_title": "20% off your next trip",
      "offer_subtitle": "Use code SPOTT20. Max discount ₹100."
    }
    ''';

    try {
      final Map<String, dynamic> decoded = json.decode(mockJsonResponse);
      _currentState = RemoteConfigState.fromJson(decoded);
      notifyListeners();
    } catch (e) {
      // In a real app, we might log this and fallback to default values.
      debugPrint('Failed to parse remote config: $e');
    }
  }
}

class RemoteConfigScope extends InheritedNotifier<RemoteConfigRepository> {
  const RemoteConfigScope({
    super.key,
    required RemoteConfigRepository repository,
    required super.child,
  }) : super(notifier: repository);

  static RemoteConfigState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RemoteConfigScope>()!
        .notifier!
        .currentState;
  }
}

