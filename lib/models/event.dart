import 'package:intl/intl.dart';

class Event {
  final String id;
  final String title;
  final String location;
  final String eventTime;
  final DateTime mainDate;
  final String? image;
  final String status;
  final int organizerId;
  final int categoryId;
  final int totalQuantity;
  final int totalSoldQuantity;
  final String slug;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.eventTime,
    required this.mainDate,
    this.image,
    required this.status,
    required this.organizerId,
    required this.categoryId,
    required this.totalQuantity,
    required this.totalSoldQuantity,
    required this.slug,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'],
      location: json['location'],
      eventTime: json['eventTime'],
      mainDate: DateTime.parse(json['mainDate']),
      image: json['image'],
      status: json['status'],
      organizerId: json['organizer_id'],
      categoryId: json['category_id'],
      totalQuantity: json['total_quantity'],
      totalSoldQuantity: json['total_sold_quantity'],
      slug: json['slug'],
      language: json['language'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get formattedDate {
    return DateFormat('dd MMM yyyy').format(mainDate);
  }
}
