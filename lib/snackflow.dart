import 'dart:ui'; // For BackdropFilter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ----------------------------------------------------
//  SnackFlow Utility Class and Enums
// ----------------------------------------------------

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
/// with a modern glass morphism design.
class SnackFlow {
  static void _showCustomOverlay(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Widget? leading,
    Duration duration = const Duration(seconds: 4),
    double borderRadius = 14,
    SnackPosition position = SnackPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onDismiss,
    bool showClose = true,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
    String? title, // The title is nullable here
    Color? statusColor,
  }) {
    // Dismiss previous overlay if it exists
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
      _currentOverlayEntry = null;
    }

    HapticFeedback.mediumImpact();

    // --- Core Customization Defaults (NO THEME MATCHING) ---

    final screenHeight = MediaQuery.of(context).size.height;

    // 1. Default Glass Base Color (User customizable via parameter)
    // Fixed Dark base for glass effect by default
    const Color defaultGlassBaseColor = Color(0xFF1A1A1A);
    final bgColor = backgroundColor ?? defaultGlassBaseColor;

    // 2. Text Color Logic: Use custom color, otherwise ensure readability against bgColor
    var finalTxtColor = textColor;
    if (finalTxtColor == null) {
      // Calculate luminance to decide between black or white text
      final isLightBackground = bgColor.computeLuminance() > 0.5;
      finalTxtColor = isLightBackground ? Colors.black87 : Colors.white;
    }

    final statusBgColor =
        statusColor ?? const Color(0xFF3498DB); // Default Info Blue

    // --- End Core Customization Defaults ---

    // TickerProvider error workaround: use Overlay state
    final overlayState = Overlay.of(context);
    final controller = AnimationController(
      vsync: overlayState as TickerProvider,
      duration: const Duration(milliseconds: 500),
    );

    Offset beginOffset;
    double? leftPos;
    double? rightPos;
    double? topPos;
    double? bottomPos;

    const double badgeApproximateHeight = 100;

    // Position setup
    switch (position) {
      case SnackPosition.top:
        beginOffset = const Offset(0.0, -1.5);
        topPos = MediaQuery.of(context).padding.top + 10;
        leftPos = 16;
        rightPos = 16;
        break;
      case SnackPosition.bottom:
        beginOffset = const Offset(0.0, 1.5);
        bottomPos = 20;
        leftPos = 16;
        rightPos = 16;
        break;
      case SnackPosition.left:
        beginOffset = const Offset(-1.5, 0.0);
        leftPos = 16;
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
        rightPos = 16;
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
        leftPos = 16; // Setting the gap
        rightPos = 16; // Setting the gap
        topPos = screenHeight * 0.5 - (badgeApproximateHeight / 2);
        break;
    }

    final slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: controller, curve: Curves.fastEaseInToSlowEaseOut));

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
        // Use the current theme for general styling consistency (like fonts)
        final theme = Theme.of(innerContext);

        Widget snackContent = Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 10.0, sigmaY: 10.0), // Glass morphism Blur
              child: Container(
                constraints: position == SnackPosition.left ||
                        position == SnackPosition.right
                    ? BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                        minWidth: 100,
                      )
                    : null,
                decoration: BoxDecoration(
                  // Background color using the determined bgColor with transparency
                  color: bgColor.withAlpha(
                      (255 * 0.4).round()), // Semi-transparent background
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: statusBgColor
                        .withAlpha((255 * 0.3).round()), // Subtle border
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((255 * 0.25).round()),
                      blurRadius: 20,
                      spreadRadius: -5,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- 1. Large Leading Section (Icon/Widget) ---
                      Container(
                        width: 60, // Fixed width for the icon section
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: statusBgColor.withAlpha(
                              (255 * 0.7).round()), // Solid color section
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadius),
                            bottomLeft: Radius.circular(borderRadius),
                          ),
                        ),
                        child: Center(
                          child: leading ??
                              Icon(
                                icon ?? Icons.info_outline_rounded,
                                size: 28,
                                color: finalTxtColor,
                              ),
                        ),
                      ),

                      // --- 2. Content Section (Title & Message) ---
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: title != null
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Check if title is NOT null before displaying
                              if (title != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    title,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: finalTxtColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              Text(
                                message, // Description
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: finalTxtColor
                                      ?.withAlpha((255 * 0.9).round()),
                                  fontSize: 14,
                                  height: title != null ? 1.2 : 1.3,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: title != null
                                    ? 2
                                    : 3, // Allow more lines if no title
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- 3. Action/Close Section ---
                      if (actionLabel != null && onAction != null)
                        TextButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            onAction();
                            removeOverlay();
                          },
                          child: Text(
                            actionLabel,
                            style: TextStyle(
                              color: finalTxtColor,
                              fontWeight: FontWeight.bold,
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
                            padding: const EdgeInsets.only(right: 12, left: 8),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color:
                                  finalTxtColor?.withAlpha((255 * 0.7).round()),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        return SlideTransition(position: slideAnimation, child: snackContent);
      },
    );

    _currentOverlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: topPos,
          bottom: bottomPos,
          left: leftPos,
          right: rightPos,
          child: customContent,
        );
      },
    );

    overlayState.insert(_currentOverlayEntry!);
    controller.forward();

    // Auto-dismissal timer
    Future.delayed(duration, () {
      removeOverlay();
    });
  }

  /// Displays a standard, neutral information notification.
  ///
  /// This is the default style, often used for general information messages.
  ///
  /// Parameters:
  /// * [context]: The BuildContext for the Overlay.
  /// * [message]: The main content text to display.
  /// * [title]: An optional bold title displayed above the message.
  /// * [duration]: How long the notification should stay visible (default 4 seconds).
  /// * [position]: The screen location where the notification appears (default [SnackPosition.bottom]).
  /// * [actionLabel]: Optional text for an action button.
  /// * [onAction]: The callback function executed when the action button is pressed.
  /// * [onDismiss]: The callback function executed when the notification is closed (auto or manually).
  /// * [leading]: A custom widget to display instead of the default icon.
  /// * [backgroundColor]: Custom background color for the glass effect (defaults to dark base).
  /// * [textColor]: Custom text color (defaults to white/black based on background luminance).
  /// * [icon]: Custom icon to use in the status section (defaults to [Icons.info_outline_rounded]).
  static void show(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Widget? leading,
    Duration duration = const Duration(seconds: 4),
    double borderRadius = 14,
    SnackPosition position = SnackPosition.bottom,
    String? actionLabel,
    VoidCallback? onAction,
    bool showClose = true,
    VoidCallback? onDismiss,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
    String? title,
  }) {
    _showCustomOverlay(
      context,
      message,
      title: title,
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
      statusColor: const Color(0xFF3498DB), // Default Blue
    );
  }

  /// Displays a success notification with a distinct green status color.
  ///
  /// This is typically used to confirm successful operations.
  ///
  /// Parameters:
  /// * [context]: The BuildContext for the Overlay.
  /// * [message]: The main content text to display.
  /// * [title]: An optional bold title displayed above the message.
  /// * [icon]: Custom icon to use in the status section (defaults to [Icons.check_circle_rounded]).
  /// * [duration]: How long the notification should stay visible (default 4 seconds).
  /// * [position]: The screen location where the notification appears (default [SnackPosition.bottom]).
  /// * [onDismiss]: The callback function executed when the notification is closed.
  static void success(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData icon = Icons.check_circle_rounded,
    Duration duration = const Duration(seconds: 4),
    double borderRadius = 14,
    SnackPosition position = SnackPosition.bottom,
    VoidCallback? onDismiss,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
    String? title,
  }) {
    HapticFeedback.mediumImpact();
    _showCustomOverlay(
      context,
      message,
      title: title,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
      borderRadius: borderRadius,
      position: position,
      onDismiss: onDismiss,
      verticalPosition: verticalPosition,
      statusColor: const Color(0xFF2ECC71), // Success Green
    );
  }

  /// Displays a warning or failed notification with an orange status color.
  ///
  /// Used for non-critical failures or cautionary messages.
  ///
  /// Parameters:
  /// * [context]: The BuildContext for the Overlay.
  /// * [message]: The main content text to display.
  /// * [title]: An optional bold title displayed above the message.
  /// * [icon]: Custom icon to use in the status section (defaults to [Icons.warning_rounded]).
  /// * [duration]: How long the notification should stay visible (default 5 seconds).
  /// * [position]: The screen location where the notification appears (default [SnackPosition.center]).
  /// * [onDismiss]: The callback function executed when the notification is closed.
  static void failed(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData icon = Icons.warning_rounded,
    Duration duration = const Duration(seconds: 5),
    double borderRadius = 14,
    SnackPosition position = SnackPosition.center,
    VoidCallback? onDismiss,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
    String? title,
  }) {
    HapticFeedback.mediumImpact();
    _showCustomOverlay(
      context,
      message,
      title: title,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
      borderRadius: borderRadius,
      position: position,
      onDismiss: onDismiss,
      verticalPosition: verticalPosition,
      statusColor: const Color(0xFFF39C12), // Warning Orange
    );
  }

  /// Displays a critical error notification with a red status color.
  ///
  /// Typically used for hard failures or application errors.
  ///
  /// Parameters:
  /// * [context]: The BuildContext for the Overlay.
  /// * [message]: The main content text to display.
  /// * [title]: An optional bold title displayed above the message.
  /// * [icon]: Custom icon to use in the status section (defaults to [Icons.error_rounded]).
  /// * [duration]: How long the notification should stay visible (default 6 seconds).
  /// * [position]: The screen location where the notification appears (default [SnackPosition.top]).
  /// * [onDismiss]: The callback function executed when the notification is closed.
  static void error(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData icon = Icons.error_rounded,
    Duration duration = const Duration(seconds: 6),
    double borderRadius = 14,
    SnackPosition position = SnackPosition.top,
    VoidCallback? onDismiss,
    VerticalPosition verticalPosition = VerticalPosition.bottom,
    String? title,
  }) {
    HapticFeedback.mediumImpact();
    _showCustomOverlay(
      context,
      message,
      title: title,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
      borderRadius: borderRadius,
      position: position,
      onDismiss: onDismiss,
      verticalPosition: verticalPosition,
      statusColor: const Color(0xFFE74C3C), // Error Red
    );
  }
}
