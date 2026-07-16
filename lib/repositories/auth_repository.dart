import 'package:directorateofculture/Constant/Apis.dart';
import 'package:directorateofculture/Helper/api_client.dart';

class ApiRepository {
  final ApiClient _client;

  ApiRepository({ApiClient? client}) : _client = client ?? ApiClient();

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) {
    return _client.post(
      ApiConstants.login(),
      data: {
        'phone_number': phone.trim(),
        'password': password.trim(),
        'remember_me': true,
      },
    );
  }
}
