import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/radius.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PREMIUM DATE PICKER BOTTOM SHEET
// ══════════════════════════════════════════════════════════════════════════════

/// A production-quality calendar picker presented as an animated bottom sheet.
/// Uses SpottColors design system and features smooth animated month transitions.
class PremiumDatePickerBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Color? primaryColor;

  const PremiumDatePickerBottomSheet({
    super.key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
    this.primaryColor,
  });

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    Color? primaryColor,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      useSafeArea: true,
      builder: (context) => PremiumDatePickerBottomSheet(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        primaryColor: primaryColor,
      ),
    );
  }

  @override
  State<PremiumDatePickerBottomSheet> createState() =>
      _PremiumDatePickerBottomSheetState();
}

class _PremiumDatePickerBottomSheetState
    extends State<PremiumDatePickerBottomSheet>
    with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  late DateTime _today;
  late Color _primaryColor;

  // For animated month transitions
  late AnimationController _monthAnimController;
  late Animation<double> _monthFadeAnim;
  late Animation<Offset> _monthSlideAnim;
  bool _isForward = true;

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDate = _stripTime(widget.initialDate);
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _primaryColor = widget.primaryColor ?? SpottColors.primary;

    _monthAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _monthFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _monthAnimController, curve: Curves.easeOut),
    );
    _monthSlideAnim = Tween<Offset>(
      begin: const Offset(0.25, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _monthAnimController, curve: Curves.easeOut),
    );
    _monthAnimController.value = 1.0;
  }

  @override
  void dispose() {
    _monthAnimController.dispose();
    super.dispose();
  }

  DateTime _stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  int _daysInMonth(DateTime date) {
    final next = date.month < 12
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    return next.difference(DateTime(date.year, date.month, 1)).inDays;
  }

  void _selectDate(DateTime date) {
    HapticFeedback.lightImpact();
    setState(() => _selectedDate = date);
  }

  Future<void> _changeMonth(int delta) async {
    HapticFeedback.selectionClick();
    _isForward = delta > 0;
    _monthSlideAnim = Tween<Offset>(
      begin: Offset(_isForward ? 0.25 : -0.25, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _monthAnimController, curve: Curves.easeOut),
    );
    _monthAnimController.reset();

    int m = _displayedMonth.month + delta;
    int y = _displayedMonth.year;
    if (m > 12) { m = 1; y++; }
    if (m < 1) { m = 12; y--; }

    setState(() {
      _displayedMonth = DateTime(y, m, 1);
    });
    await _monthAnimController.forward();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isDisabled(DateTime day) {
    final first = widget.firstDate != null ? _stripTime(widget.firstDate!) : _today;
    if (day.isBefore(first) && !_isSameDay(day, first)) return true;
    if (widget.lastDate != null) {
      final last = _stripTime(widget.lastDate!);
      if (day.isAfter(last) && !_isSameDay(day, last)) return true;
    }
    return false;
  }

  bool _canGoBack() {
    final firstMonth = widget.firstDate != null
        ? DateTime(widget.firstDate!.year, widget.firstDate!.month, 1)
        : DateTime(_today.year, _today.month, 1);
    return _displayedMonth.isAfter(firstMonth);
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: safeBottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 16),
          _buildPresets(),
          const SizedBox(height: 20),
          _buildMonthNav(),
          const SizedBox(height: 12),
          _buildWeekdayLabels(),
          const SizedBox(height: 8),
          _buildCalendarGrid(),
          const SizedBox(height: 24),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: SpottColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final formatted = _formatSelectedDate();
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(SpottRadius.md),
          ),
          child: Icon(Icons.calendar_month_rounded, color: _primaryColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Travel Date',
                style: SpottTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SpottColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatted,
                style: SpottTextStyles.caption.copyWith(
                  color: _primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, size: 20),
          color: SpottColors.textSecondary,
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: SpottColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SpottRadius.sm),
            ),
          ),
        ),
      ],
    );
  }

  String _formatSelectedDate() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = days[_selectedDate.weekday - 1];
    final month = _months[_selectedDate.month - 1].substring(0, 3);
    return '$weekday, $month ${_selectedDate.day}, ${_selectedDate.year}';
  }

  Widget _buildPresets() {
    final presets = [
      ('Today', _today),
      ('Tomorrow', _today.add(const Duration(days: 1))),
      (
        'Next Sat',
        _today.add(Duration(
          days: ((6 - _today.weekday) % 7).clamp(1, 7),
        ))
      ),
      (
        'Next Sun',
        _today.add(Duration(
          days: ((7 - _today.weekday) % 7).clamp(1, 7),
        ))
      ),
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: presets.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final label = presets[i].$1;
          final date = presets[i].$2;
          final isSelected = _isSameDay(_selectedDate, date);

          return GestureDetector(
            onTap: () {
              _selectDate(date);
              // Jump to that month if needed
              if (date.month != _displayedMonth.month ||
                  date.year != _displayedMonth.year) {
                final delta = (date.year - _displayedMonth.year) * 12 +
                    (date.month - _displayedMonth.month);
                _changeMonth(delta);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _primaryColor : SpottColors.surface2,
                borderRadius: BorderRadius.circular(SpottRadius.pill),
                border: Border.all(
                  color: isSelected
                      ? _primaryColor
                      : SpottColors.border,
                  width: 1,
                ),
              ),
              child: Text(
                label,
                style: SpottTextStyles.caption.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : SpottColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthNav() {
    return Row(
      children: [
        Text(
          '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
          style: SpottTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: SpottColors.textPrimary,
          ),
        ),
        const Spacer(),
        _NavButton(
          icon: Icons.chevron_left_rounded,
          enabled: _canGoBack(),
          onTap: () => _changeMonth(-1),
          primaryColor: _primaryColor,
        ),
        const SizedBox(width: 4),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          enabled: true,
          onTap: () => _changeMonth(1),
          primaryColor: _primaryColor,
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _weekdays
          .map((d) => SizedBox(
                width: 40,
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: SpottTextStyles.overline.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: SpottColors.textTertiary,
                    letterSpacing: 0.2,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstWeekday = _displayedMonth.weekday; // 1 = Mon, 7 = Sun
    final totalDays = _daysInMonth(_displayedMonth);
    final leadingCells = firstWeekday - 1;

    return FadeTransition(
      opacity: _monthFadeAnim,
      child: SlideTransition(
        position: _monthSlideAnim,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 0,
            childAspectRatio: 1.05,
          ),
          itemCount: leadingCells + totalDays,
          itemBuilder: (context, index) {
            if (index < leadingCells) return const SizedBox.shrink();

            final dayNum = index - leadingCells + 1;
            final dayDate = DateTime(
                _displayedMonth.year, _displayedMonth.month, dayNum);
            final isSelected = _isSameDay(_selectedDate, dayDate);
            final isToday = _isSameDay(_today, dayDate);
            final isDisabled = _isDisabled(dayDate);

            return _DayCell(
              dayNum: dayNum,
              isSelected: isSelected,
              isToday: isToday,
              isDisabled: isDisabled,
              primaryColor: _primaryColor,
              onTap: isDisabled ? null : () => _selectDate(dayDate),
            );
          },
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.pop(context, _selectedDate);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpottRadius.button),
          ),
        ),
        child: Text(
          'Confirm Date',
          style: SpottTextStyles.labelLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final Color primaryColor;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? primaryColor.withValues(alpha: 0.08)
              : SpottColors.surface2,
          borderRadius: BorderRadius.circular(SpottRadius.sm),
          border: Border.all(
            color: enabled
                ? primaryColor.withValues(alpha: 0.2)
                : SpottColors.border,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? primaryColor : SpottColors.textMuted,
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int dayNum;
  final bool isSelected;
  final bool isToday;
  final bool isDisabled;
  final Color primaryColor;
  final VoidCallback? onTap;

  const _DayCell({
    required this.dayNum,
    required this.isSelected,
    required this.isToday,
    required this.isDisabled,
    required this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? primaryColor
              : isToday
                  ? primaryColor.withValues(alpha: 0.08)
                  : Colors.transparent,
          border: isToday && !isSelected
              ? Border.all(color: primaryColor, width: 1.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            '$dayNum',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: isSelected || isToday
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: isDisabled
                  ? SpottColors.border
                  : isSelected
                      ? Colors.white
                      : isToday
                          ? primaryColor
                          : SpottColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PREMIUM PASSENGERS BOTTOM SHEET
// ══════════════════════════════════════════════════════════════════════════════

/// A production-quality seat/passenger selector presented as a bottom sheet.
/// Features an Airbnb-style stepper with animated count transitions and an
/// interactive seat map visualization.
class PremiumPassengersBottomSheet extends StatefulWidget {
  final int initialSeats;
  final int maxSeats;
  final Color? primaryColor;
  final String title;
  final String subtitle;

  const PremiumPassengersBottomSheet({
    super.key,
    required this.initialSeats,
    this.maxSeats = 6,
    this.primaryColor,
    this.title = 'Select Passengers',
    this.subtitle = 'Choose the number of seats to book',
  });

  static Future<int?> show(
    BuildContext context, {
    required int initialSeats,
    int maxSeats = 6,
    Color? primaryColor,
    String title = 'Select Passengers',
    String subtitle = 'Choose the number of seats to book',
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      useSafeArea: true,
      builder: (context) => PremiumPassengersBottomSheet(
        initialSeats: initialSeats,
        maxSeats: maxSeats,
        primaryColor: primaryColor,
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  @override
  State<PremiumPassengersBottomSheet> createState() =>
      _PremiumPassengersBottomSheetState();
}

class _PremiumPassengersBottomSheetState
    extends State<PremiumPassengersBottomSheet> {
  late int _selectedSeats;
  late Color _primaryColor;

  @override
  void initState() {
    super.initState();
    _selectedSeats = widget.initialSeats.clamp(1, widget.maxSeats);
    _primaryColor = widget.primaryColor ?? SpottColors.primary;
  }

  void _updateSeats(int count) {
    if (count < 1 || count > widget.maxSeats) return;
    HapticFeedback.lightImpact();
    setState(() => _selectedSeats = count);
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 24,
        right: 24,
        bottom: safeBottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSeatMap(),
          const SizedBox(height: 28),
          _buildStepper(),
          const SizedBox(height: 28),
          _buildQuickPicks(),
          const SizedBox(height: 24),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: SpottColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(SpottRadius.md),
          ),
          child: Icon(Icons.chair_alt_rounded, color: _primaryColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: SpottTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SpottColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.subtitle,
                style: SpottTextStyles.caption.copyWith(
                  color: SpottColors.textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, size: 20),
          color: SpottColors.textSecondary,
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: SpottColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SpottRadius.sm),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatMap() {
    // Seat assignments: 1 = front passenger, 2-4 = middle row, 5-6 = rear row
    final seatRows = <List<int>>[
      [1],
      [2, 3, 4],
      if (widget.maxSeats > 4) [5, 6],
    ];

    return Column(
      children: [
        // Car top header (windshield)
        Container(
          width: 220,
          height: 10,
          decoration: BoxDecoration(
            color: SpottColors.surface2,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: SpottColors.border),
          ),
        ),
        Container(
          width: 240,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: SpottColors.surface2,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(color: SpottColors.border),
          ),
          child: Column(
            children: [
              // Driver row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDriverIndicator(),
                  _buildSeatTile(1),
                ],
              ),
              if (seatRows.length > 1) ...[
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  color: SpottColors.border,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [2, 3, 4].map(_buildSeatTile).toList(),
                ),
              ],
              if (seatRows.length > 2) ...[
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  color: SpottColors.border,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [5, 6].map(_buildSeatTile).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            borderRadius: BorderRadius.circular(SpottRadius.sm),
            border: Border.all(color: SpottColors.border),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_rounded,
                  color: SpottColors.textTertiary, size: 20),
              SizedBox(height: 2),
              Text(
                'Driver',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: SpottColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeatTile(int index) {
    final isSelected = index <= _selectedSeats;

    return GestureDetector(
      onTap: () => _updateSeats(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : SpottColors.surface1,
          borderRadius: BorderRadius.circular(SpottRadius.sm),
          border: Border.all(
            color: isSelected
                ? _primaryColor
                : SpottColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primaryColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.airline_seat_recline_normal_rounded,
              color: isSelected ? Colors.white : SpottColors.textMuted,
              size: 20,
            ),
            const SizedBox(height: 1),
            Text(
              '$index',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white.withValues(alpha: 0.8) : SpottColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    final canDecrement = _selectedSeats > 1;
    final canIncrement = _selectedSeats < widget.maxSeats;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrement
        _StepperButton(
          icon: Icons.remove_rounded,
          enabled: canDecrement,
          primaryColor: _primaryColor,
          onTap: () => _updateSeats(_selectedSeats - 1),
        ),
        // Count display
        SizedBox(
          width: 120,
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Text(
                  '$_selectedSeats',
                  key: ValueKey<int>(_selectedSeats),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: SpottColors.textPrimary,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _selectedSeats == 1 ? 'seat selected' : 'seats selected',
                style: SpottTextStyles.caption.copyWith(
                  fontSize: 12,
                  color: SpottColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        // Increment
        _StepperButton(
          icon: Icons.add_rounded,
          enabled: canIncrement,
          primaryColor: _primaryColor,
          onTap: () => _updateSeats(_selectedSeats + 1),
        ),
      ],
    );
  }

  Widget _buildQuickPicks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.maxSeats, (i) {
        final seat = i + 1;
        final isSelected = _selectedSeats == seat;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () => _updateSeats(seat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? _primaryColor : SpottColors.surface2,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _primaryColor : SpottColors.border,
                  width: isSelected ? 0 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  '$seat',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : SpottColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.pop(context, _selectedSeats);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpottRadius.button),
          ),
        ),
        child: Text(
          _selectedSeats == 1
              ? 'Confirm 1 Seat'
              : 'Confirm $_selectedSeats Seats',
          style: SpottTextStyles.labelLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Stepper button ───────────────────────────────────────────────────────────

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final Color primaryColor;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: enabled
              ? primaryColor.withValues(alpha: 0.08)
              : SpottColors.surface2,
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? primaryColor.withValues(alpha: 0.25)
                : SpottColors.border,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 26,
          color: enabled ? primaryColor : SpottColors.textMuted,
        ),
      ),
    );
  }
}
