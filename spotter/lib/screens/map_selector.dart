import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../design_system/design_system.dart';

class MapPickerSheet extends StatefulWidget {
  final bool isDark;
  final DSColorPalette palette;
  final String title;
  final ValueChanged<String> onSelected;

  const MapPickerSheet({
    super.key,
    required this.isDark,
    required this.palette,
    this.title = 'Choose on Map',
    required this.onSelected,
  });

  @override
  State<MapPickerSheet> createState() => _MapPickerSheetState();
}

class _MapPickerSheetState extends State<MapPickerSheet> {
  final MapController _mapController = MapController();
  ll.LatLng _center = const ll.LatLng(18.5204, 73.8567); // Default to Pune
  String _addressTitle = 'Pin Location';
  String _addressSubtitle = 'Drag map to choose location';
  bool _isDragging = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _updateAddress(ll.LatLng pos) {
    final lat = pos.latitude;
    final lng = pos.longitude;
    
    // Check if close to Pune presets
    if ((lat - 18.5204).abs() < 0.01 && (lng - 73.8567).abs() < 0.01) {
      setState(() {
        _addressTitle = 'Swargate Bus Stand';
        _addressSubtitle = 'Swargate, Pune, Maharashtra';
      });
    } else if ((lat - 16.7050).abs() < 0.01 && (lng - 74.2433).abs() < 0.01) {
      setState(() {
        _addressTitle = 'Central Bus Stand';
        _addressSubtitle = 'Shahupuri, Kolhapur, Maharashtra';
      });
    } else {
      // General coordinate-based label
      final sector = ((lat * 100).floor() % 5) + 1;
      final street = ((lng * 100).floor() % 8) + 1;
      setState(() {
        _addressTitle = 'Street $street, Sector $sector';
        _addressSubtitle = 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(5)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final isDark = widget.isDark;
    final tileUrl = isDark
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
        : 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? palette.surface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: Stack(
          children: [
            // Map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 15.0,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                onPositionChanged: (position, hasGesture) {
                  if (position.center != null) {
                    setState(() {
                      _center = position.center!;
                    });
                    _updateAddress(position.center!);
                  }
                },
                onMapEvent: (event) {
                  if (event is MapEventMoveStart) {
                    setState(() {
                      _isDragging = true;
                    });
                  } else if (event is MapEventMoveEnd) {
                    setState(() {
                      _isDragging = false;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: tileUrl,
                  userAgentPackageName: 'com.spotter.app',
                ),
              ],
            ),

            // Header Overlay
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? palette.surface.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(CupertinoIcons.clear, color: palette.textPrimary, size: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? palette.surface.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.title,
                      style: DSTypography.bodyMDStrong.copyWith(color: palette.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 36), // Spacer to balance the close button
                ],
              ),
            ),

            // Center Pin Indicator
            Center(
              child: FractionalTranslation(
                translation: const Offset(0.0, -0.5),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  transform: Matrix4.translationValues(0, _isDragging ? -10 : 0, 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Shadow/Dot on the ground
                      Positioned(
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: _isDragging ? 8 : 14,
                          height: _isDragging ? 4 : 7,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Pin itself
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Icon(
                          CupertinoIcons.location_solid,
                          color: isDark ? palette.primary : const Color(0xFF14262A),
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Address Panel
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? palette.surface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isDark ? palette.surfaceVariant : const Color(0xFFF3F0F2),
                          radius: 18,
                          child: Icon(
                            CupertinoIcons.map_pin_ellipse,
                            color: isDark ? palette.primary : const Color(0xFF14262A),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _addressTitle,
                                style: DSTypography.bodyMDStrong.copyWith(color: palette.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _addressSubtitle,
                                style: DSTypography.caption.copyWith(color: palette.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? palette.primary : const Color(0xFF14262A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          widget.onSelected(_addressTitle);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Confirm Location',
                          style: DSTypography.bodyMDStrong.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
