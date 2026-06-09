import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../core/theme/colors.dart';
import '../models/ride_models.dart';
import '../spotter_widgets.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() =>
      _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  late final TextEditingController _pickupController;
  late final TextEditingController _destinationController;
  bool _seededPickup = false;

  static const List<LocationPoint> _suggestions = [
    LocationPoint(
      title: 'Select Citywalk Mall',
      detail:
          'Saket District Center, District Center, Sector 6, Pushp Vihar, New Delhi, Delhi 110017',
    ),
    LocationPoint(
      title: '5, Kullar Farms Rd',
      detail: 'New Manglapuri, Manglapuri Village, Sultanpur, New Delhi, Delhi',
    ),
    LocationPoint(
      title: 'DLF Promenade',
      detail: 'Vasant Kunj Road, New Delhi, Delhi 110070',
    ),
    LocationPoint(title: 'Home', detail: '123 Elm Street, Springfield'),
    LocationPoint(title: 'Work', detail: '456 Corporate Blvd, Suite 200'),
    LocationPoint(title: 'Gym', detail: '789 Iron Ave, Downtown'),
  ];

  @override
  void initState() {
    super.initState();
    _pickupController = TextEditingController();
    _destinationController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seededPickup) return;

    final ride = RideScope.of(context);
    _pickupController.text = ride.pickup.detail;
    _seededPickup = true;
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  IconData _getIconForPlace(String title) {
    switch (title.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'gym':
        return Icons.fitness_center_rounded;
      default:
        return Icons.history_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final destinationQuery = _destinationController.text.trim();
    final suggestions = _filteredSuggestions(destinationQuery);
    final scaffoldBg = isDark
        ? const Color(0xFF050505)
        : SpottColors.background;
    final textColor = isDark ? Colors.white : SpottColors.textPrimary;

    return Scaffold(
      backgroundColor: scaffoldBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        ),
                        icon: Icon(Icons.arrow_back, color: textColor),
                      ),
                      Expanded(
                        child: Text(
                          'Plan your ride',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        _FilterChip(
                          icon: Icons.access_time_filled_rounded,
                          label: 'Pick up now',
                          showChevron: true,
                          isDark: isDark,
                          onTap: () =>
                              _showMessage(context, 'Pickup time set to now'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          icon: Icons.trending_flat_rounded,
                          label: 'One way',
                          showChevron: true,
                          isDark: isDark,
                          onTap: () =>
                              _showMessage(context, 'One-way trip selected'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          icon: Icons.person_rounded,
                          label: 'For me',
                          isDark: isDark,
                          onTap: () =>
                              _showMessage(context, 'Booking for yourself'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LocationInputs(
                    pickupController: _pickupController,
                    destinationController: _destinationController,
                    onPickupSubmitted: (value) =>
                        _updatePickupFromInput(context, value),
                    onDestinationSubmitted: (value) =>
                        _selectDestinationFromInput(context, value),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 14),
                  _SavedPlacesTile(
                    onTap: () => _showSavedPlaces(context),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            // Custom cyber separator divider
            Container(
              width: double.infinity,
              height: 6,
              color: isDark ? const Color(0xFF121212) : const Color(0xFFF2F4F7),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                children: [
                  if (ride.actionState.isFailure)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RecoveryBanner(
                        state: ride.actionState,
                        onRetry: ride.retryInitialize,
                      ),
                    ),
                  if (destinationQuery.isNotEmpty)
                    _DestinationResultTile(
                      title: 'Use "$destinationQuery"',
                      detail: 'Set typed destination and estimate the fare',
                      icon: Icons.search_rounded,
                      isDark: isDark,
                      onTap: () => _selectDestinationFromInput(
                        context,
                        destinationQuery,
                      ),
                    ),
                  for (final suggestion in suggestions)
                    _DestinationResultTile(
                      title: suggestion.title,
                      detail: suggestion.detail,
                      isDark: isDark,
                      icon: _getIconForPlace(suggestion.title),
                      onTap: () {
                        _selectDestination(context, suggestion);
                      },
                    ),
                  if (destinationQuery.isNotEmpty && suggestions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Text(
                        'No saved matches yet. Use your typed destination above.',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF8E90A2)
                              : const Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildSetOnMapFooter(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSetOnMapFooter(BuildContext context, bool isDark) {
    final footerBg = isDark ? const Color(0xFF121212) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE2E8F0);
    final buttonBg = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF2F4F7);
    final textColor = isDark ? Colors.white : SpottColors.textPrimary;
    final iconColor = isDark ? Colors.white : SpottColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: footerBg,
        border: Border(top: BorderSide(color: borderColor, width: 1.0)),
      ),
      child: Material(
        color: buttonBg,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showMessage(context, 'Set location on map selected');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: isDark
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                      width: 1.0,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(Icons.map_rounded, color: iconColor),
                const SizedBox(width: 12),
                Text(
                  'Set on map',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: 'Inter',
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? const Color(0xFF8E90A2)
                      : const Color(0xFF98A2B3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  List<LocationPoint> _filteredSuggestions(String query) {
    if (query.isEmpty) return _suggestions;

    final lowerQuery = query.toLowerCase();
    return _suggestions
        .where((suggestion) {
          return suggestion.title.toLowerCase().contains(lowerQuery) ||
              suggestion.detail.toLowerCase().contains(lowerQuery);
        })
        .toList(growable: false);
  }

  void _updatePickupFromInput(BuildContext context, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;

    final ride = RideScope.of(context);
    ride.updatePickup(LocationPoint(title: trimmed, detail: trimmed));
    _showMessage(context, 'Pickup updated');
  }

  void _selectDestinationFromInput(BuildContext context, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      _showMessage(context, 'Enter a destination first');
      return;
    }

    final lowerValue = trimmed.toLowerCase();
    LocationPoint? match;
    for (final suggestion in _suggestions) {
      if (suggestion.title.toLowerCase() == lowerValue ||
          suggestion.detail.toLowerCase() == lowerValue) {
        match = suggestion;
        break;
      }
    }

    _selectDestination(
      context,
      match ?? LocationPoint(title: trimmed, detail: trimmed),
    );
  }

  void _selectDestination(BuildContext context, LocationPoint destination) {
    final ride = RideScope.of(context);
    ride.updateDestination(destination);
    Navigator.pushNamed(context, AppRoutes.fare);
  }

  void _showSavedPlaces(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : SpottColors.textPrimary;
    final subtitleColor = isDark
        ? const Color(0xFF8E90A2)
        : const Color(0xFF667085);
    final avatarBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF2F4F7);
    final iconColor = isDark ? Colors.white : SpottColors.textPrimary;
    final barrierColor = isDark
        ? Colors.black.withValues(alpha: 0.6)
        : Colors.black.withValues(alpha: 0.4);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: bgColor,
      barrierColor: barrierColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            color: Colors.transparent,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                Text(
                  'Saved places',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                for (final place in _suggestions.where(
                  (p) =>
                      p.title == 'Home' ||
                      p.title == 'Work' ||
                      p.title == 'Gym',
                ))
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: isDark
                          ? Border.all(
                              color: Colors.white.withValues(alpha: 0.06),
                              width: 1.0,
                            )
                          : null,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: avatarBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconForPlace(place.title),
                          color: iconColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        place.title,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Inter',
                        ),
                      ),
                      subtitle: Text(
                        place.detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        _selectDestination(context, place);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showChevron;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final chipBg = isDark ? const Color(0xFF1E293B) : SpottColors.surface2;
    final textColor = isDark ? Colors.white : SpottColors.textPrimary;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: BorderRadius.circular(999),
          border: isDark
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1.0,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: textColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: textColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LocationInputs extends StatelessWidget {
  final TextEditingController pickupController;
  final TextEditingController destinationController;
  final ValueChanged<String> onPickupSubmitted;
  final ValueChanged<String> onDestinationSubmitted;
  final bool isDark;

  const _LocationInputs({
    required this.pickupController,
    required this.destinationController,
    required this.onPickupSubmitted,
    required this.onDestinationSubmitted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF121212) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE2E8F0);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: Helper.premiumShadows,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 4),
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: SpottColors.textPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 1.5,
                  height: 48,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : const Color(0xFFD0D5DD),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: SpottColors.textPrimary,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                _FieldShell(
                  controller: pickupController,
                  hintText: 'Pickup location',
                  textInputAction: TextInputAction.next,
                  onSubmitted: onPickupSubmitted,
                  isDark: isDark,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : const Color(0xFFF2F4F7),
                    height: 1,
                  ),
                ),
                _FieldShell(
                  controller: destinationController,
                  hintText: 'Where to?',
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: onDestinationSubmitted,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldShell extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool autofocus;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;
  final bool isDark;

  const _FieldShell({
    required this.controller,
    required this.hintText,
    required this.textInputAction,
    required this.onSubmitted,
    required this.isDark,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final hintColor = isDark
        ? const Color(0xFF8E90A2)
        : const Color(0xFF667085);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        cursorColor: SpottColors.textPrimary,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 12,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear $hintText',
                  icon: Icon(Icons.close_rounded, size: 18, color: hintColor),
                  onPressed: controller.clear,
                ),
        ),
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

class _SavedPlacesTile extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _SavedPlacesTile({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFF2F4F7);
    final avatarBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF2F4F7);
    final iconColor = isDark ? Colors.white : SpottColors.textPrimary;
    final textColor = isDark ? Colors.white : SpottColors.textPrimary;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: borderColor),
            bottom: BorderSide(color: borderColor),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: avatarBg,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.star_rounded, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Saved places',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? const Color(0xFF8E90A2) : const Color(0xFF98A2B3),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationResultTile extends StatelessWidget {
  final String title;
  final String detail;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _DestinationResultTile({
    required this.title,
    required this.detail,
    required this.onTap,
    required this.isDark,
    this.icon = Icons.location_on_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final avatarBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF2F4F7);
    final iconColor = isDark ? Colors.white : SpottColors.textPrimary;
    final textColor = isDark ? Colors.white : SpottColors.textPrimary;
    final subtitleColor = isDark
        ? const Color(0xFF8E90A2)
        : const Color(0xFF667085);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: avatarBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
