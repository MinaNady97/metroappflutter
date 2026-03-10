import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';

// ─── Station list data per line ──────────────────────────────────────────────

const _line1Stations = [
  'Helwan', 'Ain Helwan', 'Helwan University', 'Wadi Hof', 'Hadayek Helwan',
  'El-Maasara', 'Tora El-Asmant', 'Kozzika', 'Tora El-Balad', 'Sakanat El-Maadi',
  'Maadi', 'Hadayek El-Maadi', 'Dar El-Salam', 'El-Zahraa', 'Mar Girgis',
  'El-Malek El-Saleh', 'Al-Sayeda Zeinab', 'Saad Zaghloul', 'Sadat (Transfer)',
  'Nasser', 'Orabi', 'Al-Shohadaa (Transfer)', 'Ghamra', 'El-Demerdash',
  'Manshiet El-Sadr', 'Kobba', 'Hammamat El-Qobba', 'Saray El-Qobba',
  'Hadayek El-Zeitoun', 'Helmeyet El-Zeitoun', 'El-Matareyya',
  'Ain Shams', 'Ezbet El-Nakhl', 'El-Marg', 'New El-Marg',
];

const _line2Stations = [
  'El-Mounib', 'Hadayek El-Maadi', 'Sakiat Mekky', 'Om El-Masryeen',
  'Al-Giza', 'Faisal', 'Cairo University', 'Boulak El-Dakrour',
  'El-Behoos', 'Dokki', 'Opera', 'Sadat (Transfer)', 'Mohamed Naguib',
  'Attaba (Transfer)', 'Mohamed Farid', 'Gamal Abd El-Nasser',
  'Nagaa El-Arab', 'Khalafawy', 'St. Teresa', 'Rod El-Farag',
  'Maspero', 'Shubra El-Kheima',
];

const _line3StationsMain = [
  'Adly Mansour', 'El-Haykestep', 'Omar Ibn El-Khattab', 'Qobaa',
  'Hesham Barakat', 'El-Nozha', 'Nadi El-Shams', 'Alf Maskan',
  'Heliopolis / Merghany', 'Al-Ahram', 'Koleyet El-Banat',
  'Cairo Airport T3', 'Gamal Abd El-Nasser (Transfer)', 'Haroun',
  'Helmeyet El-Zeitoun', 'El-Shohadaa (Transfer)', 'Gamaet El-Dowal El-Arabiya',
  'Boulak', 'Attaba (Transfer)', 'Cairo Stadium', 'Fair Zone', 'Abdel Moneim Riad',
  'Kit Kat (Transfer)', 'Sudan', 'Imbaba', 'El-Bohy', 'Wadi El-Nil',
  'Cairo University Br.', 'Rod El-Farag Axis',
];

const _lrtStations = [
  'Adly Mansour', 'New Cairo 1', 'New Cairo 2', 'El-Mostakbal City',
  'Administrative Capital 1', 'Administrative Capital 2',
  '10th of Ramadan 1', '10th of Ramadan 2', '10th of Ramadan 3',
  '10th of Ramadan (Term.)',
];

const _monorailStations = [
  'Nasr City 1', 'Nasr City 2', 'El-Salam', 'Capital Airport',
  'New Administrative Capital', 'R3 Station',
];

// ─── Line descriptors ─────────────────────────────────────────────────────────

class _LineInfo {
  final String id;
  final String number;
  final String name;
  final Color color;
  final List<String> stations;
  final double distanceKm;
  final int travelMinutes;
  final String firstTrain;
  final String lastTrain;
  final String terminus1;
  final String terminus2;

  const _LineInfo({
    required this.id,
    required this.number,
    required this.name,
    required this.color,
    required this.stations,
    required this.distanceKm,
    required this.travelMinutes,
    required this.firstTrain,
    required this.lastTrain,
    required this.terminus1,
    required this.terminus2,
  });
}

final _allLines = <_LineInfo>[
  _LineInfo(
    id: '1', number: '1', name: 'Line 1 — Helwan ↔ El-Marg',
    color: AppTheme.line1,
    stations: _line1Stations, distanceKm: 43.5, travelMinutes: 72,
    firstTrain: '05:00', lastTrain: '00:00',
    terminus1: 'Helwan', terminus2: 'New El-Marg',
  ),
  _LineInfo(
    id: '2', number: '2', name: 'Line 2 — El-Mounib ↔ Shubra',
    color: AppTheme.line2,
    stations: _line2Stations, distanceKm: 20.2, travelMinutes: 35,
    firstTrain: '05:30', lastTrain: '23:30',
    terminus1: 'El-Mounib', terminus2: 'Shubra El-Kheima',
  ),
  _LineInfo(
    id: '3', number: '3', name: 'Line 3 — Rod El-Farag ↔ Airport',
    color: AppTheme.line3,
    stations: _line3StationsMain, distanceKm: 35.1, travelMinutes: 58,
    firstTrain: '05:00', lastTrain: '23:00',
    terminus1: 'Rod El-Farag Axis', terminus2: 'Cairo Airport T3',
  ),
  _LineInfo(
    id: 'LRT', number: 'LRT', name: 'LRT — Adly Mansour ↔ 10th of Ramadan',
    color: AppTheme.lrt,
    stations: _lrtStations, distanceKm: 90.0, travelMinutes: 60,
    firstTrain: '06:00', lastTrain: '22:00',
    terminus1: 'Adly Mansour', terminus2: '10th of Ramadan',
  ),
  _LineInfo(
    id: 'Mono', number: 'M', name: 'Monorail — Nasr City ↔ Capital',
    color: AppTheme.monorail,
    stations: _monorailStations, distanceKm: 54.0, travelMinutes: 45,
    firstTrain: '06:30', lastTrain: '22:30',
    terminus1: 'Nasr City 1', terminus2: 'New Admin. Capital',
  ),
];

// ─── Modal sheet ──────────────────────────────────────────────────────────────

class AllLinesModal extends StatefulWidget {
  const AllLinesModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AllLinesModal(),
    );
  }

  @override
  State<AllLinesModal> createState() => _AllLinesModalState();
}

class _AllLinesModalState extends State<AllLinesModal> {
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF9F7F4),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Drag handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryNile.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.tram, color: AppTheme.primaryNile, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'All Metro Lines',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF184D56),
                        ),
                      ),
                      Text(
                        '${_allLines.length} lines · ${_allLines.fold(0, (s, l) => s + l.stations.length)} stations',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            // Line list
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.all(16),
                itemCount: _allLines.length,
                itemBuilder: (_, i) => _buildLineSection(_allLines[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineSection(_LineInfo info) {
    final isExpanded = _expanded.contains(info.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: info.color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header (always visible)
            InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (isExpanded) {
                    _expanded.remove(info.id);
                  } else {
                    _expanded.add(info.id);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: info.color, width: 4),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: info.color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              info.number,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${info.stations.length} stations · ${info.distanceKm.toStringAsFixed(1)} km',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Stats row
                    Row(
                      children: [
                        _chip(Icons.schedule, '${info.travelMinutes} min', info.color),
                        const SizedBox(width: 8),
                        _chip(Icons.access_time_filled, '${info.firstTrain}–${info.lastTrain}', info.color),
                        const SizedBox(width: 8),
                        _chip(Icons.location_on, '${info.distanceKm.toStringAsFixed(0)} km', info.color),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Expandable station list
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: isExpanded
                  ? _buildStationList(info)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color lineColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: lineColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: lineColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: lineColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationList(_LineInfo info) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 16),
          Text(
            'Stations',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          ...info.stations.asMap().entries.map((entry) {
            final idx = entry.key;
            final name = entry.value;
            final isFirst = idx == 0;
            final isLast = idx == info.stations.length - 1;
            final isTransfer = name.contains('Transfer') ||
                name.contains('↔') ||
                name.contains('Br.');

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Column(
                    children: [
                      // Top connector line
                      if (!isFirst)
                        Container(
                          width: 2,
                          height: 8,
                          color: info.color.withOpacity(0.4),
                        ),
                      // Station dot
                      Container(
                        width: isFirst || isLast ? 12 : (isTransfer ? 10 : 8),
                        height: isFirst || isLast ? 12 : (isTransfer ? 10 : 8),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: isTransfer
                              ? Colors.white
                              : (isFirst || isLast ? info.color : info.color.withOpacity(0.6)),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: info.color,
                            width: isFirst || isLast ? 2.5 : (isTransfer ? 2 : 1.5),
                          ),
                        ),
                      ),
                      // Bottom connector line
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 8,
                          color: info.color.withOpacity(0.4),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isFirst || isLast || isTransfer
                                ? FontWeight.w700
                                : FontWeight.normal,
                            color: isFirst || isLast
                                ? const Color(0xFF184D56)
                                : Colors.grey.shade800,
                          ),
                        ),
                        if (isTransfer) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Transfer',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.amber.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
