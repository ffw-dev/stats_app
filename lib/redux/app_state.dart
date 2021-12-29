import 'package:flutter/cupertino.dart';
import 'package:stats_app/redux/authentication_state_part/authentication.dart';
import 'package:stats_app/redux/preferences_state_part/preferences.dart';

@immutable
class AppState {
  final Authentication authentication;
  late Preferences preferences;

  AppState(this.authentication, this.preferences);

  Future<AppState> initState() async {
    preferences = await Preferences().initState();

    return this;
  }

  AppState copy({
    required Authentication authentication,
    required Preferences preferences,
  }) {
    return AppState(authentication, preferences);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppState && runtimeType == other.runtimeType &&
          authentication == other.authentication && preferences == other.preferences;

  @override
  int get hashCode => preferences.hashCode ^ authentication.hashCode;

}