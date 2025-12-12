import 'package:flutter/material.dart';
// IMPORTANT: Assuming SnackFlow has been updated with title: null defaults
// NOTE: For this demo to run, SnackFlow class and SnackPosition/VerticalPosition enums
// must be imported from the 'snackflow' package (which should contain the code
// provided in previous responses).
import 'package:snackflow/snackflow.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  /// Creates the MyApp widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackFlow Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      home: const SnackFlowHomePage(),
    );
  }
}

/// The home page displaying the grid of buttons to trigger various SnackFlow notifications.
class SnackFlowHomePage extends StatelessWidget {
  /// Creates the SnackFlowHomePage widget.
  const SnackFlowHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a standard style for consistency, even though the widgets are hardcoded
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      minimumSize: const Size(double.infinity, 50),
    );

    const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      appBar: AppBar(
        title: const Text('SnackFlow Demo'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        crossAxisCount: 3, // Display 3 buttons per row
        childAspectRatio: 1.2, // Adjusted ratio for smaller/shorter buttons
        padding: const EdgeInsets.all(12.0),
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        children: [
          // -----------------------------------------------------------------
          // 1. DEFAULT EXAMPLES (Minimal parameters) - Row 1
          // -----------------------------------------------------------------
          /// 1. Default Info Notification (SnackPosition.bottom)
          ElevatedButton(
            onPressed: () {
              // No title argument passed: title will be null (no display)
              SnackFlow.show(context, "Data loaded successfully.");
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade50),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('1. Default', style: textStyle),
            ),
          ),

          /// 2. Success Notification
          ElevatedButton(
            onPressed: () {
              // No title argument passed: title will be null (no display)
              SnackFlow.success(context, "Payment completed. Thank you!");
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(Colors.green.shade50),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('2. Success', style: textStyle),
            ),
          ),

          /// 3. Error Notification
          ElevatedButton(
            onPressed: () {
              // No title argument passed: title will be null (no display)
              SnackFlow.error(
                context,
                "Server connection lost. Please try again.",
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(Colors.red.shade50),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('3. Error', style: textStyle),
            ),
          ),

          // -----------------------------------------------------------------
          // 4. DEFAULT EXAMPLE & 5-6. POSITION EXAMPLES - Row 2
          // -----------------------------------------------------------------
          /// 4. Failed Notification
          ElevatedButton(
            onPressed: () {
              // No title argument passed: title will be null (no display)
              SnackFlow.failed(
                context,
                "Input verification failed due to an error.",
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(Colors.orange.shade50),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('4. Failed', style: textStyle),
            ),
          ),

          /// 5. Position: Top
          ElevatedButton(
            onPressed: () {
              // No title argument passed: title will be null (no display)
              SnackFlow.show(
                context,
                "This notification is visible at the top of the screen.",
                // Ensure SnackPosition is imported or accessible
                position: SnackPosition.top,
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(Colors.blue.shade100),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('5. Pos: Top', style: textStyle),
            ),
          ),

          /// 6. Position: Center
          ElevatedButton(
            onPressed: () {
              // No title argument passed: title will be null (no display)
              SnackFlow.show(
                context,
                "This notification will be shown in the exact center.",
                // Ensure SnackPosition is imported or accessible
                position: SnackPosition.center,
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(Colors.purple.shade100),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('6. Pos: Center', style: textStyle),
            ),
          ),

          // -----------------------------------------------------------------
          // 7-9. POSITION & ACTION EXAMPLES - Row 3
          // -----------------------------------------------------------------
          /// 7. Position: Left/Top
          ElevatedButton(
            onPressed: () {
              // No title argument passed: title will be null (no display)
              SnackFlow.show(
                context,
                "Left side, aligned to the top.",
                // Ensure SnackPosition and VerticalPosition are imported
                position: SnackPosition.left,
                verticalPosition: VerticalPosition.top,
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(Colors.teal.shade100),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('7. Pos: Left/Top', style: textStyle),
            ),
          ),

          /// 8. Position: Right/Middle
          ElevatedButton(
            onPressed: () {
              // No title argument passed: title will be null (no display)
              SnackFlow.success(
                context,
                "Right side, aligned to the middle vertically.",
                // Ensure SnackPosition and VerticalPosition are imported
                position: SnackPosition.right,
                verticalPosition: VerticalPosition.middle,
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(
                Colors.lightGreen.shade100,
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('8. Pos: Right/Mid', style: textStyle),
            ),
          ),

          /// 9. Custom: Action Button
          ElevatedButton(
            onPressed: () {
              // No title argument passed: title will be null (no display)
              SnackFlow.show(
                context,
                "Do you want to update your profile now?",
                actionLabel: "Update",
                onAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Action button clicked!')),
                  );
                },
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(
                Colors.deepOrange.shade100,
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('9. Custom: Action', style: textStyle),
            ),
          ),

          // -----------------------------------------------------------------
          // 10-12. CUSTOMIZATION EXAMPLES - Row 4
          // -----------------------------------------------------------------
          /// 10. Custom: Leading Widget and Title
          ElevatedButton(
            onPressed: () {
              // Title argument IS passed: "New Message!" will be displayed
              SnackFlow.show(
                context,
                "You have received a new message.",
                leading: const CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.mail, color: Colors.white, size: 20),
                ),
                title: "New Message!",
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(Colors.pink.shade100),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('10. Custom: Leading', style: textStyle),
            ),
          ),

          /// 11. Custom: Colors, Duration, and Title
          ElevatedButton(
            onPressed: () {
              // Title argument IS passed: "Custom Look" will be displayed
              SnackFlow.failed(
                context,
                "White background and dark blue text.",
                backgroundColor: Colors.white,
                textColor: Colors.blueGrey.shade900,
                duration: const Duration(seconds: 7),
                title: "Custom Look",
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(Colors.grey.shade300),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('11. Custom: Colors', style: textStyle),
            ),
          ),

          /// 12. Custom: On Dismiss Callback and Title
          ElevatedButton(
            onPressed: () {
              // Title argument IS passed: "Timer On" will be displayed
              SnackFlow.error(
                context,
                "Something will happen when this notification is closed.",
                title: "Timer On",
                duration: const Duration(seconds: 3),
                onDismiss: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification dismissed.')),
                  );
                },
              );
            },
            style: buttonStyle.copyWith(
              // DEPRECATION FIX: Changed MaterialStatePropertyAll to WidgetStatePropertyAll
              backgroundColor: WidgetStatePropertyAll(
                Colors.redAccent.shade100,
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('12. Custom: On Dismiss', style: textStyle),
            ),
          ),
        ],
      ),
    );
  }
}
