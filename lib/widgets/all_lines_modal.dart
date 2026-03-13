import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

// ── Station entry model ───────────────────────────────────────────────────────
// Each station carries its English and Arabic name so both are always visible
// regardless of the app language.

class StationEntry {
  final String en;
  final String ar;
  final bool isTransfer;
  final bool isUnderConstruction;

  const StationEntry(
    this.en,
    this.ar, {
    this.isTransfer = false,
    this.isUnderConstruction = false,
  });
}

// ── Line descriptor ───────────────────────────────────────────────────────────

class _LineData {
  final String id;
  final String Function(AppLocalizations) name;
  final Color color;
  final List<StationEntry> stations;
  final double distanceKm;
  final int travelMinutes;
  final String firstTrain;
  final String lastTrain;
  final LineStatus status;

  const _LineData({
    required this.id,
    required this.name,
    required this.color,
    required this.stations,
    required this.distanceKm,
    required this.travelMinutes,
    required this.firstTrain,
    required this.lastTrain,
    this.status = LineStatus.operational,
  });
}

enum LineStatus { operational, construction, planned }

// ── Complete station lists ────────────────────────────────────────────────────

const _line1 = [
  StationEntry('Helwan', 'حلوان'),
  StationEntry('Ain Helwan', 'عين حلوان'),
  StationEntry('Helwan University', 'جامعة حلوان'),
  StationEntry('Wadi Hof', 'وادي حوف'),
  StationEntry('Hadayek Helwan', 'حدائق حلوان'),
  StationEntry('El-Masra', 'المسرعة'),
  StationEntry('Tora El-Esmant', 'طرة الأسمنت'),
  StationEntry('Kozzika', 'كُزيكا'),
  StationEntry('Tora El-Balad', 'طرة البلد'),
  StationEntry('Sakanat El-Maadi', 'سكنات المعادي'),
  StationEntry('Hadayek El-Maadi', 'حدائق المعادي'),
  StationEntry('Dar El-Salam', 'دار السلام'),
  StationEntry('El-Zahraa', 'الزهراء'),
  StationEntry('Mar Girgis', 'مار جرجس'),
  StationEntry('El-Malek El-Saleh', 'الملك الصالح'),
  StationEntry('El-Sayeda Zeinab', 'السيدة زينب'),
  StationEntry('Saad Zaghloul', 'سعد زغلول'),
  StationEntry('Sadat', 'السادات', isTransfer: true),
  StationEntry('Nasser', 'ناصر', isTransfer: true),
  StationEntry('Orabi', 'عرابي'),
  StationEntry('Al-Shohadaa', 'الشهداء', isTransfer: true),
  StationEntry('Ghamra', 'غمرة'),
  StationEntry('El-Demerdash', 'الدمرداش'),
  StationEntry('Manshiet El-Sadr', 'منشية الصدر'),
  StationEntry('Kobri El-Qobba', 'كوبري القبة'),
  StationEntry('Hammamat El-Qobba', 'حمامات القبة'),
  StationEntry('Saray El-Qobba', 'سراي القبة'),
  StationEntry('Hadayek El-Zaitoun', 'حدائق الزيتون'),
  StationEntry('Helmeyet El-Zaitoun', 'حلمية الزيتون'),
  StationEntry('El-Matareya', 'المطرية'),
  StationEntry('Ain Shams', 'عين شمس'),
  StationEntry('Ezbet El-Nakhl', 'عزبة النخل'),
  StationEntry('El-Marg', 'المرج'),
  StationEntry('New El-Marg', 'المرج الجديدة'),
];

const _line2 = [
  StationEntry('El-Mounib', 'المنيب'),
  StationEntry('Sakiat Mekki', 'ساقية مكي'),
  StationEntry('Omm El-Masryeen', 'أم المصريين'),
  StationEntry('Giza', 'الجيزة'),
  StationEntry('Faisal', 'فيصل'),
  StationEntry('Cairo University', 'جامعة القاهرة', isTransfer: true),
  StationEntry('El-Bohoth', 'البحوث'),
  StationEntry('Dokki', 'الدقي'),
  StationEntry('Opera', 'الأوبرا'),
  StationEntry('Sadat', 'السادات', isTransfer: true),
  StationEntry('Mohamed Naguib', 'محمد نجيب'),
  StationEntry('Ataba', 'عتبة', isTransfer: true),
  StationEntry('Al-Shohadaa', 'الشهداء', isTransfer: true),
  StationEntry('Masarra', 'مسرة'),
  StationEntry('Rod El-Farag', 'روض الفرج'),
  StationEntry('St. Teresa', 'سانت تيريزا'),
  StationEntry('El-Khalfawy', 'الخلفاوي'),
  StationEntry('Mezallat', 'المزلّت'),
  StationEntry('Kolleyet El-Zeraa', 'كلية الزراعة'),
  StationEntry('Shubra El-Kheima', 'شبرا الخيمة'),
];

const _line3 = [
  StationEntry('Adly Mansour', 'عدلي منصور', isTransfer: true),
  StationEntry('El-Haykestep', 'هايكستب'),
  StationEntry('Omar Ibn El-Khattab', 'عمر بن الخطاب'),
  StationEntry('Qubaa', 'قُباء'),
  StationEntry('Hesham Barakat', 'هشام بركات'),
  StationEntry('El-Nozha', 'النزهة'),
  StationEntry('Nadi El-Shams', 'نادي الشمس'),
  StationEntry('Alf Maskan', 'ألف مسكن'),
  StationEntry('Heliopolis', 'هيليوبوليس'),
  StationEntry('Haroun', 'هارون'),
  StationEntry('El-Ahram', 'الأهرام'),
  StationEntry('Koleyet El-Banat', 'كلية البنات'),
  StationEntry('Stadium', 'الإستاد', isTransfer: true),
  StationEntry('Fair Zone', 'أرض المعارض'),
  StationEntry('Abbassia', 'العباسية'),
  StationEntry('Abdo Pasha', 'عبده باشا'),
  StationEntry('El-Geish', 'الجيش'),
  StationEntry('Bab El-Sharia', 'باب الشعرية'),
  StationEntry('Ataba', 'عتبة', isTransfer: true),
  StationEntry('Gamal Abd El-Nasser', 'جمال عبد الناصر', isTransfer: true),
  StationEntry('Gamaet El-Dowal El-Arabiya', 'جامعة الدول العربية'),
  StationEntry('Wadi El-Nil', 'وادي النيل', isTransfer: true),
  StationEntry('Maspero', 'ماسبيرو'),
  StationEntry('Safaa Hegazi', 'صفاء حجازي'),
  StationEntry('Kit Kat', 'الكيت كات', isTransfer: true),
  StationEntry('Sudan', 'السودان'),
  StationEntry('Imbaba', 'إمبابة'),
  StationEntry('El-Bohy', 'البوهي'),
  StationEntry('El-Qawmeya El-Arabiya', 'القومية العربية'),
  StationEntry('El-Tariq El-Dairy', 'الطريق الدائري'),
  StationEntry('Cairo University (Line 3)', 'جامعة القاهرة (خط 3)',
      isTransfer: true),
  StationEntry('Bolak El-Dakrour', 'بولاق الدكرور'),
  StationEntry('El-Toufiqia', 'التوفيقية'),
  StationEntry('Rod El-Farag Axis', 'محور روض الفرج'),
];

const _line4Phase1 = [
  StationEntry('Hadayek Al-Ashgar', 'حدائق الأشجار', isUnderConstruction: true),
  StationEntry('Hadayek Al-Ahram', 'حدائق الأهرام', isUnderConstruction: true),
  StationEntry('El-Nasr', 'النصر', isUnderConstruction: true),
  StationEntry('Grand Egyptian Museum', 'المتحف المصري الكبير',
      isUnderConstruction: true),
  StationEntry('Remaya Square', 'ميدان الرماية', isUnderConstruction: true),
  StationEntry('Haram (1)', 'الهرم (١)', isUnderConstruction: true),
  StationEntry('Haram (2)', 'الهرم (٢)', isUnderConstruction: true),
  StationEntry('Haram (3)', 'الهرم (٣)', isUnderConstruction: true),
  StationEntry('Giza', 'الجيزة', isTransfer: true, isUnderConstruction: true),
  StationEntry('El-Malek El-Saleh', 'الملك الصالح',
      isTransfer: true, isUnderConstruction: true),
  StationEntry('Al-Fustat', 'الفسطاط', isUnderConstruction: true),
  StationEntry('Ain El-Sira', 'عين الصيرة', isUnderConstruction: true),
  StationEntry('New Cairo (1)', 'القاهرة الجديدة (١)',
      isUnderConstruction: true),
  StationEntry('New Cairo (2)', 'القاهرة الجديدة (٢)',
      isUnderConstruction: true),
  StationEntry('New Cairo (3)', 'القاهرة الجديدة (٣)',
      isUnderConstruction: true),
  StationEntry('New Cairo (4)', 'القاهرة الجديدة (٤)',
      isUnderConstruction: true),
  StationEntry('New Cairo (5)', 'القاهرة الجديدة (٥)',
      isUnderConstruction: true),
];

const _lrt = [
  StationEntry('Adly Mansour', 'عدلي منصور', isTransfer: true),
  StationEntry('El-Obour', 'العبور'),
  StationEntry('El-Mostakbal', 'المستقبل'),
  StationEntry('El-Shorouk', 'الشروق'),
  StationEntry('New Heliopolis', 'هيليوبوليس الجديدة'),
  StationEntry('Badr', 'بدر'),
  StationEntry('Industrial Park', 'الحديقة الصناعية'),
  StationEntry('Knowledge City', 'مدينة المعرفة'),
  StationEntry('West of Ramadan', 'العاشر غرب'),
  StationEntry('10th of Ramadan', 'العاشر من رمضان'),
  StationEntry('El-Robaiky', 'الربيكي'),
  StationEntry('Hadayek Al-Assema', 'حدائق العاصمة'),
  StationEntry('Capital Airport', 'مطار العاصمة'),
  StationEntry('Arts & Culture City', 'مدينة الفنون والثقافة',
      isTransfer: true),
  StationEntry('Nativity Cathedral', 'كاتدرائية الميلاد'),
  StationEntry('Octagon', 'الأوكتاجون'),
  StationEntry('Intl. Sports City', 'المدينة الرياضية الدولية'),
  StationEntry('Central Capital', 'العاصمة المركزية'),
  StationEntry('Industrial Zone', 'المنطقة الصناعية'),
];

const _monorailEast = [
  StationEntry('Stadium', 'الإستاد', isTransfer: true),
  StationEntry('Hesham Barakat', 'هشام بركات'),
  StationEntry('Al-Azhar University', 'جامعة الأزهر'),
  StationEntry('7th District', 'الحي السابع'),
  StationEntry('El-Musheer Ahmed Ismail', 'المشير أحمد إسماعيل'),
  StationEntry('Jehan El-Sadat', 'جيهان السادات'),
  StationEntry('El-Musheer Tantawi', 'المشير طنطاوي'),
  StationEntry('One Ninety', 'وان ناينتي'),
  StationEntry('Air Force Hospital', 'مستشفى القوات الجوية'),
  StationEntry('El-Nargues', 'النرجس'),
  StationEntry('Investors District', 'المستثمرين'),
  StationEntry('Al-Lotus', 'اللوتس'),
  StationEntry('Golden Square', 'الميدان الذهبي'),
  StationEntry('Beit El-Watan', 'بيت الوطن'),
  StationEntry('Al-Fattah Al-Alim Mosque', 'مسجد الفتاح العليم'),
  StationEntry('R1 & R2 Districts', 'أحياء R1/R2'),
  StationEntry('Central Business District', 'وسط الأعمال'),
  StationEntry('Arts & Culture City', 'مدينة الفنون والثقافة',
      isTransfer: true),
  StationEntry('Governmental District', 'الحي الحكومي'),
  StationEntry('Misr Mosque', 'مسجد مصر'),
  StationEntry('Justice City', 'مدينة العدالة'),
  StationEntry('New Capital (Term.)', 'العاصمة الإدارية (نهائي)'),
];

const _monorailWest = [
  StationEntry('New October Station', 'أكتوبر الجديدة', isTransfer: true),
  StationEntry('Industrial Zone', 'المنطقة الصناعية'),
  StationEntry('Sadat City Station', 'محطة السادات'),
  StationEntry('6th October City Authority', 'هيئة 6 أكتوبر'),
  StationEntry('Engineers Association', 'رابطة المهندسين'),
  StationEntry('Nile University', 'جامعة النيل'),
  StationEntry('Hyper One Station', 'هايبر وان'),
  StationEntry('Cairo–Alex Desert Road', 'طريق مصر–الإسكندرية الصحراوي'),
  StationEntry('Mansouriya', 'المنصورية'),
  StationEntry('Mariouteya', 'المريوطية'),
  StationEntry('Ring Road Station', 'الطريق الدائري'),
  StationEntry('Bashteel', 'بشتيل'),
  StationEntry('Wadi El-Nil', 'وادي النيل', isTransfer: true),
];

// ── Build lines list ──────────────────────────────────────────────────────────

List<_LineData> _buildLines(AppLocalizations l10n) => [
      _LineData(
        id: '1',
        name: (_) => l10n.line1Name,
        color: AppTheme.line1,
        stations: _line1,
        distanceKm: 43.5,
        travelMinutes: 72,
        firstTrain: '05:00',
        lastTrain: '00:00',
      ),
      _LineData(
        id: '2',
        name: (_) => l10n.line2Name,
        color: AppTheme.line2,
        stations: _line2,
        distanceKm: 20.2,
        travelMinutes: 35,
        firstTrain: '05:30',
        lastTrain: '23:30',
      ),
      _LineData(
        id: '3',
        name: (_) => l10n.line3Name,
        color: AppTheme.line3,
        stations: _line3,
        distanceKm: 35.1,
        travelMinutes: 58,
        firstTrain: '05:00',
        lastTrain: '23:00',
      ),
      _LineData(
        id: '4',
        name: (_) => l10n.line4FullName,
        color: AppTheme.line4,
        stations: _line4Phase1,
        distanceKm: 19.0,
        travelMinutes: 30,
        firstTrain: '—',
        lastTrain: '—',
        status: LineStatus.construction,
      ),
      _LineData(
        id: 'LRT',
        name: (_) => l10n.lrtLineName,
        color: AppTheme.lrt,
        stations: _lrt,
        distanceKm: 90.0,
        travelMinutes: 60,
        firstTrain: '06:00',
        lastTrain: '22:00',
      ),
      _LineData(
        id: 'ME',
        name: (_) => l10n.monorailEastName,
        color: AppTheme.monorail,
        stations: _monorailEast,
        distanceKm: 56.5,
        travelMinutes: 52,
        firstTrain: '—',
        lastTrain: '—',
        status: LineStatus.construction,
      ),
      _LineData(
        id: 'MW',
        name: (_) => l10n.monorailWestName,
        color: const Color(0xFF7B1FA2),
        stations: _monorailWest,
        distanceKm: 42.0,
        travelMinutes: 40,
        firstTrain: '—',
        lastTrain: '—',
        status: LineStatus.construction,
      ),
    ];

// ── Transfer map & helpers ────────────────────────────────────────────────────

const Map<String, List<String>> _kStationTransfers = {
  'Sadat': ['1', '2'],
  'Al-Shohadaa': ['1', '2'],
  'Nasser': ['1', '3'],
  'Ataba': ['2', '3'],
  'Giza': ['2', '4'],
  'El-Malek El-Saleh': ['1', '4'],
  'Adly Mansour': ['3', 'LRT'],
  'Arts & Culture City': ['LRT', 'ME'],
  'Stadium': ['3', 'ME'],
  'Kit Kat': ['3', 'LRT'],
  'Cairo University': ['2', '3'],
  'Wadi El-Nil': ['MW', '1'],
  'New October Station': ['MW', '1'],
};

Color _lineColorById(String id) => switch (id) {
      '1' => AppTheme.line1,
      '2' => AppTheme.line2,
      '3' => AppTheme.line3,
      '4' => AppTheme.line4,
      'LRT' => AppTheme.lrt,
      'ME' => AppTheme.monorail,
      'MW' => const Color(0xFF7B1FA2),
      _ => Colors.grey,
    };

String _lineLabel(String id) => switch (id) {
      '1' => 'Line 1',
      '2' => 'Line 2',
      '3' => 'Line 3',
      '4' => 'Line 4',
      'LRT' => 'LRT',
      'ME' => 'E. Monorail',
      'MW' => 'W. Monorail',
      _ => id,
    };

// ── Modal widget ──────────────────────────────────────────────────────────────

class AllLinesModal extends StatefulWidget {
  final String? initialLineId;

  const AllLinesModal({super.key, this.initialLineId});

  static Future<void> show(BuildContext context, {String? lineId}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AllLinesModal(initialLineId: lineId),
      );

  @override
  State<AllLinesModal> createState() => _AllLinesModalState();
}

class _AllLinesModalState extends State<AllLinesModal> {
  late final Map<String, GlobalKey> _lineKeys;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _lineKeys = {};
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToLine(String lineId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _lineKeys[lineId];
      final ctx = key?.currentContext;
      if (ctx == null) return;

      final renderBox = ctx.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final viewport = RenderAbstractViewport.of(renderBox);
      // alignment 0.0 = align top of item to top of viewport
      final offset = viewport.getOffsetToReveal(renderBox, 0.0).offset;
      // clamp to valid scroll range
      final target = offset.clamp(
        _scrollCtrl.position.minScrollExtent,
        _scrollCtrl.position.maxScrollExtent,
      );

      _scrollCtrl.animateTo(
        target,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lines = _buildLines(l10n);
    final totalStations = lines.fold(0, (s, l) => s + l.stations.length);

    for (final line in lines) {
      _lineKeys.putIfAbsent(line.id, () => GlobalKey());
    }

    if (widget.initialLineId != null) {
      _scrollToLine(widget.initialLineId!);
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      builder: (_, sheetCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF9F7F4),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // ── Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 14),

            // ── Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryNile.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tram_rounded,
                        color: AppTheme.primaryNile, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.allMetroLines,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF184D56),
                          ),
                        ),
                        Text(
                          '${lines.length} ${l10n.metroLinesTitle.toLowerCase()} · '
                          '$totalStations ${l10n.allLinesStationsLabel}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: const CircleBorder(),
                      minimumSize: const Size(36, 36),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),

            // ── Line list
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: lines.length,
                itemBuilder: (_, i) => _LineSection(
                  key: _lineKeys[lines[i].id],
                  data: lines[i],
                  l10n: l10n,
                  initiallyExpanded: lines[i].id == widget.initialLineId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single line section ───────────────────────────────────────────────────────

class _LineSection extends StatefulWidget {
  final _LineData data;
  final AppLocalizations l10n;
  final bool initiallyExpanded;

  const _LineSection({
    super.key,
    required this.data,
    required this.l10n,
    this.initiallyExpanded = false,
  });

  @override
  State<_LineSection> createState() => _LineSectionState();
}

class _LineSectionState extends State<_LineSection>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _ctrl;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220));
    _rotate = Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOut,
    ));
    if (_expanded) _ctrl.value = 1.0;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.selectionClick();
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  String _statusLabel() {
    return switch (widget.data.status) {
      LineStatus.operational => widget.l10n.statusLiveLabel,
      LineStatus.construction => widget.l10n.underConstructionLabel,
      LineStatus.planned => widget.l10n.plannedLabel,
    };
  }

  Color _statusColor() {
    return switch (widget.data.status) {
      LineStatus.operational => const Color(0xFF00A86B),
      LineStatus.construction => Colors.orange.shade700,
      LineStatus.planned => Colors.blueGrey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final l10n = widget.l10n;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: d.color.withOpacity(0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // ── Header row
            InkWell(
              onTap: _toggle,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: d.color, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Name row
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: d.status == LineStatus.operational
                                ? d.color
                                : d.color.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              d.id,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            d.name(l10n),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: d.status == LineStatus.operational
                                  ? const Color(0xFF184D56)
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _statusColor().withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _statusLabel(),
                            style: TextStyle(
                              color: _statusColor(),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        RotationTransition(
                          turns: _rotate,
                          child: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ── Terminus rail
                    Row(
                      children: [
                        _terminusDot(
                            d.color, d.status != LineStatus.operational),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            d.stations.first.en,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: d.status == LineStatus.operational
                                  ? d.color
                                  : Colors.grey.shade400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: CustomPaint(
                              size: const Size(double.infinity, 8),
                              painter: _ModalDashedLine(
                                color: d.status == LineStatus.operational
                                    ? d.color.withOpacity(0.4)
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            d.stations.last.en,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: d.status == LineStatus.operational
                                  ? d.color
                                  : Colors.grey.shade400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 4),
                        _terminusDot(
                            d.color, d.status != LineStatus.operational),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ── Stats chips (always one row)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _chip(
                              Icons.place_rounded,
                              '${d.stations.length} ${l10n.allLinesStationsLabel}',
                              d.color),
                          if (d.status == LineStatus.operational) ...[
                            const SizedBox(width: 6),
                            _chip(Icons.access_time_filled_rounded,
                                '${d.firstTrain}–${d.lastTrain}', d.color),
                            const SizedBox(width: 6),
                            _chip(
                                Icons.schedule_rounded,
                                '${d.travelMinutes}${l10n.minutesAbbr}',
                                d.color),
                            const SizedBox(width: 6),
                            _chip(
                                Icons.straighten_rounded,
                                '${d.distanceKm.toStringAsFixed(0)} km',
                                d.color),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Expandable station list
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              child: _expanded
                  ? _StationList(
                      stations: d.stations,
                      color: d.color,
                      l10n: l10n,
                      lineId: d.id,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color lineColor) => Container(
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

  Widget _terminusDot(Color color, bool faded) => Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          color: faded ? Colors.grey.shade300 : color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: (faded ? Colors.grey : color).withOpacity(0.35),
              blurRadius: 4,
            ),
          ],
        ),
      );
}

// ── Station list ──────────────────────────────────────────────────────────────

class _StationList extends StatelessWidget {
  final List<StationEntry> stations;
  final Color color;
  final AppLocalizations l10n;
  final String lineId;

  const _StationList({
    required this.stations,
    required this.color,
    required this.l10n,
    required this.lineId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 20, color: Colors.grey.shade200),
          Text(
            l10n.intermediateStationsTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          ...stations
              .asMap()
              .entries
              .map((e) => _stationRow(e.key, e.value, stations.length, lineId)),
        ],
      ),
    );
  }

  Widget _stationRow(int idx, StationEntry s, int total, String currentLineId) {
    final isFirst = idx == 0;
    final isLast = idx == total - 1;
    final isTerminus = isFirst || isLast;

    // Find other lines this station connects to (excluding current line)
    final transferLineIds = s.isTransfer
        ? (_kStationTransfers[s.en] ?? [])
            .where((id) => id != currentLineId)
            .toList()
        : <String>[];

    // If transferring, use the first other line's color for the dot border
    final otherLineColor = transferLineIds.isNotEmpty
        ? _lineColorById(transferLineIds.first)
        : color;

    // Dot size & fill
    final double dotSize = isTerminus ? 12 : (s.isTransfer ? 11 : 7);
    final Color dotFill = s.isUnderConstruction
        ? Colors.grey.shade400
        : (isTerminus
            ? color
            : (s.isTransfer ? Colors.white : color.withOpacity(0.55)));
    final Color dotBorder = s.isUnderConstruction
        ? Colors.grey.shade400
        : (s.isTransfer && !isTerminus ? otherLineColor : color);

    final railColor =
        s.isUnderConstruction ? Colors.grey.shade300 : color.withOpacity(0.35);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Rail column
        SizedBox(
          width: 24,
          child: Column(
            children: [
              if (!isFirst) Container(width: 2, height: 8, color: railColor),
              Container(
                width: dotSize,
                height: dotSize,
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: dotFill,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: dotBorder,
                    width: isTerminus ? 2.5 : (s.isTransfer ? 2.5 : 1.5),
                  ),
                ),
              ),
              if (!isLast) Container(width: 2, height: 8, color: railColor),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // ── Name + transfer indicator
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // EN name + (optional) transfer connector on same row
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      s.en,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isTerminus || s.isTransfer
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: s.isUnderConstruction
                            ? Colors.grey.shade500
                            : (isTerminus
                                ? const Color(0xFF184D56)
                                : Colors.grey.shade800),
                      ),
                    ),
                    if (s.isUnderConstruction) ...[
                      const SizedBox(width: 6),
                      _badge(l10n.underConstructionLabel,
                          Colors.orange.shade700, Colors.orange.shade50),
                    ],
                    if (transferLineIds.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      // Gradient line — always fills remaining space
                      Expanded(
                        child: Container(
                          height: 1.5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _lineColorById(transferLineIds.first)
                                    .withOpacity(0.15),
                                _lineColorById(transferLineIds.first)
                                    .withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Badge always flush right
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: _lineColorById(transferLineIds.first)
                              .withOpacity(0.10),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: _lineColorById(transferLineIds.first)
                                  .withOpacity(0.45)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                  color: _lineColorById(transferLineIds.first),
                                  shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _lineLabel(transferLineIds.first),
                              style: TextStyle(
                                fontSize: 9,
                                color: _lineColorById(transferLineIds.first),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                // AR name below
                Text(
                  s.ar,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 11,
                    color: s.isUnderConstruction
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    fontWeight: isTerminus || s.isTransfer
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge(String label, Color fg, Color bg) => Container(
        margin: const EdgeInsets.only(left: 4, top: 2),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: fg,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
}

// ── Dashed line painter ───────────────────────────────────────────────────────

class _ModalDashedLine extends CustomPainter {
  final Color color;
  const _ModalDashedLine({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dashW = 5.0;
    const dashGap = 4.0;
    final y = size.height / 2;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + dashW).clamp(0.0, size.width), y),
        paint,
      );
      x += dashW + dashGap;
    }
  }

  @override
  bool shouldRepaint(_ModalDashedLine old) => old.color != color;
}
