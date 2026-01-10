import 'package:flutter/material.dart';

/// Callback type for clearing shared preferences.
typedef ClearPreferencesCallback = void Function();

/// Debug page for development utilities.
///
/// Accepts callbacks for actions to avoid direct DI coupling.
class DebugPage extends StatelessWidget {
  const DebugPage({
    super.key,
    this.onClearPreferences,
  });

  /// Callback when user requests to clear shared preferences.
  final ClearPreferencesCallback? onClearPreferences;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: const Text('Shared Preferences'),
          subtitle: const Text('Clear all shared preferences'),
          onTap: onClearPreferences,
        ),
        const ListTile(
          title: Text('Debug Option 2'),
          subtitle: Text('Description for debug option 2'),
        ),
        const ListTile(
          title: Text('Debug Option 3'),
          subtitle: Text('Description for debug option 3'),
        ),
      ],
    );
  }
}
