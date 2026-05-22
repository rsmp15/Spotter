import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
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

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final destinationQuery = _destinationController.text.trim();
    final suggestions = _filteredSuggestions(destinationQuery);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back, color: Helper.ink),
                      ),
                      const Expanded(
                        child: Text(
                          'Plan your ride',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Helper.ink,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        _FilterChip(
                          icon: Icons.access_time_filled_rounded,
                          label: 'Pick up now',
                          showChevron: true,
                          onTap: () =>
                              _showMessage(context, 'Pickup time set to now'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          icon: Icons.trending_flat_rounded,
                          label: 'One way',
                          showChevron: true,
                          onTap: () =>
                              _showMessage(context, 'One-way trip selected'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          icon: Icons.person_rounded,
                          label: 'For me',
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
                  ),
                  const SizedBox(height: 14),
                  _SavedPlacesTile(onTap: () => _showSavedPlaces(context)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                      onTap: () => _selectDestinationFromInput(
                        context,
                        destinationQuery,
                      ),
                    ),
                  for (final suggestion in suggestions)
                    _DestinationResultTile(
                      title: suggestion.title,
                      detail: suggestion.detail,
                      onTap: () {
                        _selectDestination(context, suggestion);
                      },
                    ),
                  if (destinationQuery.isNotEmpty && suggestions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Text(
                        'No saved matches yet. Use your typed destination above.',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
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
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              const Text(
                'Saved places',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              for (final place in _suggestions.take(2))
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF667085),
                    child: Icon(Icons.star_rounded, color: Colors.white),
                  ),
                  title: Text(place.title),
                  subtitle: Text(
                    place.detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _selectDestination(context, place);
                  },
                ),
            ],
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

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Helper.ink),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Helper.ink,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Helper.ink,
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

  const _LocationInputs({
    required this.pickupController,
    required this.destinationController,
    required this.onPickupSubmitted,
    required this.onDestinationSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF98A2B3),
                  shape: BoxShape.circle,
                ),
              ),
              Container(width: 1, height: 38, color: const Color(0xFFD0D5DD)),
              Container(width: 8, height: 8, color: Helper.ink),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            children: [
              _FieldShell(
                controller: pickupController,
                hintText: 'Pickup location',
                textInputAction: TextInputAction.next,
                onSubmitted: onPickupSubmitted,
              ),
              const SizedBox(height: 8),
              _FieldShell(
                controller: destinationController,
                hintText: 'Where to?',
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: onDestinationSubmitted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldShell extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool autofocus;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;

  const _FieldShell({
    required this.controller,
    required this.hintText,
    required this.textInputAction,
    required this.onSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear $hintText',
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: controller.clear,
                ),
        ),
        style: const TextStyle(
          color: Color(0xFF475467),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SavedPlacesTile extends StatelessWidget {
  final VoidCallback onTap;

  const _SavedPlacesTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFF2F4F7)),
            bottom: BorderSide(color: Color(0xFFF2F4F7)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF667085),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded, color: Colors.white),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Saved places',
                style: TextStyle(
                  color: Helper.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF98A2B3),
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

  const _DestinationResultTile({
    required this.title,
    required this.detail,
    required this.onTap,
    this.icon = Icons.location_on_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
                decoration: const BoxDecoration(
                  color: Color(0xFF667085),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Helper.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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
