import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_details.dart';

class OrderService {
  static const String baseUrl = 'https://eventapi.woodesy.com/v1/api';
  final String bearerToken;

  OrderService({required this.bearerToken});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };

  Future<OrderDetails> getOrderDetails(String trackingNumber) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/orders/mobile/order-details?tracking_number=$trackingNumber'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return OrderDetails.fromJson(jsonResponse['data']);
        } else {
          throw Exception(
              'Failed to load order details: ${jsonResponse['message']}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to load order details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load order details: $e');
    }
  }

  Future<bool> verifyTicket(String trackingNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/mobile/verify-ticket'),
        headers: _headers,
        body: json.encode({'tracking_number': trackingNumber}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success';
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to verify ticket: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to verify ticket: $e');
    }
  }

  Future<bool> updateScanCount(String trackingNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/update-scan-count'),
        headers: _headers,
        body: json.encode({'tracking_number': trackingNumber}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success';
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to update scan count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update scan count: $e');
    }
  }
}
