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

  factory EventAttendeesResponse.fromJson(Map<String, dynamic> json) => EventAttendeesResponse(
    success: json['success'], 
    data: (json['data'] as List)
    .map((eventJson) => EventAttendees.fromEventsAttendeesJson(eventJson)).toList(), 
    message: json['message']
  );
}