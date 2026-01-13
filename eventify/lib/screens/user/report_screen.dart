import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Generar informe de eventos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),

          _buildDateField("Fecha inicio", startDate, (date) {
            setState(() => startDate = date);
          }),

          _buildDateField("Fecha fin", endDate, (date) {
            setState(() => endDate = date);
          }),

          const SizedBox(height: 16),

          const Text("Tipos de evento",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          ...categories.keys.map((key) {
            return CheckboxListTile(
              title: Text(key),
              value: categories[key],
              onChanged: (value) {
                setState(() => categories[key] = value ?? false);
              },
            );
          }),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: generar PDF
                  },
                  child: const Text("Generar PDF"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: enviar PDF
                  },
                  child: const Text("Enviar PDF"),
                ),
              ),
            ],
          )
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
        if (date != null) onSelected(date);
      },
    );
  }
}
