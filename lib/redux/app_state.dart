import 'package:stats_app/redux/authentication_state_part/authentication.dart';
import 'package:stats_app/redux/preferences_state_part/preferences.dart';

class AppState {
  Authentication authentication = Authentication();
  Preferences preferences = Preferences();
}