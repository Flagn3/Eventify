import 'dart:convert';

import 'package:eventify/models/event_response.dart';
import 'package:http/http.dart' as http;

class EventService {

  static const String _baseUrl = 'https://eventify.iaknowhow.es/public/api';

  Future<EventResponse> getEvents(String token) async {

    Uri url = Uri.parse('$_baseUrl/events');

    final response = await http.get(
      url,
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token'}
    );

    final eventResponse = EventResponse.fromJson(json.decode(response.body));

    return eventResponse;
  }

  Future<EventResponse> getEventsByUser(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/eventsByUser');

    final response = await http.post(
      url,
      body: json.encode({'id' : id}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final eventResponse = EventResponse.fromJson(json.decode(response.body));

    return eventResponse;
  }

    Future<EventResponse> getEventsByOrganizer(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/eventsByOrganizer');

    final response = await http.post(
      url,
      body: json.encode({'id' : id}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final eventResponse = EventResponse.fromJson(json.decode(response.body));

    return eventResponse;
  }

  Future<EventResponse> eventDelete(int id, String token) async {
    Uri url = Uri.parse('$_baseUrl/eventDelete');

    final response = await http.post(
      url,
      body: json.encode({'id' : id}),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final eventResponse = EventResponse.fromJson(json.decode(response.body));

    return eventResponse;
  }

  Future<EventResponse> eventUpdate(int id,int organizerId, String title, 
                                    String description, String category, DateTime startTime,
                                    DateTime endTime, String location, int? latitude,
                                    int? longitude, int? maxAtendees, int? price,
                                    String imageUrl ,String token) async {
    Uri url = Uri.parse('$_baseUrl/eventUpdate');

    final response = await http.post(
      url,
      body: json.encode({'id' : id,
                         'organizer_id' : organizerId,
                         'title' : title,
                         'description' : description,
                         'category' : category,
                         'start_time' : startTime,
                         'end_time' : endTime,
                         'location' : location,
                         'latitude' : latitude,
                         'longitude' : longitude,
                         'max_attendees' : maxAtendees,
                         'price' : price,
                         'image_url' : imageUrl
                         }),
      headers: {'Accept' : 'application/json', 'Authorization' : 'Bearer $token' , 'Content-Type' : 'application/json'}
    );

    final eventResponse = EventResponse.fromJson(json.decode(response.body));

    return eventResponse;
  }

}

