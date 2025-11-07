import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wather_app/controllers/weather_controller.dart';
import 'package:wather_app/controllers/favorites_controller.dart';
import 'package:wather_app/views/home_view.dart';
import 'package:wather_app/services/weather_service.dart';
import 'package:wather_app/services/location_service.dart';
import 'package:wather_app/services/storage_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Get.put(WeatherService());
  Get.put(LocationService());
  Get.put(StorageService());
  Get.put(WeatherController());
  Get.put(FavoritesController());
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather Forecast App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1B33),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFDB846),
          brightness: Brightness.dark,
          primary: const Color(0xFFFDB846),
          secondary: const Color(0xFF383E5E),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF383E5E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFDB846),
          foregroundColor: Color(0xFF1C1B33),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFDB846),
            foregroundColor: const Color(0xFF1C1B33),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1B33),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFDB846),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomeView(),
    );
  }
}
