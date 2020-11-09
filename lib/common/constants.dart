import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String appName = 'Weather';
  static String openWeatherHost = DotEnv().env['OPENWEATHER_HOST'];
  static String openWeatherApiId = DotEnv().env['OPENWEATHER_API_ID'];
}
