//  "order_url": "string",
//   "order_token": "string",
//   "return_message": "string",
//   "sub_return_message": "string",
//   "sub_return_code": 0,
//   "cashier_order_url": "string",
//   "qr_code": "string",
//   "zp_trans_token": "s

class ZalopayResponse {
  final String orderUrl;
  final String orderToken;
  final String returnMessage;
  final String subReturnMessage;
  final int subReturnCode;
  final String cashierOrderUrl;
  final String qrCode;
  final String zpTransToken;
  ZalopayResponse({
    required this.orderUrl,
    required this.orderToken,
    required this.returnMessage,
    required this.subReturnMessage,
    required this.subReturnCode,
    required this.cashierOrderUrl,
    required this.qrCode,
    required this.zpTransToken,
  });
  factory ZalopayResponse.fromJson(Map<String, dynamic> json) {
    return ZalopayResponse(
      orderUrl: json['order_url'] as String,
      orderToken: json['order_token'] as String,
      returnMessage: json['return_message'] as String,
      subReturnMessage: json['sub_return_message'] as String,
      subReturnCode: json['sub_return_code'] as int,
      cashierOrderUrl: json['cashier_order_url'] as String,
      qrCode: json['qr_code'] as String,
      zpTransToken: json['zp_trans_token'] as String,
    );
  }
}
