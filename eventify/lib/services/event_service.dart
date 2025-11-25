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

}