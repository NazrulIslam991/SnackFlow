import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Assuming SnackFlow class and related enums (SnackPosition, VerticalPosition) are in this package
import 'package:snackflow/snackflow.dart';

void main() {
  runApp(const MyApp());
}

// ----------------------------------------------------
//  Main Application Setup (MyApp)
// ----------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackFlow Demo',
      // Hides the debug banner in the corner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        // Custom background color for the entire scaffold
        scaffoldBackgroundColor: const Color(0xFF0E0E12),
        // Sets the primary accent color
        colorScheme: const ColorScheme.dark(primary: Colors.blueAccent),
        // Sets a custom font family
        fontFamily: "Inter",
      ),
      home: const MyHomePage(),
    );
  }
}

// ----------------------------------------------------
//  Home Page (MyHomePageState)
// ----------------------------------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Helper Widget: Creates a standardized title for sections
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // --------------------------
  // Helper Widget: Creates a stylized outlined button
  // --------------------------
  Widget _button({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          // Defines the border color and thickness
          side: const BorderSide(color: Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          children: [
            // Icon displayed on the left
            Icon(icon, size: 22, color: Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Creates a stylized card container for grouping buttons
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 26),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Dark background for the card
        color: const Color(0xFF1A1A22),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          // Adds a shadow effect
          BoxShadow(color: Colors.black, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SnackFlow Demo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1A1A22),
        elevation: 0,
      ),

      // Allows the content to be scrolled if it exceeds screen height
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            // ----------------------------------------------------
            // SECTION 1: Default Actions (Bottom Position)
            // ----------------------------------------------------
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Default Actions"),

                  // 1. Basic show() - Uses default background/text color
                  _button(
                    label: "Default Info",
                    icon: Icons.info_outline,
                    onTap: () {
                      SnackFlow.show(
                        context,
                        "This is a default info message.",
                      );
                    },
                  ),

                  // 2. success() - Uses default green color for success
                  _button(
                    label: "Success Message",
                    icon: Icons.check_circle_outline,
                    onTap: () {
                      SnackFlow.success(
                        context,
                        "Profile updated successfully!",
                        duration: const Duration(seconds: 4),
                      );
                    },
                  ),

                  // 3. failed() - Uses default orange color for warning/failure
                  _button(
                    label: "Warning",
                    icon: Icons.warning_amber_rounded,
                    onTap: () {
                      SnackFlow.failed(
                        context,
                        "Warning: Something went wrong.",
                      );
                    },
                  ),

                  // 4. error() - Uses default red color for error
                  _button(
                    label: "Error",
                    icon: Icons.error_outline_rounded,
                    onTap: () {
                      SnackFlow.error(context, "Network disconnected!");
                    },
                  ),
                ],
              ),
            ),

            // ----------------------------------------------------
            // SECTION 2: Custom Position and Features
            // ----------------------------------------------------
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Custom Position & Advanced"),

                  // 5. Custom: Top Position with Action Button (UNDO) and Close Button
                  _button(
                    label: "Top Position + Undo",
                    icon: Icons.arrow_drop_up,
                    onTap: () {
                      SnackFlow.show(
                        context,
                        "Saved! You can undo.",
                        position: SnackPosition.top, //  Set position to Top
                        actionLabel: "UNDO", // Add action button
                        onAction: () {
                          HapticFeedback.lightImpact();
                          // Action logic goes here
                        },
                        showClose: true, // Show the 'X' button
                      );
                    },
                  ),

                  // 6. Custom: Left Position, vertically aligned to the Bottom
                  _button(
                    label: "Left Bottom Badge",
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () {
                      SnackFlow.success(
                        context,
                        "New mail received!",
                        position: SnackPosition.left, //  Set position to Left
                        verticalPosition: VerticalPosition
                            .bottom, // ⬇️ Vertically Bottom alignment
                        duration: const Duration(seconds: 4),
                      );
                    },
                  ),

                  // 7. Custom: Right Position, vertically aligned to the Middle
                  _button(
                    label: "Right Middle Badge",
                    icon: Icons.arrow_forward_ios_rounded,
                    onTap: () {
                      SnackFlow.error(
                        context,
                        "Access Denied!",
                        position: SnackPosition.right, //  Set position to Right
                        verticalPosition: VerticalPosition
                            .middle, // ↔️ Vertically Middle alignment
                      );
                    },
                  ),

                  // 8. Custom: Center Position
                  _button(
                    label: "Center Message",
                    icon: Icons.circle_outlined,
                    onTap: () {
                      SnackFlow.failed(
                        context,
                        "Upload failed!",
                        position:
                            SnackPosition.center, //  Set position to Center
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
