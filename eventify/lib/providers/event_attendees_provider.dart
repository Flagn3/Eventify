import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/services/event_attendees.dart';
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
      await _eventService.registerEvent(userId, eventId, token);

    } catch (e) {
      errorMessage = e.toString();
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
      await _eventService.unregisterEvent(userId, eventId, token);

    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}