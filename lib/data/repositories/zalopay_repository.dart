import 'package:hotel_booking_app/data/model/api_response.dart';
import 'package:hotel_booking_app/data/model/zalopay/zalopay_request.dart';
import 'package:hotel_booking_app/data/model/zalopay/zalopay_response.dart';
import 'package:hotel_booking_app/data/service/zalopay_service.dart';

class ZalopayRepository {
  final ZalopayService zalopayService;
  ZalopayRepository({required this.zalopayService});

  Future<ApiResponse<ZalopayResponse>> createZalopayPayment(
    ZalopayRequest zalopayRequest,
  ) async {
    try {
      final response = await zalopayService.createZalopayPayment(
        zalopayRequest,
      );
      return ApiResponse.fromJson(
        response.statusCode,
        response.data,
        (data) => ZalopayResponse.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }
}
