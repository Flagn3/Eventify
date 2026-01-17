import 'dart:io';
import 'package:eventify/models/event.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime? startDate;
  DateTime? endDate;

  // Estado de los checkboxes (UI)
  final Map<String, bool> categorySelection = {
    'Música': false,
    'Deporte': false,
    'Tecnología': false,
    'Cultural': false,
  };

  // Mapeo UI -> Backend
  final Map<String, String> categoryMap = {
    'Música': 'Music',
    'Deporte': 'Sport',
    'Tecnología': 'Technology',
    'Cultural': 'Cultural',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Generar informe de eventos",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildDateField("Fecha inicio", startDate, (date) {
            if (!mounted) return;
            setState(() => startDate = date);
          }),

          _buildDateField("Fecha fin", endDate, (date) {
            if (!mounted) return;
            setState(() => endDate = date);
          }),

          const SizedBox(height: 16),
          const Text(
            "Tipos de evento",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          ...categorySelection.keys.map((key) {
            return CheckboxListTile(
              title: Text(key),
              value: categorySelection[key],
              onChanged: (value) {
                if (!mounted) return;
                setState(() => categorySelection[key] = value ?? false);
              },
            );
          }),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _handleGeneratePdf,
            child: const Text("Generar y abrir PDF"),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? value,
    Function(DateTime) onSelected,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(
        value == null
            ? "Seleccionar fecha"
            : "${value.day}-${value.month}-${value.year}",
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (!mounted) return;
        if (date != null) onSelected(date);
      },
    );
  }

  List<Event> _filterEvents(List<Event> allEvents) {
    final selectedCategories = categorySelection.entries
        .where((entry) => entry.value)
        .map((entry) => categoryMap[entry.key])
        .whereType<String>()
        .toList();

    DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    return allEvents.where((event) {
      final eventDate = _dateOnly(event.startTime);

      final matchStart =
          !eventDate.isBefore(_dateOnly(startDate!));
      final matchEnd =
          !eventDate.isAfter(_dateOnly(endDate!));

      final matchCategory =
          selectedCategories.isEmpty ||
          selectedCategories.contains(event.category);

      return matchStart && matchEnd && matchCategory;
    }).toList();
  }

  Future<File> _generatePdf(List<Event> eventsToShow) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (_) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Informe de eventos",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                "Fecha inicio: ${startDate!.day}-${startDate!.month}-${startDate!.year}",
              ),
              pw.Text(
                "Fecha fin: ${endDate!.day}-${endDate!.month}-${endDate!.year}",
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                "Eventos:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Table.fromTextArray(
                headers: ["Título", "Fecha", "Categoría"],
                data: eventsToShow.map((e) {
                  return [
                    e.title,
                    "${e.startTime.day}-${e.startTime.month}-${e.startTime.year}",
                    e.category,
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/informe_eventos.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _handleGeneratePdf() async {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debes seleccionar fecha de inicio y fin"),
        ),
      );
      return;
    }

    final eventProvider = context.read<EventProvider>();
    final allEvents = await eventProvider.getAllEventsForReport();
    if (!mounted) return;

    final filteredEvents = _filterEvents(allEvents);

    if (filteredEvents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No hay eventos que cumplan los filtros."),
        ),
      );
      return;
    }

    final file = await _generatePdf(filteredEvents);
    if (!mounted) return;

    await OpenFile.open(file.path);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("PDF generado y abierto correctamente"),
      ),
    );
  }
}
