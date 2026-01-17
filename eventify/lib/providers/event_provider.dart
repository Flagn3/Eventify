import 'package:eventify/models/event.dart';
import 'package:eventify/models/event_response.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/services/event_service.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final EventService _eventService = EventService();
  final UserProvider userProvider;

  List<Event> events = [];
  List<Event> myEvents = [];
  bool isLoading = false;
  String? errorMessage;
  String? activeCategory;

  EventProvider(this.userProvider);

  // --- FLAG PARA EVITAR LLAMAR notifyListeners DESPUÉS DE DISPOSE ---
  bool _disposed = false;

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // ----------- MÉTODOS EXISTENTES (sin cambios) -----------

  Future<void> getAllEvents() async {
    try {
      isLoading = true;
      errorMessage = null;
      safeNotifyListeners();

      final token = userProvider.activeUser?.rememberToken;

      if (token == null) {
        errorMessage = "No hay usuario autenticado.";
        return;
      }

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
      safeNotifyListeners();
    }
  }

  Future<void> getEvents() async {
    activeCategory = null;
    await getAllEvents();
    final now = DateTime.now();
    events = events.where((e) => e.startTime.isAfter(now)).toList();
    await getEventsByUser(userProvider.activeUser!.id);
    filterOutMyEvents();
    ordeByDate();
    safeNotifyListeners();
  }

  Future<void> getEventsByCategory(String categoryName) async {
    await getAllEvents();
    events = events.where((e) => e.category == categoryName).toList();
    ordeByDate();
    safeNotifyListeners();
  }

  Future<void> getUpcomingEventsByCategory(String categoryName) async {
    activeCategory = categoryName;
    await getAllEvents();
    final now = DateTime.now();
    events = events
        .where((e) => e.category == categoryName && e.startTime.isAfter(now))
        .toList();
    filterOutMyEvents();
    ordeByDate();
    safeNotifyListeners();
  }

  void ordeByDate() {
    events.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Future<void> getEventsByUser(int id) async {
    try {
      isLoading = true;
      errorMessage = null;
      safeNotifyListeners();

      final token = userProvider.activeUser?.rememberToken;

      if (token == null) {
        errorMessage = "No hay usuario autenticado.";
        return;
      }

      EventResponse response = await _eventService.getEventsByUser(id, token);

      if (response.success == true) {
        myEvents = response.data;
        myEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = "Error inesperado: $e";
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  void filterOutMyEvents() {
    if (myEvents.isEmpty) return;

    final myEventIds = myEvents.map((e) => e.id).toSet();
    events = events.where((event) => !myEventIds.contains(event.id)).toList();
  }

  Future<List<Event>> getAllEventsForReport() async {
    try {
      final token = userProvider.activeUser?.rememberToken;
      if (token == null) return [];

      final response = await _eventService.getEvents(token);
      if (response.success) {
        return response.data;
      }
    } catch (e) {
      print("Error al obtener todos los eventos: $e");
    }
    return [];
  }
}
