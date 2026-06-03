import 'package:flutter/material.dart';
import 'package:easy_app_update/easy_app_update.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Basic usage — soft update dialog
      EasyAppUpdate.checkForUpdate(context);

      // Force update example:
      // EasyAppUpdate.checkForUpdate(
      //   context,
      //   config: UpdateConfig(updateMode: UpdateMode.force),
      // );

      // Custom dialog example:
      // EasyAppUpdate.checkForUpdate(
      //   context,
      //   config: UpdateConfig(
      //     dialogBuilder: (context, version, openStore, dismiss) {
      //       return AlertDialog(
      //         title: Text('v$version available!'),
      //         actions: [
      //           if (dismiss != null) TextButton(onPressed: dismiss, child: const Text('Later')),
      //           ElevatedButton(onPressed: openStore, child: const Text('Update')),
      //         ],
      //       );
      //     },
      //   ),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Easy App Update Example')),
      body: const Center(child: Text('Check for updates on launch')),
    );
  }
}
