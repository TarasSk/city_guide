import 'package:city_guide_app/src/application/di/injection_container.dart' as di;
import 'package:city_guide_app/src/shared/shared_preferences/shared_preferences_abstract.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: const Text('Shared Preferences'),
          subtitle: const Text('Clear all shared preferences'),
          onTap: ()=> di.injector<SharedPreferencesAbstract>().clear(),
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
