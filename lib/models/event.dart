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
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      eventTime: json['eventTime']?.toString() ?? '',
      mainDate: DateTime.parse(
          json['mainDate']?.toString() ?? DateTime.now().toIso8601String()),
      image: json['image']?.toString(),
      status: json['status']?.toString() ?? '',
      organizerId: int.tryParse(json['organizer_id']?.toString() ?? '0') ?? 0,
      categoryId: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      totalQuantity:
          int.tryParse(json['total_quantity']?.toString() ?? '0') ?? 0,
      totalSoldQuantity:
          int.tryParse(json['total_sold_quantity']?.toString() ?? '0') ?? 0,
      slug: json['slug']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      createdAt: DateTime.parse(
          json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }

  String get formattedDate {
    return DateFormat('dd MMM yyyy').format(mainDate);
  }
}
