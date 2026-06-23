import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_button.dart';
import 'helper.dart';
import 'models/production_readiness_models.dart';

void _handleBack(BuildContext context) {
  final currentRoute = ModalRoute.of(context)?.settings.name;

  if (currentRoute == '/choose-role') {
    SystemNavigator.pop();
    return;
  }

  if (currentRoute == '/home' || currentRoute == '/driver-home') {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/choose-role',
      (route) => false,
    );
    return;
  }

  final driverRoutes = {
    '/kyc',
    '/create-trip',
    '/job-requests',
    '/job-detail',
    '/pickup-task',
    '/drop-task',
  };

  if (driverRoutes.contains(currentRoute)) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/driver-home',
      (route) => false,
    );
  } else {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}

class SpotterScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> content;
  final Widget? bottom;
  final bool showBack;
  final bool showMenu;
  final Widget? bottomNavigationBar;

  const SpotterScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    this.bottom,
    this.showBack = true,
    this.showMenu = false,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = this.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      return Row(
                        children: [
                          if (showBack)
                            _SpottIconButton(
                              icon: Icons.arrow_back,
                              onPressed: () => _handleBack(context),
                            )
                          else
                            const SizedBox(width: 44),
                          const Spacer(),
                          Text(
                            'SPOTT',
                            style: TextStyle(
                              color: Helper.inkColor(context),
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      color: Helper.inkColor(context),
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Helper.mutedColor(context),
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.only(
                            bottom: 12 + MediaQuery.viewPaddingOf(context).bottom,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              ...content,
                              if (bottom != null) ...[
                                const SizedBox(height: 20),
                                bottom,
                              ],
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpottIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _SpottIconButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: 44,
      child: Material(
        color: Helper.cardBg(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Helper.line(context)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Icon(icon, color: Helper.inkColor(context), size: 21),
        ),
      ),
    );
  }
}

class SpotterCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  final Color color;
  final double? height;
  final VoidCallback? onTap;
  final bool hasShadow;

  const SpotterCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(18),
    this.color = Helper.cardColor,
    this.height,
    this.onTap,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve dynamic background color
    Color resolvedColor;
    if (color == Helper.cardColor) {
      resolvedColor = Helper.cardBg(context);
    } else if (color == Helper.canvasSoft) {
      resolvedColor = Helper.canvasSoftColor(context);
    } else if (color == const Color(0xFFF4F4F4)) {
      resolvedColor = isDark ? Helper.bgSurf : color;
    } else {
      resolvedColor = color;
    }

    final borderRadius = BorderRadius.circular(20); // 20px card corner radius

    Widget cardContent;

    cardContent = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: borderRadius,
        border: Border.all(color: Helper.line(context), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );

    final card = height == null
        ? cardContent
        : ConstrainedBox(
            constraints: BoxConstraints(minHeight: height!),
            child: cardContent,
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(borderRadius: borderRadius, onTap: onTap, child: card),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedValueColor = valueColor ?? Helper.inkColor(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Helper.mutedColor(context), fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: resolvedValueColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RideContextCard extends StatelessWidget {
  final String route;
  final String fare;
  final String driver;
  final String status;

  const RideContextCard({
    super.key,
    required this.route,
    required this.fare,
    required this.driver,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      color: const Color(0xFFF4F4F4),
      children: [
        const StatusChip(label: 'Trip context'),
        const SizedBox(height: 12),
        InfoRow(label: 'Route', value: route),
        InfoRow(
          label: 'Fare',
          value: fare,
          valueColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Helper.primary,
        ),
        InfoRow(label: 'Driver', value: driver),
        InfoRow(label: 'Status', value: status),
      ],
    );
  }
}

class RecoveryBanner extends StatelessWidget {
  final RecoverableActionState state;
  final VoidCallback? onRetry;

  const RecoveryBanner({super.key, required this.state, this.onRetry});

  @override
  Widget build(BuildContext context) {
    if (!state.isFailure) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SpotterCard(
      color: isDark ? const Color(0xFF2C220E) : const Color(0xFFFFF8E7),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: isDark ? const Color(0xFFFFB020) : Helper.warning,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                state.message ?? 'This action could not be completed.',
                style: TextStyle(
                  color: isDark ? const Color(0xFFFFB020) : Helper.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (state.canRetry && onRetry != null) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh,
                color: isDark ? const Color(0xFFFFB020) : Helper.primary,
              ),
              label: Text(
                'Try again',
                style: TextStyle(
                  color: isDark ? const Color(0xFFFFB020) : Helper.primary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    this.color = Helper.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve chip background and border colors
    Color bgColor;
    Color borderColor;
    Color textColor;

    if (color == Helper.primary) {
      bgColor = isDark
          ? Helper.primary.withValues(alpha: 0.12)
          : Helper.primary.withValues(alpha: 0.08);
      borderColor = isDark
          ? Helper.primary.withValues(alpha: 0.3)
          : Helper.primary.withValues(alpha: 0.15);
      textColor = Helper.primary;
    } else {
      bgColor = color.withValues(alpha: isDark ? 0.12 : 0.08);
      borderColor = color.withValues(alpha: isDark ? 0.3 : 0.15);
      textColor = color;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class MapPlaceholder extends StatelessWidget {
  final double height;

  const MapPlaceholder({super.key, this.height = 170});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Helper.line(context)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 45,
            right: 45,
            top: height / 2,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: Helper.line(context)),
              ),
            ),
          ),
          Positioned(
            left: 66,
            top: height / 2 - 15,
            child: _MapDot(color: Helper.success, label: 'Pickup'),
          ),
          Positioned(
            right: 66,
            top: height / 2 - 15,
            child: _MapDot(color: Helper.danger, label: 'Drop'),
          ),
        ],
      ),
    );
  }
}

class _MapDot extends StatelessWidget {
  final Color color;
  final String label;

  const _MapDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class RideTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final String price;
  final VoidCallback? onTap;

  const RideTile({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SpotterCard(
      height: 104,
      onTap: onTap,
      children: [
        Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2C)
                    : const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Helper.line(context)),
              ),
              child: Icon(icon, size: 28, color: Helper.inkColor(context)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Helper.inkColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: TextStyle(
                      color: Helper.mutedColor(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Helper.inkColor(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PrimaryAction extends StatelessWidget {
  final String label;
  final Widget? targetScreen;
  final String? routeName;
  final VoidCallback? onPressed;

  const PrimaryAction({
    super.key,
    required this.label,
    this.targetScreen,
    this.routeName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      targetScreen: targetScreen,
      routeName: routeName,
      onPressed: onPressed,
    );
  }
}



