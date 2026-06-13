$files = @(
    "D:\PROJECTS\Spotter\spotter\lib\core\components\redbus_sections.dart",
    "D:\PROJECTS\Spotter\spotter\lib\screens\booking_success_screen.dart",
    "D:\PROJECTS\Spotter\spotter\lib\screens\driver_home_screen.dart",
    "D:\PROJECTS\Spotter\spotter\lib\screens\services_screen.dart",
    "D:\PROJECTS\Spotter\spotter\lib\screens\trip_details_screen.dart",
    "D:\PROJECTS\Spotter\spotter\lib\screens\panels\spotter_tracking_panel.dart"
)

foreach ($f in $files) {
    if (Test-Path $f) {
        $c = Get-Content $f -Raw
        
        # Replace imports
        $c = $c -replace "import '.*redbus_theme\.dart';", "import 'package:spotter/design_system/design_system.dart';"
        
        # Colors
        $c = $c -replace "RBColors\.primaryDark", "DSColors.primaryDark"
        $c = $c -replace "RBColors\.primaryLight", "DSColors.primaryLight"
        $c = $c -replace "RBColors\.primarySoft", "DSColors.primarySoft"
        $c = $c -replace "RBColors\.primary", "DSColors.primary"
        
        $c = $c -replace "RBColors\.background", "DSColors.background"
        $c = $c -replace "RBColors\.surfaceGrey", "DSColors.surfaceVariant"
        $c = $c -replace "RBColors\.surface", "DSColors.surface"
        $c = $c -replace "RBColors\.headerBg", "DSColors.primary"
        
        $c = $c -replace "RBColors\.seatAvailable", "DSColors.success"
        $c = $c -replace "RBColors\.seatUnavailable", "DSColors.textMuted"
        $c = $c -replace "RBColors\.seatSelected", "DSColors.info"
        $c = $c -replace "RBColors\.seatLadies", "Color(0xFFE91E63)"
        $c = $c -replace "RBColors\.seatYellow", "DSColors.warning"
        
        $c = $c -replace "RBColors\.textDark", "DSColors.textPrimary"
        $c = $c -replace "RBColors\.textMedium", "DSColors.textSecondary"
        $c = $c -replace "RBColors\.textLight", "DSColors.textTertiary"
        $c = $c -replace "RBColors\.textWhite", "Colors.white"
        
        $c = $c -replace "RBColors\.divider", "DSColors.divider"
        $c = $c -replace "RBColors\.border", "DSColors.border"
        $c = $c -replace "RBColors\.green", "DSColors.success"
        $c = $c -replace "RBColors\.orange", "DSColors.warning"
        $c = $c -replace "RBColors\.blue", "DSColors.info"
        $c = $c -replace "RBColors\.purple", "DSColors.primaryDark"
        $c = $c -replace "RBColors\.gold", "DSColors.warning"
        
        # TextStyles
        $c = $c -replace "RBTextStyles\.appBarTitle", "DSTypography.titleLarge.copyWith(color: Colors.white)"
        $c = $c -replace "RBTextStyles\.routeCity", "DSTypography.headline.copyWith(fontWeight: FontWeight.w800)"
        $c = $c -replace "RBTextStyles\.routeSubtitle", "DSTypography.caption"
        $c = $c -replace "RBTextStyles\.sectionHeader", "DSTypography.titleLarge"
        $c = $c -replace "RBTextStyles\.cardTitle", "DSTypography.titleLarge.copyWith(fontSize: 15)"
        $c = $c -replace "RBTextStyles\.cardSubtitle", "DSTypography.caption"
        $c = $c -replace "RBTextStyles\.priceSmall", "DSTypography.labelLarge.copyWith(color: DSColors.primary)"
        $c = $c -replace "RBTextStyles\.price", "DSTypography.headline.copyWith(color: DSColors.primary)"
        $c = $c -replace "RBTextStyles\.badge", "DSTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600)"
        $c = $c -replace "RBTextStyles\.amenity", "DSTypography.caption"
        $c = $c -replace "RBTextStyles\.buttonLabel", "DSTypography.labelLarge.copyWith(color: Colors.white)"
        $c = $c -replace "RBTextStyles\.filterLabel", "DSTypography.caption.copyWith(color: DSColors.textPrimary)"
        $c = $c -replace "RBTextStyles\.bodyText", "DSTypography.body"
        
        # Spacing
        $c = $c -replace "RBSpacing\.xs", "DSSpacing.xs"
        $c = $c -replace "RBSpacing\.sm", "DSSpacing.sm"
        $c = $c -replace "RBSpacing\.md", "DSSpacing.md"
        $c = $c -replace "RBSpacing\.lg", "DSSpacing.lg"
        $c = $c -replace "RBSpacing\.xxl", "DSSpacing.xl"
        $c = $c -replace "RBSpacing\.xl", "DSSpacing.page"
        $c = $c -replace "RBSpacing\.pageH", "DSSpacing.pageInset"
        
        # Radius
        $c = $c -replace "RBRadius\.xs", "DSRadius.xs"
        $c = $c -replace "RBRadius\.sm", "DSRadius.sm"
        $c = $c -replace "RBRadius\.md", "DSRadius.md"
        $c = $c -replace "RBRadius\.lg", "DSRadius.lg"
        $c = $c -replace "RBRadius\.xl", "DSRadius.xl"
        $c = $c -replace "RBRadius\.pill", "DSRadius.pill"
        $c = $c -replace "RBRadius\.card", "DSRadius.card"
        
        # Fix const issues with copyWith
        $c = $c -replace "const (.*)\.copyWith", "`$1.copyWith"
        
        [IO.File]::WriteAllText($f, $c)
    }
}
