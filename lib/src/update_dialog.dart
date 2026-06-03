import 'package:flutter/material.dart';

import 'models.dart';

/// Shows the update dialog based on [UpdateMode].
Future<void> showUpdateDialog({
  required BuildContext context,
  required String storeVersion,
  required UpdateMode updateMode,
  required VoidCallback openStore,
  Widget Function(BuildContext, String, VoidCallback, VoidCallback?)? dialogBuilder,
}) {
  final isDismissible = updateMode == UpdateMode.soft;
  final dismiss = isDismissible ? () => Navigator.of(context).pop() : null;

  return showDialog(
    context: context,
    barrierDismissible: isDismissible,
    builder: (ctx) {
      if (dialogBuilder != null) {
        return PopScope(
          canPop: isDismissible,
          child: dialogBuilder(ctx, storeVersion, openStore, dismiss),
        );
      }
      return PopScope(
        canPop: isDismissible,
        child: AlertDialog(
          title: const Text('Update Available'),
          content: Text('A new version ($storeVersion) is available. Please update for the best experience.'),
          actions: [
            if (isDismissible)
              TextButton(onPressed: dismiss, child: const Text('Later')),
            ElevatedButton(onPressed: openStore, child: const Text('Update Now')),
          ],
        ),
      );
    },
  );
}
