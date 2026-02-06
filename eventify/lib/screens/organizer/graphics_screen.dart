import 'package:eventify/models/event.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphicsScreen extends StatefulWidget {
  const GraphicsScreen({super.key});

  @override
  State<GraphicsScreen> createState() => _GraphicsScreenState();
}

class _GraphicsScreenState extends State<GraphicsScreen> {
  String? selectedCategory;

  // Cargar categorías
  final List<String> allCategories = const [
    'Music',
    'Sport',
    'Technology',
    'Cultural',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStats());
  }

  Future<void> _loadStats() async {
    final userId = Provider.of<EventProvider>(
      context,
      listen: false,
    ).userProvider.activeUser?.id;
    if (userId != null) {
      await Provider.of<EventProvider>(
        context,
        listen: false,
      ).getEventsByOrganizerForStats(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final events = eventProvider.eventsByOrganizerForStats;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Eventos creados (últimos 4 meses)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Dropdown de categorías
          DropdownButtonFormField<String>(
            value: selectedCategory,
            hint: const Text('Selecciona una categoría'),
            isExpanded: true,
            items: allCategories.map((category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Gráfica
          Expanded(
            child: selectedCategory == null
                ? const Center(child: Text('Selecciona una categoría'))
                : _buildChart(events, selectedCategory!),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<Event> events, String category) {
    final data = _countEventsByMonth(events, category);

    // Ordenamos los meses del más antiguo al más reciente
    final sortedKeys = data.keys.toList()..sort((a, b) => b.compareTo(a));
    final maxY = data.values.isEmpty
        ? 1
        : data.values.reduce((a, b) => a > b ? a : b) + 1;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY.toDouble(),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text(_monthLabel(value.toInt())),
            ),
          ),
        ),
        barGroups: sortedKeys.map((key) {
          return BarChartGroupData(
            x: key,
            barRods: [
              BarChartRodData(
                toY: data[key]!.toDouble(),
                width: 22,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Map<int, int> _countEventsByMonth(List<Event> events, String category) {
    final now = DateTime.now();

    final Map<int, int> result = {for (int i = 1; i <= 4; i++) i: 0};

    for (final event in events) {
      if (event.category != category) continue;

      final diffMonths =
          (now.year - event.startTime.year) * 12 +
          now.month -
          event.startTime.month;

      if (diffMonths >= 1 && diffMonths <= 4) {
        result[diffMonths] = result[diffMonths]! + 1;
      }
    }

    return result;
  }

  String _monthLabel(int diff) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month - diff);
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return months[date.month - 1];
  }
}
