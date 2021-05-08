library global_constants;

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

var _env = DotEnv.env;

// ignore: non_constant_identifier_names
final API_URL = _env['API_URL'];

// ignore: non_constant_identifier_names
final GOOGLE_MAP_KEY = _env['GOOGLE_MAP_KEY'];
