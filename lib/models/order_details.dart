import 'package:intl/intl.dart';

class OrderDetails {
  final String id;
  final String trackingNumber;
  final String customerId;
  final String customerContact;
  final String customerName;
  final double amount;
  final double salesTax;
  final double paidTotal;
  final double total;
  final String? couponId;
  final double discount;
  final String paymentGateway;
  final String? alteredPaymentGateway;
  final String? shippingAddress;
  final String? billingAddress;
  final String? logisticsProvider;
  final double deliveryFee;
  final String? deliveryTime;
  final String orderStatus;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String language;
  final double cancelledAmount;
  final double cancelledTax;
  final double cancelledDeliveryFee;
  final String? note;
  final String customerEmail;
  final int eventId;
  final String currencyCode;
  final double? resellAmount;
  final String? resellerTrackingNo;
  final double usdAmount;
  final int scanCount;

  OrderDetails({
    required this.id,
    required this.trackingNumber,
    required this.customerId,
    required this.customerContact,
    required this.customerName,
    required this.amount,
    required this.salesTax,
    required this.paidTotal,
    required this.total,
    this.couponId,
    required this.discount,
    required this.paymentGateway,
    this.alteredPaymentGateway,
    this.shippingAddress,
    this.billingAddress,
    this.logisticsProvider,
    required this.deliveryFee,
    this.deliveryTime,
    required this.orderStatus,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.language,
    required this.cancelledAmount,
    required this.cancelledTax,
    required this.cancelledDeliveryFee,
    this.note,
    required this.customerEmail,
    required this.eventId,
    required this.currencyCode,
    this.resellAmount,
    this.resellerTrackingNo,
    required this.usdAmount,
    required this.scanCount,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'].toString(),
      trackingNumber: json['tracking_number'],
      customerId: json['customer_id'].toString(),
      customerContact: json['customer_contact'],
      customerName: json['customer_name'],
      amount: (json['amount'] as num).toDouble(),
      salesTax: (json['sales_tax'] as num).toDouble(),
      paidTotal: (json['paid_total'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      couponId: json['coupon_id'],
      discount: (json['discount'] as num).toDouble(),
      paymentGateway: json['payment_gateway'],
      alteredPaymentGateway: json['altered_payment_gateway'],
      shippingAddress: json['shipping_address'],
      billingAddress: json['billing_address'],
      logisticsProvider: json['logistics_provider'],
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      deliveryTime: json['delivery_time'],
      orderStatus: json['order_status'],
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      language: json['language'],
      cancelledAmount: (json['cancelled_amount'] as num).toDouble(),
      cancelledTax: (json['cancelled_tax'] as num).toDouble(),
      cancelledDeliveryFee: (json['cancelled_delivery_fee'] as num).toDouble(),
      note: json['note'],
      customerEmail: json['customer_email'],
      eventId: json['event_id'],
      currencyCode: json['currency_code'],
      resellAmount: json['resell_amount'] != null
          ? (json['resell_amount'] as num).toDouble()
          : null,
      resellerTrackingNo: json['reseller_tracking_no'],
      usdAmount: (json['usd_amount'] as num).toDouble(),
      scanCount: json['scan_count'],
    );
  }

  String get formattedDate {
    return DateFormat('dd MMM yyyy').format(createdAt);
  }

  String get formattedTime {
    return DateFormat('hh:mm a').format(createdAt);
  }
}
