import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/storage_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _storage = StorageService();
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    _history = await _storage.getFavoriteCities();
    setState(() {});
  }

  Future<void> _saveHistory() async {
    final set = {..._history};
    if (_controller.text.trim().isNotEmpty) set.add(_controller.text.trim());
    await _storage.saveFavoriteCities(set.take(8).toList());
  }

  void _search(String city) async {
    if (city.trim().isEmpty) return;
    await context.read<WeatherProvider>().fetchByCity(city.trim());
    await _saveHistory();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search city')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Enter city name…',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _search(_controller.text),
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: _search,
            ),
            const SizedBox(height: 16),
            if (_history.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  children: _history.map((e) => ActionChip(label: Text(e), onPressed: () => _search(e))).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
