class ReviewModel {
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceToken;
  final String customerId;
  final String feadback;
  final String rating;
  final dynamic createdAt;

  ReviewModel({
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerDeviceToken,
    required this.customerId,
    required this.feadback,
    required this.rating,
    required this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerDeviceToken': customerDeviceToken,
      'customerId': customerId,
      'feadback': feadback,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> json) {
    return ReviewModel(
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      customerDeviceToken: json['customerDeviceToken'],
      customerId: json['customerId'],
      feadback: json['feadback'],
      rating: json['rating'],
      createdAt: json['createdAt'],
    );
  }
}
