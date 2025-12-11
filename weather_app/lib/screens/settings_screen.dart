import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final weather = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Use Imperial (°F, mph)'),
            subtitle: const Text('Turn off to use Metric (°C, m/s)'),
            value: settings.units == 'imperial',
            onChanged: (_) async {
              await context.read<SettingsProvider>().toggleUnits();
              weather.updateUnits(context.read<SettingsProvider>().units);
            },
          ),
          SwitchListTile(
            title: const Text('24-hour clock'),
            value: settings.is24h,
            onChanged: (_) => context.read<SettingsProvider>().toggleClock(),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Changes apply immediately to new fetches.'),
          ),
        ],
      ),
    );
  }
}
