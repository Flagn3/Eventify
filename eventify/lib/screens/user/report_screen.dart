import 'dart:io';
import 'package:eventify/models/event.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
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

  final Map<String, bool> categories = {
    'Música': false,
    'Deporte': false,
    'Tecnología': false,
    'Cultural': false,
  };

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.getUsers();
    if (!mounted) return;

    if (userProvider.activeUser != null) {
      try {
        final user = userProvider.userList.firstWhere(
          (u) => u.id == userProvider.activeUser!.id,
        );
        userProvider.activeUser!.email = user.email;
      } catch (_) {
        userProvider.activeUser!.email = null;
      }
    }
  }

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
          ...categories.keys.map((key) {
            return CheckboxListTile(
              title: Text(key),
              value: categories[key],
              onChanged: (value) {
                if (!mounted) return;
                setState(() => categories[key] = value ?? false);
              },
            );
          }),
          const SizedBox(height: 24),
          Row(
            children: [
              // Botón Generar PDF
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleGeneratePdf(),
                  child: const Text("Generar PDF"),
                ),
              ),
              const SizedBox(width: 16),
              // Botón Enviar PDF
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleSendPdf(),
                  child: const Text("Enviar PDF"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime? value, Function(DateTime) onSelected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(
        value == null ? "Seleccionar fecha" : "${value.day}-${value.month}-${value.year}",
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
    final selectedCategories = categories.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    return allEvents.where((event) {
      final eventDate = _dateOnly(event.startTime);
      final matchStart = startDate == null || !eventDate.isBefore(_dateOnly(startDate!));
      final matchEnd = endDate == null || !eventDate.isAfter(_dateOnly(endDate!));
      final matchCategory = selectedCategories.isEmpty || selectedCategories.contains(event.category);
      return matchStart && matchEnd && matchCategory;
    }).toList();
  }

  Future<File> _generatePdf(List<Event> eventsToShow) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Informe de eventos",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              if (startDate != null)
                pw.Text("Fecha inicio: ${startDate!.day}-${startDate!.month}-${startDate!.year}"),
              if (endDate != null)
                pw.Text("Fecha fin: ${endDate!.day}-${endDate!.month}-${endDate!.year}"),
              pw.SizedBox(height: 16),
              pw.Text("Eventos:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Table.fromTextArray(
                headers: ["Título", "Fecha", "Categoría"],
                data: eventsToShow
                    .map((e) => [
                          e.title,
                          "${e.startTime.day}-${e.startTime.month}-${e.startTime.year}",
                          e.category
                        ])
                    .toList(),
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
    final eventProvider = context.read<EventProvider>();
    final allEvents = await eventProvider.getAllEventsForReport();
    if (!mounted) return;

    final filteredEvents = _filterEvents(allEvents);
    if (filteredEvents.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay eventos que cumplan los filtros.")),
      );
      return;
    }

    final file = await _generatePdf(filteredEvents);
    if (!mounted) return;

    // Abrir PDF automáticamente
    await OpenFile.open(file.path);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF guardado y abierto en: ${file.path}")),
    );
  }

  Future<void> _handleSendPdf() async {
    final eventProvider = context.read<EventProvider>();
    final userProvider = context.read<UserProvider>();
    final allEvents = await eventProvider.getAllEventsForReport();
    if (!mounted) return;

    final filteredEvents = _filterEvents(allEvents);
    if (filteredEvents.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay eventos que cumplan los filtros.")),
      );
      return;
    }

    final file = await _generatePdf(filteredEvents);
    if (!mounted) return;

    final userEmail = userProvider.activeUser?.email;
    if (userEmail == null || userEmail.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo obtener el email del usuario logueado")),
      );
      return;
    }

    await OpenFile.open(file.path);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF listo para enviar a $userEmail")),
    );
  }
}
