import '../models/user.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository({
    required ApiService apiService,
  }) : _apiService = apiService;

  Future<Map<String, dynamic>> register(User user) async {
    return _apiService.post(
      '/cadastro',
      body: user.toJson(),
    );
  }

  Future<Map<String, dynamic>> validateToken({
    required String email,
    required String token,
  }) async {
    return _apiService.post(
      '/verificar-token',
      body: {
        'email': email,
        'token': token,
      },
    );
  }

  Future<Map<String, dynamic>> resendToken(String email) async {
    return _apiService.post(
      '/reenviar-token',
      body: {'email': email},
    );
  }
}