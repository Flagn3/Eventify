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

  factory EventResponse.fromJson(Map<String, dynamic> json) => EventResponse(
    success: json['success'], 
    data: (json['data'] as List)
    .map((eventJson) => Event.fromEventsJson(eventJson)).toList(), 
    message: json['message']
  );
}
