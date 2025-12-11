import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Defines the possible screen positions where a [SnackFlow] notification can appear.
enum SnackPosition {
  /// Appears at the top center of the screen.
  top,

  /// Appears at the bottom center of the screen (Default).
  bottom,

  /// Appears at the exact center of the screen.
  center,

  /// Appears attached to the left side of the screen.
  left,

  /// Appears attached to the right side of the screen.
  right
}

/// Defines the vertical alignment for notifications positioned at [SnackPosition.left] or [SnackPosition.right].
enum VerticalPosition {
  /// Aligned near the top edge of the screen.
  top,

  /// Aligned in the middle vertically.
  middle,

  /// Aligned near the bottom edge of the screen (Default).
  bottom
}

// Global OverlayEntry reference to handle single instance dismissal
OverlayEntry? _currentOverlayEntry;

/// A utility class to easily display custom, highly configurable snack bar-style notifications
/// (often called 'Snack flows') across the application using Flutter Overlays.
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
            margin: position == SnackPosition.left ||
                    position == SnackPosition.right
                ? const EdgeInsets.symmetric(horizontal: 16)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            constraints: position == SnackPosition.left ||
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

  /// Displays a standard, neutral notification.
  ///
  /// This method is highly configurable, allowing custom colors, icons, actions,
  /// and positioning via [position] and [verticalPosition].
  ///
  /// Parameters:
  /// * [context]: The BuildContext used to show the overlay.
  /// * [message]: The text message displayed in the notification.
  /// * [backgroundColor]: The background color of the notification badge (Default: Dark Blue/Black).
  /// * [textColor]: The color of the text and icons (Default: White).
  /// * [icon]/[leading]: Optional leading icon or custom widget.
  /// * [duration]: How long the notification stays visible (Default: 3 seconds).
  /// * [borderRadius]: Corner radius of the badge.
  /// * [position]: Where the badge appears on the screen (Default: bottom).
  /// * [actionLabel]/[onAction]: Button label and callback for an action button.
  /// * [showClose]: If true, shows a close 'X' button.
  /// * [onDismiss]: Callback executed when the notification is manually dismissed or times out.
  /// * [verticalPosition]: Vertical alignment for left/right positions (Default: bottom).
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

  /// Displays a success notification with a distinct green background and check icon.
  ///
  /// Parameters:
  /// * [context]: The BuildContext used to show the overlay.
  /// * [message]: The text message displayed.
  /// * [position]: Where the badge appears on the screen (Default: bottom).
  /// * [verticalPosition]: Vertical alignment for left/right positions (Default: bottom).
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

  /// Displays a warning/failed notification with an orange background and warning icon.
  ///
  /// Parameters:
  /// * [context]: The BuildContext used to show the overlay.
  /// * [message]: The text message displayed.
  /// * [position]: Where the badge appears on the screen (Default: bottom).
  /// * [verticalPosition]: Vertical alignment for left/right positions (Default: bottom).
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

  /// Displays an error notification with a distinct red background and error icon.
  ///
  /// Parameters:
  /// * [context]: The BuildContext used to show the overlay.
  /// * [message]: The text message displayed.
  /// * [position]: Where the badge appears on the screen (Default: bottom).
  /// * [verticalPosition]: Vertical alignment for left/right positions (Default: bottom).
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
