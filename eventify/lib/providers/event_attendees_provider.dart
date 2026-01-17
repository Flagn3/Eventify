import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/services/event_attendees_service.dart';
import 'package:flutter/material.dart';

class EventAttendeesProvider extends ChangeNotifier {

  String? errorMessage;
  bool loading = false;
  final UserProvider userProvider;
  final EventAttendeesService _eventService = EventAttendeesService();

  EventAttendeesProvider(this.userProvider);

    //register event
  Future<void> registerEvent(int userId, int eventId) async {
    errorMessage = null;
    loading = true;
    notifyListeners();
    final token =  userProvider.activeUser?.rememberToken;

    if (token == null) {
      errorMessage = "No hay usuario autenticado.";
      return;
    }
    try {
     final response = await _eventService.registerEvent(userId, eventId, token);

    if (!response.success) {
      errorMessage = response.message;
    }

    } catch (e) {
      errorMessage = "Error inesperado: $e";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

      //unregister event
  Future<void> unregisterEvent(int userId, int eventId) async {
    errorMessage = null;
    loading = true;
    notifyListeners();
  final token =  userProvider.activeUser?.rememberToken;

    if (token == null) {
      errorMessage = "No hay usuario autenticado.";
      return;
    }
    try {
      final response = await _eventService.unregisterEvent(userId, eventId, token);

      if (!response.success) {
      errorMessage = response.message;
    }

    } catch (e) {
      errorMessage = "Error inesperado: $e";
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}