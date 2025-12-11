import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_loading.dart';
import '../widgets/app_error.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_section.dart';
import '../widgets/weather_detail_section.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final settings = context.watch<SettingsProvider>();

    Widget content;
    switch (provider.state) {
      case WeatherState.loading:
        content = const AppLoading();
        break;
      case WeatherState.error:
        content = AppError(
          message: provider.error,
          onRetry: () => provider.fetchByLocation(),
        );
        break;
      case WeatherState.initial:
        content = const SizedBox.shrink();
        break;
      case WeatherState.loaded:
        if (provider.current == null) {
          content = const Center(child: Text('No weather data'));
        } else {
          content = Column(
            children: [
              if (provider.isOffline)
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Offline: showing cached data'),
                ),
              CurrentWeatherCard(weather: provider.current!),
              HourlyForecastList(forecasts: provider.forecast),
              DailyForecastSection(forecasts: provider.forecast),
              WeatherDetailSection(
                weather: provider.current!,
                units: settings.units,
              ),
              const SizedBox(height: 24),
            ],
          );
        }
        break;
    }

    Widget asScrollable(Widget child) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: child,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<WeatherProvider>().refresh(),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refresh(),
        child: asScrollable(content),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        ),
        child: const Icon(Icons.search),
      ),
    );
  }
}
