import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SnackPosition { top, bottom, center, left, right }

enum VerticalPosition { top, middle, bottom }

OverlayEntry? _currentOverlayEntry;

class SnackFlow {
  static void _showCustomOverlay(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Widget? leading,
    Duration duration = const Duration(seconds: 3),
    double borderRadius = 10,
    SnackPosition position = SnackPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onDismiss,
    bool showClose = false,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
  }) {
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
      _currentOverlayEntry = null;
    }

    HapticFeedback.mediumImpact();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    final defaultBg = isDark ? const Color(0xFF34495E) : Colors.black;
    final defaultText = isDark ? Colors.white : Colors.white;

    final bgColor = backgroundColor ?? defaultBg;
    final txtColor = textColor ?? defaultText;

    final overlay = Overlay.of(context);

    final controller = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 400),
    );

    Offset beginOffset;
    double? leftPos;
    double? rightPos;
    double? topPos;
    double? bottomPos;

    const double badgeApproximateHeight = 100;

    switch (position) {
      case SnackPosition.top:
        beginOffset = const Offset(0.0, -1.5);
        topPos = MediaQuery.of(context).padding.top + 10;
        leftPos = 0;
        rightPos = 0;
        break;
      case SnackPosition.bottom:
        beginOffset = const Offset(0.0, 1.5);
        bottomPos = 20;
        leftPos = 0;
        rightPos = 0;
        break;

      case SnackPosition.left:
        beginOffset = const Offset(-1.5, 0.0);
        leftPos = 0;
        if (verticalPosition == VerticalPosition.top) {
          topPos = MediaQuery.of(context).padding.top + 10;
        } else if (verticalPosition == VerticalPosition.bottom) {
          bottomPos = 20;
        } else {
          topPos = screenHeight * 0.5 - (badgeApproximateHeight / 2);
        }
        break;

      case SnackPosition.right:
        beginOffset = const Offset(1.5, 0.0);
        rightPos = 0;
        if (verticalPosition == VerticalPosition.top) {
          topPos = MediaQuery.of(context).padding.top + 10;
        } else if (verticalPosition == VerticalPosition.bottom) {
          bottomPos = 20;
        } else {
          topPos = screenHeight * 0.5 - (badgeApproximateHeight / 2);
        }
        break;

      case SnackPosition.center:
        beginOffset = Offset.zero;
        break;
    }

    final slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    void removeOverlay() {
      if (_currentOverlayEntry != null) {
        controller.reverse().then((_) {
          _currentOverlayEntry?.remove();
          _currentOverlayEntry = null;
          if (onDismiss != null) {
            onDismiss();
          }
        });
      }
    }

    final customContent = Builder(
      builder: (innerContext) {
        Widget snackContent = Material(
          color: Colors.transparent,
          child: Container(
            margin:
                position == SnackPosition.left ||
                    position == SnackPosition.right
                ? const EdgeInsets.symmetric(horizontal: 16)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            constraints:
                position == SnackPosition.left ||
                    position == SnackPosition.right
                ? BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                    minWidth: 100,
                  )
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(0x7F),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: leading,
                  )
                else if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(icon, size: 22, color: txtColor),
                  ),
                Flexible(
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: txtColor,
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onAction();
                        removeOverlay();
                      },
                      child: Text(
                        actionLabel,
                        style: TextStyle(
                          color: txtColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (showClose)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      removeOverlay();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: txtColor.withAlpha((255 * 0.7).round()),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );

        return SlideTransition(position: slideAnimation, child: snackContent);
      },
    );

    _currentOverlayEntry = OverlayEntry(
      builder: (context) {
        if (position == SnackPosition.center) {
          return Center(child: customContent);
        }

        return Positioned(
          top: topPos,
          bottom: bottomPos,
          left: leftPos,
          right: rightPos,
          child: customContent,
        );
      },
    );

    overlay.insert(_currentOverlayEntry!);
    controller.forward();

    Future.delayed(duration, () {
      removeOverlay();
    });
  }

  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = const Color(0xFF34495E),
    Color textColor = Colors.white,
    IconData? icon,
    Widget? leading,
    Duration duration = const Duration(seconds: 3),
    double borderRadius = 10,
    SnackPosition position = SnackPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
    bool showClose = false,
    VoidCallback? onDismiss,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
  }) {
    _showCustomOverlay(
      context,
      message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      leading: leading,
      duration: duration,
      borderRadius: borderRadius,
      position: position,
      actionLabel: actionLabel,
      onAction: onAction,
      showClose: showClose,
      onDismiss: onDismiss,
      verticalPosition: verticalPosition,
    );
  }

  static void success(
    BuildContext context,
    String message, {
    Color backgroundColor = const Color(0xFF27AE60),
    Color textColor = Colors.white,
    IconData icon = Icons.check_circle_rounded,
    Duration duration = const Duration(seconds: 3),
    double borderRadius = 10,
    SnackPosition position = SnackPosition.bottom,
    VoidCallback? onDismiss,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
  }) {
    HapticFeedback.mediumImpact();
    _showCustomOverlay(
      context,
      message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
      borderRadius: borderRadius,
      position: position,
      onDismiss: onDismiss,
      verticalPosition: verticalPosition,
    );
  }

  static void failed(
    BuildContext context,
    String message, {
    Color backgroundColor = const Color(0xFFE67E22),
    Color textColor = Colors.white,
    IconData icon = Icons.warning_rounded,
    Duration duration = const Duration(seconds: 3),
    double borderRadius = 10,
    SnackPosition position = SnackPosition.bottom,
    VoidCallback? onDismiss,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
  }) {
    HapticFeedback.mediumImpact();
    _showCustomOverlay(
      context,
      message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
      borderRadius: borderRadius,
      position: position,
      onDismiss: onDismiss,
      verticalPosition: verticalPosition,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    Color backgroundColor = const Color(0xFFC0392B),
    Color textColor = Colors.white,
    IconData icon = Icons.error_rounded,
    Duration duration = const Duration(seconds: 3),
    double borderRadius = 10,
    SnackPosition position = SnackPosition.bottom,
    VoidCallback? onDismiss,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
  }) {
    HapticFeedback.mediumImpact();
    _showCustomOverlay(
      context,
      message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
      borderRadius: borderRadius,
      position: position,
      onDismiss: onDismiss,
      verticalPosition: verticalPosition,
    );
  }
}
