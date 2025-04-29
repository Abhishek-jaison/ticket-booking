import 'package:flutter/material.dart';

class Event {
  final String id;
  final String name;
  final String imageUrl;
  final String date;
  final String venue;
  final String time;

  Event({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.date,
    required this.venue,
    required this.time,
  });
}

class Ticket {
  final String id;
  final String eventId;
  final String name;
  final String seatNo;
  bool isVerified;

  Ticket({
    required this.id,
    required this.eventId,
    required this.name,
    required this.seatNo,
    this.isVerified = false,
  });
}

class EventProvider with ChangeNotifier {
  final List<Event> _events = [
    Event(
      id: '1',
      name: 'Summer Music Festival',
      imageUrl:
          'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800&auto=format&fit=crop&q=60',
      date: '2024-07-15',
      venue: 'Central Park',
      time: '6:00 PM',
    ),
    Event(
      id: '2',
      name: 'Tech Conference 2024',
      imageUrl:
          'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800&auto=format&fit=crop&q=60',
      date: '2024-08-20',
      venue: 'Convention Center',
      time: '9:00 AM',
    ),
    Event(
      id: '3',
      name: 'Food & Wine Expo',
      imageUrl:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&auto=format&fit=crop&q=60',
      date: '2024-09-10',
      venue: 'Grand Hotel',
      time: '11:00 AM',
    ),
    Event(
      id: '4',
      name: 'Comedy Night Special',
      imageUrl:
          'https://images.unsplash.com/photo-1547332184-91cc2a8854a0?w=800&auto=format&fit=crop&q=60',
      date: '2024-07-25',
      venue: 'Laugh Factory',
      time: '8:00 PM',
    ),
    Event(
      id: '5',
      name: 'Art Exhibition: Modern Masters',
      imageUrl:
          'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800&auto=format&fit=crop&q=60',
      date: '2024-08-05',
      venue: 'Modern Art Museum',
      time: '10:00 AM',
    ),
    Event(
      id: '6',
      name: 'Sports Championship Finals',
      imageUrl:
          'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=800&auto=format&fit=crop&q=60',
      date: '2024-08-15',
      venue: 'City Stadium',
      time: '7:30 PM',
    ),
    Event(
      id: '7',
      name: 'Fashion Week 2024',
      imageUrl:
          'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&auto=format&fit=crop&q=60',
      date: '2024-09-01',
      venue: 'Fashion District',
      time: '6:00 PM',
    ),
    Event(
      id: '8',
      name: 'Film Festival Premiere',
      imageUrl:
          'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&auto=format&fit=crop&q=60',
      date: '2024-09-20',
      venue: 'Cinema Palace',
      time: '7:00 PM',
    ),
    Event(
      id: '9',
      name: 'Gaming Expo 2024',
      imageUrl:
          'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&auto=format&fit=crop&q=60',
      date: '2024-10-05',
      venue: 'Gaming Arena',
      time: '10:00 AM',
    ),
    Event(
      id: '10',
      name: 'Jazz in the Park',
      imageUrl:
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&auto=format&fit=crop&q=60',
      date: '2024-10-15',
      venue: 'Riverside Park',
      time: '5:00 PM',
    ),
    Event(
      id: '11',
      name: 'Science & Innovation Fair',
      imageUrl:
          'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=800&auto=format&fit=crop&q=60',
      date: '2024-10-25',
      venue: 'Science Center',
      time: '9:00 AM',
    ),
    Event(
      id: '12',
      name: 'Christmas Market',
      imageUrl:
          'https://images.unsplash.com/photo-1513889961551-628c1e5e2ee9?w=800&auto=format&fit=crop&q=60',
      date: '2024-12-15',
      venue: 'Town Square',
      time: '11:00 AM',
    ),
  ];

  final List<Ticket> _tickets = [
    Ticket(id: 'TICKET001', eventId: '1', name: 'John Doe', seatNo: 'A-101'),
    Ticket(id: 'TICKET002', eventId: '2', name: 'Jane Smith', seatNo: 'B-202'),
    Ticket(
      id: 'TICKET003',
      eventId: '3',
      name: 'Mike Johnson',
      seatNo: 'C-303',
    ),
    Ticket(
      id: 'TICKET004',
      eventId: '4',
      name: 'Sarah Williams',
      seatNo: 'D-404',
    ),
    Ticket(id: 'TICKET005', eventId: '5', name: 'David Brown', seatNo: 'E-505'),
  ];

  List<Event> get events => _events;
  List<Ticket> get tickets => _tickets;

  Ticket? verifyTicket(String ticketId) {
    final ticket = _tickets.firstWhere(
      (ticket) => ticket.id == ticketId,
      orElse: () => throw Exception('Invalid ticket'),
    );

    if (ticket.isVerified) {
      throw Exception('Ticket already verified');
    }

    ticket.isVerified = true;
    notifyListeners();
    return ticket;
  }

  Event? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }
}
