import 'package:dio/dio.dart';
import 'package:hotel_booking_app/core/network/app_client.dart';
import 'package:hotel_booking_app/data/model/zalopay/zalopay_request.dart';

class ZalopayService {
  final Dio dio = ApiClient().dio;

  Future<Response> createZalopayPayment(ZalopayRequest zalopayRequest) async {
    try {
      final Response response = await dio.post(
        'zalopay/create-order',
        data: zalopayRequest.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
