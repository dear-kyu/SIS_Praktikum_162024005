import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Background with deep atmospheric gradient and ambient glowing orbs
/// that make the glassmorphism blur and light refraction visually pop.
class GlassBackground extends StatelessWidget {
  final Widget child;

  const GlassBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base dark space gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF090D1A),
                  Color(0xFF0F172A),
                  Color(0xFF131127),
                  Color(0xFF0A0F1D),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        // Glowing Ambient Orb 1 (Top-Right: Cyan / Electric Teal)
        Positioned(
          top: -60,
          right: -50,
          child: Container(
            width: size.width * 0.75,
            height: size.width * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accent.withValues(alpha: 0.22),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha: 0.35),
                  blurRadius: 120,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),

        // Glowing Ambient Orb 2 (Mid-Left: Indigo / Violet)
        Positioned(
          top: size.height * 0.35,
          left: -80,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6366F1).withValues(alpha: 0.18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.28),
                  blurRadius: 130,
                  spreadRadius: 30,
                ),
              ],
            ),
          ),
        ),

        // Glowing Ambient Orb 3 (Bottom-Right: Neon Pink / Magenta)
        Positioned(
          bottom: -70,
          right: -40,
          child: Container(
            width: size.width * 0.65,
            height: size.width * 0.65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEC4899).withValues(alpha: 0.16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEC4899).withValues(alpha: 0.25),
                  blurRadius: 140,
                  spreadRadius: 30,
                ),
              ],
            ),
          ),
        ),

        // Child Content
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}

/// Core Glassmorphic Container with BackdropFilter blur,
/// translucent gradient fill, and subtle frosted border.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.blur = 16.0,
    this.opacity = 0.10,
    this.padding,
    this.margin,
    this.borderColor,
    this.borderWidth = 1.0,
    this.gradient,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(20);
    final effectiveBorderColor =
        borderColor ?? Colors.white.withValues(alpha: 0.18);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        gradient: gradient ??
            LinearGradient(
              colors: [
                Colors.white.withValues(alpha: opacity * 1.5),
                Colors.white.withValues(alpha: opacity * 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
      ),
      child: child,
    );

    content = ClipRRect(
      borderRadius: effectiveRadius,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}

/// Interactive Glass Card with hover glow + scale animation.
///
/// On desktop/web: reacts to mouse hover with a gentle scale-up and
/// border/shadow glow. On mobile: reacts to press with the same effect.
class GlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  /// Accent color used for the hover glow. Defaults to [AppTheme.primary].
  final Color? hoverGlowColor;
  /// Scale factor applied while hovered/pressed (e.g. 1.03).
  final double hoverScale;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.blur = 16.0,
    this.opacity = 0.10,
    this.padding,
    this.margin,
    this.borderColor,
    this.borderWidth = 1.0,
    this.gradient,
    this.boxShadow,
    this.hoverGlowColor,
    this.hoverScale = 1.03,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _active => _isHovered || _isPressed;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.borderRadius ?? BorderRadius.circular(20);
    final glowColor = widget.hoverGlowColor ?? AppTheme.primary;

    // Active border becomes more visible + neon-tinted
    final activeBorderColor = glowColor.withValues(alpha: 0.70);
    final normalBorderColor =
        widget.borderColor ?? Colors.white.withValues(alpha: 0.18);

    // Extra glow shadows when active
    final activeBoxShadow = [
      BoxShadow(
        color: glowColor.withValues(alpha: 0.35),
        blurRadius: 28,
        spreadRadius: 2,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.30),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ];

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : (_isHovered ? widget.hoverScale : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            margin: widget.margin,
            decoration: BoxDecoration(
              borderRadius: effectiveRadius,
              boxShadow: _active ? activeBoxShadow : (widget.boxShadow ?? []),
            ),
            child: GlassContainer(
              width: widget.width,
              height: widget.height,
              borderRadius: effectiveRadius,
              blur: _active ? (widget.blur + 4) : widget.blur,
              opacity: _active ? (widget.opacity + 0.06) : widget.opacity,
              borderColor:
                  _active ? activeBorderColor : normalBorderColor,
              borderWidth: _active ? 1.4 : widget.borderWidth,
              gradient: widget.gradient,
              boxShadow: const [], // shadows handled by AnimatedContainer above
              child: Material(
                color: Colors.transparent,
                borderRadius: effectiveRadius,
                child: InkWell(
                  borderRadius: effectiveRadius,
                  onTap: widget.onTap,
                  splashColor: glowColor.withValues(alpha: 0.14),
                  highlightColor: glowColor.withValues(alpha: 0.08),
                  hoverColor: glowColor.withValues(alpha: 0.05),
                  child: Padding(
                    padding: widget.padding ?? EdgeInsets.zero,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
