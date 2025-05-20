import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventsService {
  static const String _baseUrl = 'https://eventapi.woodesy.com/v1/api';

  Future<List<Event>> getEvents(
    String token, {
    int limit = 20,
    int page = 1,
    String orderBy = 'created_at',
    String sortedBy = 'desc',
    String language = 'en',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/events?limit=$limit&page=$page&orderBy=$orderBy&sortedBy=$sortedBy&language=$language'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> eventsJson = data['data'];
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }
}
