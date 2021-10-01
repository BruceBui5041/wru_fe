library global_constants;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final Map<String, String> _env = dotenv.env;

// ignore: non_constant_identifier_names
final String? API_URL = _env['API_URL'];

// ignore: non_constant_identifier_names
final String? GOOGLE_MAP_KEY = _env['GOOGLE_MAP_KEY'];

GetIt getIt = GetIt.instance;

const String USER_LOCATION_KEY = "useLocation";

const String LAST_SEEN_MARKER = "lastSeenMarker";

const String LAST_SEEN_JOUNEY = "lastSeenJouney";
