import 'package:eventify/models/event.dart';

class EventResponse {

  final bool success;
  final List<Event> data;
  final String message;

  EventResponse({
    required this.success,
    required this.data,
    required this.message
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    List<Event> parsedData = [];

    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        // Cuando devuelve un solo objeto
        parsedData = [Event.fromEventsJson(json['data'])];
      } else if (json['data'] is List) {
        // Cuando devuelve una lista
        parsedData = (json['data'] as List)
            .map((e) => Event.fromEventsJson(e))
            .toList();
      }
    }

    return EventResponse(
      success: json['success'] ?? false,
      data: parsedData,
      message: json['message'] ?? '',
    );
  }
}