import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/events_service.dart';

class EventsProvider with ChangeNotifier {
  final EventsService _eventsService = EventsService();
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEvents(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _eventsService.getEvents(token);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
