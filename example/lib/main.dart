import 'package:flutter/material.dart';
import 'package:snackflow/snackflow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                SnackFlow.show(
                  context,
                  "আইটেমটি সফলভাবে মুছে ফেলা হয়েছে!",
                  //backgroundColor: Colors.blueGrey.shade800,
                  // icon: Icons.delete_outline,
                  actionLabel: "UNDO",
                  onAction: () {
                    // Undo logic here...
                    print("Undo Tapped!");
                  },
                  position: SnackPosition.bottom, // নতুন অবস্থান
                  // blur: true,
                );
              },
              child: const Text('show'),
            ),
            ElevatedButton(
              onPressed: () {
                SnackFlow.success(
                  context,
                  "আপনার প্রোফাইল সফলভাবে আপডেট করা হয়েছে!",
                  duration: const Duration(seconds: 4),
                  position: SnackPosition.right,
                  verticalPosition: VerticalPosition.bottom,
                );
              },
              child: const Text('success'),
            ),
            ElevatedButton(
              onPressed: () {
                SnackFlow.failed(context, "Login Successful!", icon: Icons.add);
              },
              child: const Text('failed'),
            ),
            ElevatedButton(
              onPressed: () {
                SnackFlow.error(
                  context,
                  "নেটওয়ার্ক সংযোগ বিচ্ছিন্ন হয়েছে। দয়া করে আবার চেষ্টা করুন।",
                  duration: const Duration(seconds: 5),
                  onDismiss: () {
                    print("Error Dismissed!");
                  },
                );
              },
              child: const Text('error'),
            ),
          ],
        ),
      ),
    );
  }
}
