import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../design_system/design_system.dart';
import '../controllers/ride_controller.dart';
import 'map_selector.dart';

class RiderPublishForm extends StatefulWidget {
  final RideController ride;
  final DSColorPalette palette;

  const RiderPublishForm({
    super.key,
    required this.ride,
    required this.palette,
  });

  @override
  State<RiderPublishForm> createState() => _RiderPublishFormState();
}

class _RiderPublishFormState extends State<RiderPublishForm> {
  final TextEditingController _destinationController = TextEditingController();
  int _availableSeats = 2;
  DateTime? _selectedDateTime;
  String _startLocation = 'Current Location';
  String _destinationLocation = '';

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.ride;
    final palette = widget.palette;
    final isDark = ride.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Less internal padding
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: palette.divider, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Offer a Carpool Ride',
            style: DSTypography.displaySM.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Unified Location Selector Stacked Card
          _buildUnifiedLocationBlock(context, isDark, palette),
          const SizedBox(height: 20),

          Row(
            children: [
              // Departure Button
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => _UberTimePickerSheet(
                        initialDateTime: _selectedDateTime ?? DateTime.now(),
                        isDark: isDark,
                        palette: palette,
                        onConfirm: (dateTime) {
                          setState(() {
                            _selectedDateTime = dateTime;
                          });
                        },
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: palette.background,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: palette.divider, width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDateTime == null
                                ? 'Departure'
                                : '${_selectedDateTime!.day}/${_selectedDateTime!.month} at ${TimeOfDay.fromDateTime(_selectedDateTime!).format(context)}',
                            style: DSTypography.bodyMD.copyWith(
                              color: _selectedDateTime == null ? palette.textSecondary : palette.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(CupertinoIcons.calendar, color: palette.iconPrimary, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Seats Button
              Expanded(
                child: InkWell(
                  onTap: () {
                    _showChooseSeatsSheet(
                      context: context,
                      isDark: isDark,
                      palette: palette,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: palette.background,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: palette.divider, width: 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '$_availableSeats ${_availableSeats == 1 ? 'Seat' : 'Seats'}',
                            style: DSTypography.bodyMD.copyWith(color: palette.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.event_seat_rounded, color: palette.iconPrimary, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Publish CTA
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onPressed: () {
                if (_destinationController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a destination')),
                  );
                  return;
                }
                if (_selectedDateTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select departure date & time')),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ride published successfully!')),
                );
                // Reset form state & toggle mode back
                _destinationController.clear();
                setState(() {
                  _selectedDateTime = null;
                  _availableSeats = 2;
                  _startLocation = 'Current Location';
                  _destinationLocation = '';
                });
                ride.toggleRiderMode();
              },
              child: Text(
                'Publish Route',
                style: DSTypography.bodyMDStrong.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedLocationBlock(BuildContext context, bool isDark, DSColorPalette palette) {
    final startVal = _startLocation;
    final destVal = _destinationLocation.isEmpty ? 'Enter destination...' : _destinationLocation;
    final isDestSelected = _destinationLocation.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Left Side: Uber-style Connecting Line and Indicators
            Column(
              children: [
                // Start dot (Teal/Primary)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isDark ? palette.primary : const Color(0xFF14262A),
                    shape: BoxShape.circle,
                  ),
                ),
                // Connecting line
                Container(
                  width: 1.5,
                  height: 38,
                  color: palette.divider,
                ),
                // End square (Teal/Primary)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isDark ? palette.primary : const Color(0xFF14262A),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Middle: Tappable location fields
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Start Location Select
                  InkWell(
                    onTap: () {
                      _showLocationSelectSheet(
                        context: context,
                        isDark: isDark,
                        palette: palette,
                        title: 'Select Start Location',
                        initialValue: _startLocation,
                        onSelected: (val) {
                          setState(() {
                            _startLocation = val;
                          });
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              startVal,
                              style: DSTypography.bodyMDStrong.copyWith(
                                color: palette.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Divider
                  Divider(color: palette.divider, height: 1, thickness: 1),
                  
                  // Destination Select
                  InkWell(
                    onTap: () {
                      _showLocationSelectSheet(
                        context: context,
                        isDark: isDark,
                        palette: palette,
                        title: 'Select Destination',
                        initialValue: _destinationLocation,
                        onSelected: (val) {
                          setState(() {
                            _destinationLocation = val;
                            _destinationController.text = val;
                          });
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              destVal,
                              style: DSTypography.bodyMD.copyWith(
                                color: isDestSelected ? palette.textPrimary : palette.textSecondary,
                                fontWeight: isDestSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Right Side: Swap Button
            GestureDetector(
              onTap: () {
                if (_destinationLocation.isNotEmpty) {
                  setState(() {
                    final temp = _startLocation;
                    _startLocation = _destinationLocation;
                    _destinationLocation = temp;
                    _destinationController.text = _destinationLocation;
                  });
                }
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark ? palette.surfaceVariant : const Color(0xFFEDE2E6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.swap_vert,
                  color: palette.iconPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSelectSheet({
    required BuildContext context,
    required bool isDark,
    required DSColorPalette palette,
    required String title,
    required String initialValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationSelectSheet(
        title: title,
        initialValue: initialValue,
        isDark: isDark,
        palette: palette,
        onSelected: onSelected,
      ),
    );
  }

  void _showChooseSeatsSheet({
    required BuildContext context,
    required bool isDark,
    required DSColorPalette palette,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChooseSeatsSheet(
        initialSeats: _availableSeats,
        isDark: isDark,
        palette: palette,
        onSave: (seats) {
          setState(() {
            _availableSeats = seats;
          });
        },
      ),
    );
  }
}

class _ChooseSeatsSheet extends StatefulWidget {
  final int initialSeats;
  final bool isDark;
  final DSColorPalette palette;
  final ValueChanged<int> onSave;

  const _ChooseSeatsSheet({
    required this.initialSeats,
    required this.isDark,
    required this.palette,
    required this.onSave,
  });

  @override
  State<_ChooseSeatsSheet> createState() => _ChooseSeatsSheetState();
}

class _ChooseSeatsSheetState extends State<_ChooseSeatsSheet> {
  late int _seats;

  @override
  void initState() {
    super.initState();
    _seats = widget.initialSeats;
  }

  @override
  Widget build(BuildContext context) {
    final themeBg = widget.isDark ? widget.palette.surface : const Color(0xFFFFFFFF);
    final buttonFill = widget.isDark ? widget.palette.surfaceVariant : const Color(0xFFF3F0F2);
    final saveButtonBg = widget.isDark ? widget.palette.primary : const Color(0xFF000000);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: themeBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: widget.palette.textMuted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Sheet Title
          Text(
            'Choose seats',
            style: DSTypography.displaySM.copyWith(
              color: widget.palette.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),

          // Selector Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of seats',
                      style: DSTypography.bodyLG.copyWith(
                        color: widget.palette.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Max 4 seats per carpool',
                      style: DSTypography.caption.copyWith(color: widget.palette.textSecondary),
                    ),
                  ],
                ),
              ),
              // Right: Minus, Count, Plus buttons
              Row(
                children: [
                  // Minus Button
                  GestureDetector(
                    onTap: _seats > 1
                        ? () => setState(() => _seats--)
                        : null,
                    child: Opacity(
                      opacity: _seats > 1 ? 1.0 : 0.4,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: buttonFill,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.minus,
                          color: widget.palette.textPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  
                  // Count Text
                  Container(
                    width: 36,
                    alignment: Alignment.center,
                    child: Text(
                      '$_seats',
                      style: DSTypography.bodyLG.copyWith(
                        color: widget.palette.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  
                  // Plus Button
                  GestureDetector(
                    onTap: _seats < 4
                        ? () => setState(() => _seats++)
                        : null,
                    child: Opacity(
                      opacity: _seats < 4 ? 1.0 : 0.4,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: buttonFill,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          color: widget.palette.textPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Info text below
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Children of all ages require a seat in the vehicle.',
              style: DSTypography.caption.copyWith(color: widget.palette.textSecondary),
            ),
          ),
          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: saveButtonBg,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 0,
              ),
              onPressed: () {
                widget.onSave(_seats);
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: DSTypography.bodyMDStrong.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Cancel Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: DSTypography.bodyMDStrong.copyWith(
                  color: widget.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _LocationSelectSheet extends StatefulWidget {
  final String title;
  final String initialValue;
  final bool isDark;
  final DSColorPalette palette;
  final ValueChanged<String> onSelected;

  const _LocationSelectSheet({
    required this.title,
    required this.initialValue,
    required this.isDark,
    required this.palette,
    required this.onSelected,
  });

  @override
  State<_LocationSelectSheet> createState() => _LocationSelectSheetState();
}

class _LocationSelectSheetState extends State<_LocationSelectSheet> {
  late final TextEditingController _searchController;
  final List<String> _presets = [
    'Current Location',
    'Central Bus Stand, Kolhapur',
    'Swargate Bus Stand, Pune',
    'Select Citywalk Mall, New Delhi',
    'Kullar Farms Rd, New Delhi',
    'DLF Promenade, New Delhi',
    'Indira Gandhi International Airport, Delhi',
    'Connaught Place, New Delhi',
  ];
  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filtered = List.from(_presets);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = List.from(_presets);
      } else {
        _filtered = _presets
            .where((loc) => loc.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasCustomQuery = _searchController.text.trim().isNotEmpty &&
        !_filtered.any((loc) => loc.toLowerCase() == _searchController.text.trim().toLowerCase());

    final themeBg = widget.isDark ? widget.palette.surface : const Color(0xFFFFFFFF);
    final listThemeBg = widget.isDark ? widget.palette.surface : const Color(0xFFFFFFFF);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: themeBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: widget.palette.textMuted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            widget.title,
            style: DSTypography.bodyLG.copyWith(
              color: widget.palette.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: TextStyle(color: widget.palette.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search location...',
                hintStyle: TextStyle(color: widget.palette.textSecondary),
                filled: true,
                fillColor: widget.isDark ? widget.palette.surfaceVariant : const Color(0xFFF3F0F2),
                prefixIcon: Icon(CupertinoIcons.search, color: widget.palette.iconPrimary, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () => _searchController.clear(),
                        child: Icon(CupertinoIcons.clear_circled_solid, color: widget.palette.textMuted),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Divider
          Divider(color: widget.palette.divider, height: 1),
          // Suggestions list
          Expanded(
            child: Material(
              color: listThemeBg,
              child: ListView.separated(
                itemCount: _filtered.length + (hasCustomQuery ? 1 : 0) + 1,
                separatorBuilder: (context, index) => Divider(
                  color: widget.palette.divider.withValues(alpha: 0.5),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  // Index 0 is always "Choose on map"
                  if (index == 0) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: widget.palette.divider,
                        radius: 16,
                        child: Icon(
                          CupertinoIcons.map,
                          color: widget.palette.iconPrimary,
                          size: 16,
                        ),
                      ),
                      title: Text(
                        'Choose on map',
                        style: DSTypography.bodyMDStrong.copyWith(color: widget.palette.textPrimary),
                      ),
                      onTap: () {
                        showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => MapPickerSheet(
                            isDark: widget.isDark,
                            palette: widget.palette,
                            onSelected: (loc) {
                              Navigator.pop(context, loc);
                            },
                          ),
                        ).then((result) {
                          if (result == null) return;
                          if (!mounted) return;
                          widget.onSelected(result);
                          Navigator.pop(context);
                        });
                      },
                    );
                  }

                  final listIndex = index - 1;

                  // If custom query is not in list, add a "Use custom location" item
                  if (hasCustomQuery && listIndex == 0) {
                    final customText = _searchController.text.trim();
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: widget.isDark ? widget.palette.primary : const Color(0xFF14262A),
                        radius: 16,
                        child: const Icon(CupertinoIcons.location_solid, color: Colors.white, size: 16),
                      ),
                      title: Text(
                        'Use "$customText"',
                        style: DSTypography.bodyMDStrong.copyWith(color: widget.palette.textPrimary),
                      ),
                      subtitle: Text(
                        'Select arbitrary typed location',
                        style: DSTypography.caption.copyWith(color: widget.palette.textSecondary),
                      ),
                      onTap: () {
                        widget.onSelected(customText);
                        Navigator.pop(context);
                      },
                    );
                  }

                  final actualIndex = hasCustomQuery ? listIndex - 1 : listIndex;
                  final location = _filtered[actualIndex];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: widget.palette.divider,
                      radius: 16,
                      child: Icon(
                        location == 'Current Location'
                            ? CupertinoIcons.location_solid
                            : CupertinoIcons.map_pin_ellipse,
                        color: location == 'Current Location'
                            ? (widget.isDark ? widget.palette.primary : const Color(0xFF14262A))
                            : widget.palette.iconPrimary,
                        size: 16,
                      ),
                    ),
                    title: Text(
                      location,
                      style: DSTypography.bodyMD.copyWith(
                        color: widget.palette.textPrimary,
                        fontWeight: location == widget.initialValue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      widget.onSelected(location);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UberTimePickerSheet extends StatefulWidget {
  final DateTime initialDateTime;
  final bool isDark;
  final DSColorPalette palette;
  final ValueChanged<DateTime> onConfirm;

  const _UberTimePickerSheet({
    required this.initialDateTime,
    required this.isDark,
    required this.palette,
    required this.onConfirm,
  });

  @override
  State<_UberTimePickerSheet> createState() => _UberTimePickerSheetState();
}

class _UberTimePickerSheetState extends State<_UberTimePickerSheet> {
  late DateTime _selectedDateTime;
  bool _isPickupSelected = true;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final isDark = widget.isDark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E352F) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: palette.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Back/Close Icon and Title
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  CupertinoIcons.arrow_left,
                  color: palette.textPrimary,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'Choose a time',
            style: DSTypography.displayMD.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 32,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 20),

          // Toggle: Pickup at / Dropoff by
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? palette.surface : const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isPickupSelected = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isPickupSelected
                            ? (isDark ? palette.primary : Colors.black)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          'Pickup at',
                          style: DSTypography.bodyMDStrong.copyWith(
                            color: _isPickupSelected
                                ? Colors.white
                                : palette.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isPickupSelected = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isPickupSelected
                            ? (isDark ? palette.primary : Colors.black)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          'Dropoff by',
                          style: DSTypography.bodyMDStrong.copyWith(
                            color: !_isPickupSelected
                                ? Colors.white
                                : palette.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // DateTime Picker scroll wheels mock
          Expanded(
            child: Row(
              children: [
                // Date column
                Expanded(
                  flex: 3,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 44,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      final newDate = DateTime.now().add(Duration(days: index));
                      setState(() {
                        _selectedDateTime = DateTime(
                          newDate.year,
                          newDate.month,
                          newDate.day,
                          _selectedDateTime.hour,
                          _selectedDateTime.minute,
                        );
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index));
                        final isToday = index == 0;
                        final label = isToday
                            ? 'Today, ${date.day} ${_monthName(date.month)}'
                            : '${_dayName(date.weekday)}, ${date.day} ${_monthName(date.month)}';
                        return Center(
                          child: Text(
                            label,
                            style: DSTypography.bodyLG.copyWith(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                      childCount: 30,
                    ),
                  ),
                ),
                // Time column
                Expanded(
                  flex: 2,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 44,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      final hour = index ~/ 12;
                      final minute = (index % 12) * 5;
                      setState(() {
                        _selectedDateTime = DateTime(
                          _selectedDateTime.year,
                          _selectedDateTime.month,
                          _selectedDateTime.day,
                          hour,
                          minute,
                        );
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final hour = index ~/ 12;
                        final minute = (index % 12) * 5;
                        final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
                        final amPm = hour >= 12 ? 'PM' : 'AM';
                        final minuteStr = minute < 10 ? '0$minute' : '$minute';
                        final label = '$displayHour:$minuteStr $amPm';
                        return Center(
                          child: Text(
                            label,
                            style: DSTypography.bodyLG.copyWith(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                      childCount: 288, // 24 hours * 12 intervals of 5 minutes
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Cancellation details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? palette.surfaceVariant : const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  CupertinoIcons.info_circle_fill,
                  color: palette.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flexible scheduling reservation policy',
                        style: DSTypography.bodySMStrong.copyWith(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cancel for free up to 1 hour before pickup. A reservation fee applies if cancelled within 1 hour.',
                        style: DSTypography.caption.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Continue button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? palette.primary : Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 0,
              ),
              onPressed: () {
                widget.onConfirm(_selectedDateTime);
                Navigator.pop(context);
              },
              child: Text(
                'Continue',
                style: DSTypography.bodyMDStrong.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  String _monthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }
}
