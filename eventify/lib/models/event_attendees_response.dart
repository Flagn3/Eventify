import 'package:eventify/models/event_attendees.dart';

class EventAttendeesResponse {

  final bool success;
  final List<EventAttendees> data;
  final String message;

  EventAttendeesResponse({
    required this.success,
    required this.data,
    required this.message
  });

  factory EventAttendeesResponse.fromJson(Map<String, dynamic> json) {
    List<EventAttendees> parsedData = [];

    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        // Cuando devuelve un solo objeto
        parsedData = [EventAttendees.fromEventsAttendeesJson(json['data'])];
      } else if (json['data'] is List) {
        // Cuando devuelve una lista (por ejemplo otros endpoints)
        parsedData = (json['data'] as List)
            .map((e) => EventAttendees.fromEventsAttendeesJson(e))
            .toList();
      }
    }

    return EventAttendeesResponse(
      success: json['success'] ?? false,
      data: parsedData,
      message: json['message'] ?? '',
    );
  }
}