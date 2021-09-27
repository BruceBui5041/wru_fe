library global_constants;

import 'package:flutter_dotenv/flutter_dotenv.dart';

final Map<String, String> _env = dotenv.env;

// ignore: non_constant_identifier_names
final String? API_URL = _env['API_URL'];

// ignore: non_constant_identifier_names
final String? GOOGLE_MAP_KEY = _env['GOOGLE_MAP_KEY'];
