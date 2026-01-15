import 'package:eventify/models/event.dart';
import 'package:eventify/models/event_response.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/services/event_service.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {

  final EventService _eventService = EventService();
  final UserProvider userProvider;

  List<Event> events = [];
  bool isLoading = false;
  String? errorMessage;
  String? activeCategory;

  EventProvider(this.userProvider);

 // List of events
  Future<void> getAllEvents() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token =  userProvider.activeUser?.rememberToken;   // User token

      if (token == null) {
        errorMessage = "No hay usuario autenticado.";
        return;
      }

      // call to EventService getEvents
      EventResponse response = await _eventService.getEvents(token);

      if (response.success == true) {
        events = response.data;
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = "Error inesperado: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //List events by dateTime
  Future<void> getEvents() async {
    activeCategory = null;
    await getAllEvents();
    final now = DateTime.now();
    events = events.where((e) => e.startTime.isAfter(now)).toList();
    ordeByDate();
    notifyListeners();
  }

    // Events by category
  Future<void> getEventsByCategory(String categoryName) async {
    await getAllEvents();
    events = events.where((e) => e.category == categoryName).toList();
    ordeByDate();
    notifyListeners();
  }

  // Events by category and future than now
  Future<void> getUpcomingEventsByCategory(String categoryName) async {
    activeCategory = categoryName;
    await getAllEvents();
    final now = DateTime.now();
    events = events
      .where((e) => e.category == categoryName && e.startTime.isAfter(now))
        .toList();
    ordeByDate();
    notifyListeners();
  }

  void ordeByDate (){
    events.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  //Events by user
  Future<void> getEventsByUser(int id) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token =  userProvider.activeUser?.rememberToken;   // User token

      if (token == null) {
        errorMessage = "No hay usuario autenticado.";
        return;
      }

      // call to EventService getEvents
      EventResponse response = await _eventService.getEventsByUser(id, token);


      if (response.success == true) {
        events = response.data;
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = "Error inesperado: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}