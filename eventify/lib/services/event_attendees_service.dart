import 'dart:convert';
import 'package:eventify/models/event_attendees_response.dart';
import 'package:http/http.dart' as http;

class EventAttendeesService {
  static const String _baseUrl = 'https://eventify.iaknowhow.es/public/api';

  //Register Event
  Future<EventAttendeesResponse> registerEvent(int userId, int eventId, String token) async {
    Uri url = Uri.parse('$_baseUrl/registerEvent');

    final response = await http.post(
      url,
      body: json.encode({'user_id' : userId, 'event_id': eventId, 'registered_at' : DateTime.now().toIso8601String()}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'} 
    );

    final eventAttendessResponse = EventAttendeesResponse.fromJson(json.decode(response.body));

    return eventAttendessResponse;
  }

    //Unregister Event
  Future<EventAttendeesResponse> unregisterEvent(int userId, int eventId, String token) async {
    Uri url = Uri.parse('$_baseUrl/unregisterEvent');

    final response = await http.post(
      url,
      body: json.encode({'user_id' : userId, 'event_id': eventId}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'} 
    );

    final eventAttendessResponse = EventAttendeesResponse.fromJson(json.decode(response.body));

    return eventAttendessResponse;
  }
}