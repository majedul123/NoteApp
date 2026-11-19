import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String counterEndpoint = '/posts/1';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ));
  }

  Future<int> saveCounter(int value) async {
    try {
      final response = await _dio.patch(
        counterEndpoint,
        data: {'body': value.toString()},
      );

      if (response.statusCode == 200) {
        return value;
      } else {
        throw Exception('Failed to save counter');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }

  Future<int> getCounter() async {
    try {
      final response = await _dio.get(counterEndpoint);

      if (response.statusCode == 200) {
        final body = response.data['body'] ?? '0';
        return int.tryParse(body.toString()) ?? 0;
      } else {
        throw Exception('Failed to fetch counter');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }
}
