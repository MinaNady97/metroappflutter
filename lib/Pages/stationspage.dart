import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';

class Stationspage extends StatefulWidget {
  final List<List<List<int>>> serializedData;

  const Stationspage({super.key, required this.serializedData});

  @override
  State<Stationspage> createState() => _StationspageState();
}

class _StationspageState extends State<Stationspage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _stationsByLine = [];
  List<Map<String, dynamic>> _filteredStations = [];

  @override
  void initState() {
    super.initState();
    _loadStations();
    _searchController.addListener(_filterStations);
  }

  void _loadStations() {
    for (int i = 0; i < widget.serializedData.length; i++) {
      final line = widget.serializedData[i];
      final stations = <Map<String, dynamic>>[];
      for (int j = 0; j < line.length; j++) {
        stations.add({'name': 'Station ${j + 1}', 'coordinates': line[j], 'isTransfer': false});
      }
      _stationsByLine.add({'lineNumber': i + 1, 'lineColor': _lineColor(i + 1), 'stations': stations});
    }
    _filteredStations = List.from(_stationsByLine);
  }

  void _filterStations() {
    final q = _searchController.text.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filteredStations = List.from(_stationsByLine);
      } else {
        _filteredStations = _stationsByLine
            .map((line) {
              final list = (line['stations'] as List)
                  .where((s) => s['name'].toString().toLowerCase().contains(q))
                  .toList();
              return {...line, 'stations': list};
            })
            .where((line) => (line['stations'] as List).isNotEmpty)
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundSand,
      appBar: AppBar(title: const Text('Stations')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stations...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: _filteredStations.isEmpty
                ? const Center(child: Text('No stations found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredStations.length,
                    itemBuilder: (_, idx) {
                      final line = _filteredStations[idx];
                      final stations = line['stations'] as List;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Line ${line['lineNumber']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...List.generate(stations.length, (i) {
                              final station = stations[i] as Map<String, dynamic>;
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(color: line['lineColor'], shape: BoxShape.circle),
                                ),
                                title: Text(station['name'].toString()),
                                onTap: () => HapticFeedback.selectionClick(),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _lineColor(int n) {
    switch (n) {
      case 1:
        return AppTheme.line1;
      case 2:
        return AppTheme.line2;
      case 3:
        return AppTheme.line3;
      case 4:
        return AppTheme.line4;
      default:
        return AppTheme.lrt;
    }
  }
}
