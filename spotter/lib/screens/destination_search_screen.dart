import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_models.dart';
import '../design_system/design_system.dart';
import 'map_selector.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  late final TextEditingController _pickupController;
  late final TextEditingController _destinationController;
  late final FocusNode _pickupFocusNode;
  late final FocusNode _destinationFocusNode;

  double _sheetSize = 0.3; // Default min size
  bool _seededPickup = false;
  String _profileName = 'For me'; // Default profile selection
  String _activeSearchField = 'destination'; // 'pickup' or 'destination'

  @override
  void initState() {
    super.initState();
    _pickupController = TextEditingController();
    _destinationController = TextEditingController()..addListener(_onSearchChanged);
    _pickupFocusNode = FocusNode()..addListener(() {
      if (_pickupFocusNode.hasFocus) {
        setState(() => _activeSearchField = 'pickup');
      }
    });
    _destinationFocusNode = FocusNode()..addListener(() {
      if (_destinationFocusNode.hasFocus) {
        setState(() => _activeSearchField = 'destination');
      }
    });

    _sheetController.addListener(_onSheetSizeChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seededPickup) return;
    final ride = RideScope.of(context);
    _pickupController.text = ride.pickup.title;
    _seededPickup = true;
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetSizeChanged);
    _sheetController.dispose();
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocusNode.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  void _onSheetSizeChanged() {
    if (mounted) {
      setState(() {
        _sheetSize = _sheetController.size;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<LocationPoint> _filteredSuggestions(String query, RideController ride) {
    final suggestions = [
      const LocationPoint(
        title: 'Central Bus Stand',
        detail: 'Shahupuri, Kolhapur, Maharashtra 416001',
      ),
      const LocationPoint(
        title: 'Swargate Bus Stand',
        detail: 'Swargate, Pune, Maharashtra 411042',
      ),
      const LocationPoint(
        title: 'Select Citywalk Mall',
        detail: 'Saket District Center, District Center, Sector 6, Pushp Vihar, New Delhi, Delhi 110017',
      ),
      const LocationPoint(
        title: 'Kullar Farms Rd',
        detail: 'New Manglapuri, Manglapuri Village, Sultanpur, New Delhi, Delhi',
      ),
      const LocationPoint(
        title: 'DLF Promenade',
        detail: 'Vasant Kunj Road, New Delhi, Delhi 110070',
      ),
      ride.homeLocation,
      ride.workLocation,
      const LocationPoint(title: 'Gym', detail: 'Wagholi, Pune, Maharashtra'),
    ];
    if (query.isEmpty) return suggestions;
    return suggestions
        .where((s) =>
            s.title.toLowerCase().contains(query.toLowerCase()) ||
            s.detail.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _expandSheet() {
    _sheetController.animateTo(
      0.95,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _selectSuggestion(LocationPoint point, RideController ride) {
    if (point.title == 'Choose on map') {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final palette = isDark ? DSPalettes.dark : DSPalettes.light;
      showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => MapPickerSheet(
          isDark: isDark,
          palette: palette,
          title: _activeSearchField == 'pickup' ? 'Set Pickup Location' : 'Set Destination',
          onSelected: (loc) {
            Navigator.pop(context, loc);
          },
        ),
      ).then((result) {
        if (result != null && mounted) {
          final customPoint = LocationPoint(title: result, detail: 'Custom location');
          _selectSuggestion(customPoint, ride);
        }
      });
      return;
    }

    LocationPoint cleanPoint = point;
    if (point.detail == 'Set custom location') {
      final match = RegExp(r'^Use "(.+)"$').firstMatch(point.title);
      if (match != null) {
        cleanPoint = LocationPoint(
          title: match.group(1)!,
          detail: 'Custom location',
        );
      }
    }

    if (_activeSearchField == 'pickup') {
      _pickupController.text = cleanPoint.title;
      ride.updatePickup(cleanPoint);
      _destinationFocusNode.requestFocus();
    } else {
      _destinationController.text = cleanPoint.title;
      ride.updateDestination(cleanPoint);
      // Navigate to fare screen
      Navigator.pushNamed(context, AppRoutes.fare);
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // PROFILE SELECTOR (FOR ME) SHEET
  // ══════════════════════════════════════════════════════════════════
  final List<String> _customProfiles = [];

  void _showAddRiderDialog(BuildContext context, bool isDark, StateSetter setModalState) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Add Rider'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CupertinoTextField(
              controller: textController,
              placeholder: 'Rider Name',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () {
                final name = textController.text.trim();
                if (name.isNotEmpty) {
                  setModalState(() {
                    _customProfiles.add(name);
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _openProfileSelector(BuildContext context, bool isDark) {
    final bgCol = isDark ? const Color(0xFF121212) : Colors.white;
    final textCol = isDark ? Colors.white : Colors.black;

    String tempSelection = _profileName;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: bgCol,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 12),
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2B2B2B) : const Color(0xFFD1D5DB),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),

                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Choose who\'s riding',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textCol,
                          ),
                        ),
                      ),
                      const Divider(),

                      // Users List
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          children: [
                            _buildProfileRow('For me', 'Ritesh Mahatme (Me)', 'R', tempSelection, isDark, (val) {
                              setModalState(() => tempSelection = val);
                            }),
                            _buildProfileRow('Mom', 'Mom', 'M', tempSelection, isDark, (val) {
                              setModalState(() => tempSelection = val);
                            }),
                            _buildProfileRow('Dad', 'Dad', 'D', tempSelection, isDark, (val) {
                              setModalState(() => tempSelection = val);
                            }),
                            _buildProfileRow('Friend', 'Friend', 'F', tempSelection, isDark, (val) {
                              setModalState(() => tempSelection = val);
                            }),
                            ..._customProfiles.map((name) => _buildProfileRow(name, name, name.isNotEmpty ? name[0].toUpperCase() : 'U', tempSelection, isDark, (val) {
                              setModalState(() => tempSelection = val);
                            })),
                            const Divider(),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundColor: isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF6F6F6),
                                child: Icon(
                                  CupertinoIcons.add,
                                  color: isDark ? Colors.white : Colors.black,
                                  size: 16,
                                ),
                              ),
                              title: Text(
                                'Add a rider',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              onTap: () {
                                _showAddRiderDialog(context, isDark, setModalState);
                              },
                            ),
                          ],
                        ),
                      ),

                      // Done Button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: CupertinoButton(
                            color: isDark ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(26),
                            onPressed: () {
                              setState(() {
                                _profileName = tempSelection;
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildProfileRow(
    String id,
    String label,
    String initial,
    String currentSelection,
    bool isDark,
    ValueChanged<String> onChanged,
  ) {
    final rowCol = isDark ? Colors.white : Colors.black;

    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF6F6F6),
        child: Text(
          initial,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: rowCol,
          ),
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: rowCol,
        ),
      ),
      trailing: CupertinoRadio<String>(
        value: id,
        groupValue: currentSelection,
        activeColor: const Color(0xFF276EF1),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
      onTap: () => onChanged(id),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // BUILD METHOD
  // ══════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: [
          // Draggable scrollable sheet overlays the map
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.95,
            controller: _sheetController,
            snap: true,
            snapSizes: const [0.3, 0.95],
            builder: (context, scrollController) {
              final isMax = _sheetSize > 0.6;

              return Container(
                decoration: BoxDecoration(
                  color: palette.background, // Canvas
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(DSRadius.xl), // 16px
                    topRight: Radius.circular(DSRadius.xl),
                    bottomLeft: isMax ? Radius.zero : Radius.circular(DSRadius.xl),
                    bottomRight: isMax ? Radius.zero : Radius.circular(DSRadius.xl),
                  ),
                  border: Border.all(color: palette.divider, width: 1.0),
                  boxShadow: DSShadows.level2, // Level 2 Card Drop shadow
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    // Drag handle and core header/inputs content
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 12),
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: palette.border, // Surface Pressed
                                borderRadius: BorderRadius.circular(DSRadius.pill),
                              ),
                            ),
                          ),
                          // Content header based on height state
                          if (!isMax)
                            _buildMinContent(context, ride, palette)
                          else
                            _buildMaxHeader(context, ride, palette),
                        ],
                      ),
                    ),
                    
                    // Sticky Location Inputs
                    if (isMax)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverHeaderDelegate(
                          height: 145.0,
                          child: Container(
                            color: palette.background,
                            padding: const EdgeInsets.only(top: 8, bottom: 12),
                            child: _buildLocationInputs(context, ride, palette),
                          ),
                        ),
                      ),

                    // Suggestions list
                    if (isMax)
                      _buildSuggestionsSliverList(context, ride, palette),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // MIN STATE CONTENT (30% HEIGHT)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildMinContent(
    BuildContext context,
    RideController ride,
    DSColorPalette palette,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg), // 16px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Set your destination', // Sentence-case
            style: DSTypography.displaySM.copyWith(
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: DSSpacing.md),

          // Tappable "Where to?" trigger field
          GestureDetector(
            onTap: _expandSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: 14),
              decoration: BoxDecoration(
                color: palette.surfaceVariant, // Canvas Soft
                borderRadius: BorderRadius.circular(DSRadius.md), // 8px for form fields
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.search,
                    color: palette.iconSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: DSSpacing.md),
                  Text(
                    'Where to?', // Sentence-case
                    style: DSTypography.bodyMDStrong.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // MAX STATE CONTENT HEADER (95% HEIGHT)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildMaxHeader(
    BuildContext context,
    RideController ride,
    DSColorPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Back button and Plan Your Ride Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: 4),
          child: Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(36, 36),
                child: Icon(
                  CupertinoIcons.arrow_left,
                  color: palette.iconPrimary,
                  size: 22,
                ),
                onPressed: () {
                  // Collapse back to min state
                  _sheetController.animateTo(
                    0.3,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              Expanded(
                child: Text(
                  'Plan your ride', // Sentence-case
                  textAlign: TextAlign.center,
                  style: DSTypography.displaySM.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 36), // Balanced spacing
            ],
          ),
        ),

        // 2. "For me" profile selector dropdown - Pill shaped (999.0)
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: DSSpacing.lg, top: 4, bottom: 12),
            child: GestureDetector(
              onTap: () => _openProfileSelector(context, palette.isDark),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.surfaceVariant, // Canvas Soft
                  borderRadius: BorderRadius.circular(DSRadius.pill), // 999px
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.person_fill,
                      size: 14,
                      color: palette.iconPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _profileName == 'For me' ? 'For me' : 'For $_profileName',
                      style: DSTypography.bodySMStrong.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.chevron_down,
                      size: 10,
                      color: palette.iconPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // LOCATION INPUTS (STICKY)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildLocationInputs(
    BuildContext context,
    RideController ride,
    DSColorPalette palette,
  ) {
    final isPickupFocused = _pickupFocusNode.hasFocus;
    final isDestinationFocused = _destinationFocusNode.hasFocus;
    final isAnyFocused = isPickupFocused || isDestinationFocused;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAnyFocused ? palette.surface : palette.surfaceVariant, // Canvas or Canvas Soft
          borderRadius: BorderRadius.circular(DSRadius.xl), // 16px
          border: Border.all(
            color: isAnyFocused ? palette.primary : Colors.transparent,
            width: 1.0,
          ),
          boxShadow: isAnyFocused
              ? (palette.isDark
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : DSShadows.level2)
              : [],
        ),
        child: Row(
          children: [
            // Visual indicators (Circle and Square connected by line)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: palette.iconPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: palette.divider,
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: palette.iconPrimary,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),

            // Text fields
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pickup (From) input
                  TextField(
                    controller: _pickupController,
                    focusNode: _pickupFocusNode,
                    textInputAction: TextInputAction.next,
                    cursorColor: palette.textPrimary,
                    style: DSTypography.bodyMDStrong.copyWith(
                      color: palette.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'From?',
                      hintStyle: DSTypography.bodyMD.copyWith(
                        color: palette.textSecondary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      suffixIcon: _pickupController.text.isEmpty
                          ? null
                          : CupertinoButton(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              child: Icon(CupertinoIcons.clear_circled_solid, size: 16, color: palette.isDark ? Colors.white54 : Colors.black45),
                              onPressed: () {
                                _pickupController.clear();
                                setState(() {});
                              },
                            ),
                    ),
                  ),
                  Divider(color: palette.divider, height: 1),

                  // Destination (Where) input
                  TextField(
                    controller: _destinationController,
                    focusNode: _destinationFocusNode,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    cursorColor: palette.textPrimary,
                    style: DSTypography.bodyMDStrong.copyWith(
                      color: palette.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Where?',
                      hintStyle: DSTypography.bodyMD.copyWith(
                        color: palette.textSecondary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      suffixIcon: _destinationController.text.isEmpty
                          ? null
                          : CupertinoButton(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              child: Icon(CupertinoIcons.clear_circled_solid, size: 16, color: palette.isDark ? Colors.white54 : Colors.black45),
                              onPressed: () {
                                _destinationController.clear();
                                setState(() {});
                              },
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


  // ══════════════════════════════════════════════════════════════════
  // MAX STATE CONTENT SUGGESTIONS LIST (95% HEIGHT)
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSuggestionsSliverList(
    BuildContext context,
    RideController ride,
    DSColorPalette palette,
  ) {
    final activeQuery = _activeSearchField == 'pickup'
        ? _pickupController.text.trim()
        : _destinationController.text.trim();
    
    final List<LocationPoint> suggestionsList = [];
    suggestionsList.add(const LocationPoint(
      title: 'Choose on map',
      detail: 'Set location using interactive map',
    ));
    if (activeQuery.isNotEmpty) {
      suggestionsList.add(LocationPoint(
        title: 'Use "$activeQuery"',
        detail: 'Set custom location',
      ));
    }
    suggestionsList.addAll(_filteredSuggestions(activeQuery, ride));

    return SliverPadding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final suggestion = suggestionsList[index];
            return _buildSuggestionTile(suggestion, ride, palette);
          },
          childCount: suggestionsList.length,
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(LocationPoint point, RideController ride, DSColorPalette palette) {
    IconData iconData = CupertinoIcons.clock_fill;
    final titleLower = point.title.toLowerCase();
    if (titleLower == 'choose on map') {
      iconData = CupertinoIcons.map;
    } else if (titleLower.contains('bus')) {
      iconData = CupertinoIcons.bus;
    } else if (titleLower.contains('home')) {
      iconData = CupertinoIcons.house_fill;
    } else if (titleLower.contains('work') || titleLower.contains('office')) {
      iconData = CupertinoIcons.briefcase_fill;
    }

    return InkWell(
      onTap: () => _selectSuggestion(point, ride),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: palette.divider, width: 1.0)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: palette.surfaceVariant, // Canvas Soft
              child: Icon(
                iconData,
                color: palette.iconPrimary,
                size: 14,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.title,
                    style: DSTypography.bodyMDStrong.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    point.detail,
                    style: DSTypography.bodySM.copyWith(
                      color: palette.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: palette.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _SliverHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Align(
      alignment: Alignment.topCenter,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

