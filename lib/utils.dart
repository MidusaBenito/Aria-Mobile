import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;
  static const _keyEmail = 'userEmail';
  static const _keyEmailVerified = 'isEmailVerified';
  static const _keyUserRegistered = 'isUserRegistered';
  static const _keyUserPk = 'userPK';
  static const _keyToken = 'userToken';
  static const _numberOfBillers = 'numberOfBillers';
  //static const _loggedIn = 'isUserLoggedIn';
  static const _listOfBillProfile = 'listOfBillProfile';

  static Future init() async {
    return _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserEmail(String user_Email) async =>
      await _preferences.setString(_keyEmail, user_Email);

  static String? getUserEmail() => _preferences.getString(_keyEmail);

  static Future setUserEmailVerified(bool email_verified) async =>
      await _preferences.setBool(_keyEmailVerified, email_verified);

  static bool? getUserEmailVerified() =>
      _preferences.getBool(_keyEmailVerified);

  static Future setUserRegistered(bool user_registered) async =>
      await _preferences.setBool(_keyUserRegistered, user_registered);

  static bool? getUserRegistered() => _preferences.getBool(_keyUserRegistered);

  static Future setUserPk(String user_pk) async =>
      await _preferences.setString(_keyUserPk, user_pk);

  static String? getUserPk() => _preferences.getString(_keyUserPk);

  static Future setUserToken(String user_token) async =>
      await _preferences.setString(_keyToken, user_token);

  static String? getUserToken() => _preferences.getString(_keyToken);

  static Future setNumberOfBillers(int bill_numbers) async =>
      await _preferences.setInt(_numberOfBillers, bill_numbers);
  static int? getNumberOfBillers() => _preferences.getInt(_numberOfBillers);
}
