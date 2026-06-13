$files = Get-ChildItem -Path "D:\PROJECTS\Spotter\spotter\lib" -Recurse -Filter *.dart

foreach ($f in $files) {
    if (-not $f.FullName.Contains("\lib\design_system\") -and -not $f.FullName.Contains("\lib\core\theme\")) {
        $c = [IO.File]::ReadAllText($f.FullName)
        $orig = $c
        
        # Replace imports
        $c = [regex]::Replace($c, "import '[^']*core/theme/(colors|spacing|radius|shadows|typography|animations)\.dart';", "")
        
        if ($c -match "Spott(Colors|Spacing|Radius|Shadows|TextStyles|Animations)") {
            if ($c -notmatch "package:spotter/design_system/design_system\.dart") {
                $c = "import 'package:spotter/design_system/design_system.dart';`n" + $c
            }
        }
        
        # TextStyles
        $c = $c -replace "SpottTextStyles\.displayXL", "DSTypography.displayXL"
        $c = $c -replace "SpottTextStyles\.displayLarge", "DSTypography.displayLarge"
        $c = $c -replace "SpottTextStyles\.display", "DSTypography.headline"
        $c = $c -replace "SpottTextStyles\.screenTitle", "DSTypography.headline"
        $c = $c -replace "SpottTextStyles\.headline", "DSTypography.headline"
        $c = $c -replace "SpottTextStyles\.sectionTitle", "DSTypography.headline"
        $c = $c -replace "SpottTextStyles\.titleSmall", "DSTypography.titleLarge"
        $c = $c -replace "SpottTextStyles\.title", "DSTypography.titleLarge"
        $c = $c -replace "SpottTextStyles\.bodyLarge", "DSTypography.bodyLarge"
        $c = $c -replace "SpottTextStyles\.bodySmall", "DSTypography.caption"
        $c = $c -replace "SpottTextStyles\.body", "DSTypography.body"
        $c = $c -replace "SpottTextStyles\.labelLarge", "DSTypography.labelLarge"
        $c = $c -replace "SpottTextStyles\.label", "DSTypography.labelLarge"
        $c = $c -replace "SpottTextStyles\.caption", "DSTypography.caption"
        $c = $c -replace "SpottTextStyles\.overline", "DSTypography.caption"
        $c = $c -replace "SpottTextStyles\.mono", "DSTypography.caption"
        $c = $c -replace "SpottTextStyles\.", "DSTypography."
        
        # Spacing
        $c = $c -replace "SpottSpacing\.s4", "DSSpacing.xs"
        $c = $c -replace "SpottSpacing\.s8", "DSSpacing.sm"
        $c = $c -replace "SpottSpacing\.s12", "DSSpacing.md"
        $c = $c -replace "SpottSpacing\.s16", "DSSpacing.md"
        $c = $c -replace "SpottSpacing\.s20", "DSSpacing.page"
        $c = $c -replace "SpottSpacing\.s24", "DSSpacing.lg"
        $c = $c -replace "SpottSpacing\.s32", "DSSpacing.xl"
        $c = $c -replace "SpottSpacing\.s40", "40.0"
        $c = $c -replace "SpottSpacing\.s48", "DSSpacing.xxl"
        $c = $c -replace "SpottSpacing\.xs", "DSSpacing.xs"
        $c = $c -replace "SpottSpacing\.sm", "DSSpacing.sm"
        $c = $c -replace "SpottSpacing\.md", "DSSpacing.md"
        $c = $c -replace "SpottSpacing\.lg", "DSSpacing.lg"
        $c = $c -replace "SpottSpacing\.xl", "DSSpacing.xl"
        $c = $c -replace "SpottSpacing\.xxl", "DSSpacing.xxl"
        $c = $c -replace "SpottSpacing\.xxxl", "64.0"
        $c = $c -replace "SpottSpacing\.cardInner", "DSSpacing.card"
        $c = $c -replace "SpottSpacing\.section", "DSSpacing.section"
        $c = $c -replace "SpottSpacing\.pageTop", "DSSpacing.pageInset"
        $c = $c -replace "SpottSpacing\.pageBottom", "120.0"
        $c = $c -replace "SpottSpacing\.pageHorizontal", "12.0"
        $c = $c -replace "SpottSpacing\.", "DSSpacing."
        
        # Radius
        $c = $c -replace "SpottRadius\.primaryCard", "DSRadius.card"
        $c = $c -replace "SpottRadius\.secondaryCard", "DSRadius.card"
        $c = $c -replace "SpottRadius\.button", "DSRadius.button"
        $c = $c -replace "SpottRadius\.card", "DSRadius.card"
        $c = $c -replace "SpottRadius\.inputs", "DSRadius.input"
        $c = $c -replace "SpottRadius\.bottomSheet", "DSRadius.bottomSheet"
        $c = $c -replace "SpottRadius\.searchContainer", "DSRadius.bottomSheet"
        $c = $c -replace "SpottRadius\.circular", "DSRadius.pill"
        $c = $c -replace "SpottRadius\.hero", "DSRadius.card"
        $c = $c -replace "SpottRadius\.banner", "DSRadius.card"
        $c = $c -replace "SpottRadius\.nav", "DSRadius.lg"
        $c = $c -replace "SpottRadius\.floatingSurface", "DSRadius.bottomSheet"
        $c = $c -replace "SpottRadius\.", "DSRadius."
        
        # Colors
        $c = $c -replace "SpottColors\.backgroundElevated", "DSColors.elevatedSurface"
        $c = $c -replace "SpottColors\.surface1", "DSColors.surface"
        $c = $c -replace "SpottColors\.surface2", "DSColors.surfaceVariant"
        $c = $c -replace "SpottColors\.surface3", "DSColors.surface"
        $c = $c -replace "SpottColors\.cardSurface", "DSColors.card"
        $c = $c -replace "SpottColors\.surface4", "DSColors.surface"
        $c = $c -replace "SpottColors\.surfaceContainer", "DSColors.surface"
        $c = $c -replace "SpottColors\.primaryPressed", "Color(0xFF9E2A30)"
        $c = $c -replace "SpottColors\.primaryHover", "Color(0xFFE55D63)"
        $c = $c -replace "SpottColors\.disabled", "DSColors.border"
        $c = $c -replace "SpottColors\.disabledText", "DSColors.textMuted"
        $c = $c -replace "SpottColors\.overlayHover", "Color(0x0A000000)"
        $c = $c -replace "SpottColors\.overlayPressed", "Color(0x1A000000)"
        $c = $c -replace "SpottColors\.accentPurpleSoft", "DSColors.primarySoft"
        $c = $c -replace "SpottColors\.accentPurple", "DSColors.primaryDark"
        $c = $c -replace "SpottColors\.accentSecondaryContainer", "DSColors.primary"
        $c = $c -replace "SpottColors\.inputBackground", "DSColors.surface"
        $c = $c -replace "SpottColors\.cardBackground", "DSColors.card"
        $c = $c -replace "SpottColors\.offerRed", "Color(0xFFE53935)"
        $c = $c -replace "SpottColors\.offerBlue", "Color(0xFF1976D2)"
        $c = $c -replace "SpottColors\.offerGreen", "Color(0xFF43A047)"
        $c = $c -replace "SpottColors\.offerPurple", "Color(0xFF8E24AA)"
        $c = $c -replace "SpottColors\.borderSubtle", "DSColors.borderSubtle"
        $c = $c -replace "SpottColors\.trustVerified", "DSColors.success"
        $c = $c -replace "SpottColors\.trustPremium", "DSColors.warning"
        $c = $c -replace "SpottColors\.trustBadge", "DSColors.info"
        $c = $c -replace "SpottColors\.gradientStart", "DSColors.surface"
        $c = $c -replace "SpottColors\.gradientEnd", "DSColors.background"
        $c = $c -replace "SpottColors\.heroGradientStart", "DSColors.surface"
        $c = $c -replace "SpottColors\.heroGradientEnd", "DSColors.background"
        $c = $c -replace "SpottColors\.", "DSColors."
        
        # Shadows
        $c = $c -replace "SpottShadows\.glowPrimary", "DSShadows.elevation2"
        $c = $c -replace "SpottShadows\.glowPurple", "DSShadows.elevation2"
        $c = $c -replace "SpottShadows\.glowSuccess", "DSShadows.elevation1"
        $c = $c -replace "SpottShadows\.glowWarning", "DSShadows.elevation1"
        $c = $c -replace "SpottShadows\.elevationSm", "DSShadows.elevation1"
        $c = $c -replace "SpottShadows\.navGlowRed", "DSShadows.elevation3"
        $c = $c -replace "SpottShadows\.heroGlow", "DSShadows.elevation1"
        $c = $c -replace "SpottShadows\.navFloat", "DSShadows.elevation2"
        $c = $c -replace "SpottShadows\.cardShadow", "DSShadows.elevation1"
        $c = $c -replace "SpottShadows\.bottomBarShadow", "DSShadows.elevation3"
        $c = $c -replace "SpottShadows\.stickyHeaderShadow", "DSShadows.elevation1"
        $c = $c -replace "SpottShadows\.", "DSShadows."

        # Animations
        $c = $c -replace "SpottAnimations\.fast", "DSMotion.durationFast"
        $c = $c -replace "SpottAnimations\.medium", "DSMotion.durationNormal"
        $c = $c -replace "SpottAnimations\.slow", "DSMotion.durationSlow"
        $c = $c -replace "SpottAnimations\.", "DSMotion."

        if ($orig -ne $c) {
            [IO.File]::WriteAllText($f.FullName, $c)
        }
    }
}
