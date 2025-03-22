import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/token_validation_screen.dart';
import '../screens/home_screen.dart';
import '../screens/doctor_list_screen.dart';
import '../screens/availability_screen.dart';
import '../screens/video_call_screen.dart';
import '../screens/horarios_disponiveis_screen.dart';
import '../repositories/auth_repository.dart';
import '../cubits/register/register_cubit.dart';
import '../models/doctor.dart';
import '../services/api_service.dart';
import '../cubits/login/login_cubit.dart';
import '../services/firebase_messaging_service.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String tokenValidation = '/token-validation';
  static const String home = '/home';
  static const String doctorList = '/doctor-list';
  static const String availability = '/availability';
  static const String videoCall = '/video-call';

  static final apiService = ApiService();
  static final authRepository = AuthRepository(apiService: apiService);
  static final firebaseMessaging = FirebaseMessagingService();

  static List<GetPage> routes = [
    GetPage(
      name: welcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: login,
      page: () => BlocProvider(
        create: (context) => LoginCubit(
          authRepository: authRepository,
          firebaseMessaging: firebaseMessaging,
        ),
        child: const LoginScreen(),
      ),
    ),
    GetPage(
      name: register,
      page: () => BlocProvider(
        create: (context) => RegisterCubit(
          authRepository: AuthRepository(
            apiService: apiService,
          ),
        ),
        child: const RegisterScreen(),
      ),
    ),
    GetPage(
      name: tokenValidation,
      page: () => TokenValidationScreen(
        email: Get.arguments['email'],
      ),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(
        nomeClient: Get.arguments['nomeClient'],
      ),
    ),
    GetPage(
      name: doctorList,
      page: () => const DoctorListScreen(),
    ),
    GetPage(
      name: availability,
      page: () => HorariosDisponiveisScreen(
        medicoId: (Get.arguments['doctor'] as Doctor).id.toString(),
        medicoNome: (Get.arguments['doctor'] as Doctor).nome,
      ),
    ),
    GetPage(
      name: videoCall,
      page: () => const VideoCallScreen(),
    ),
  ];
}