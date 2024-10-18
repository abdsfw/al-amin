import 'package:alaminedu/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CasheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> casheInit() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var isFirstTime = await getData(key: Constants.kIsFirstTime);
    if (isFirstTime == null) {
      await setData(key: Constants.kIsFirstTime, value: false);
    }
    var istokensend = CasheHelper.getData(key: Constants.kTokenNotifiSend);
    if (istokensend == null) {
      await CasheHelper.setData(key: Constants.kTokenNotifiSend, value: false);
    }
  }

  static Future<bool> setData(
      {required String key, required dynamic value}) async {
    if (value is int) {
      await sharedPreferences.setInt(key, value);
      return true;
    } else if (value is String) {
      await sharedPreferences.setString(key, value);
      return true;
    } else if (value is bool) {
      await sharedPreferences.setBool(key, value);
      return true;
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
      return true;
    } else if (value is List) {
      await sharedPreferences.setStringList(key, value as List<String>);
      return true;
    }
    return false;
  }

  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  static dynamic getListData({required String key}) {
    return sharedPreferences.getStringList(key);
  }

  static Future<bool> deleteData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  static Future<void> clearCashe() async {
    await sharedPreferences.clear();
  }

  static Future<bool> isContainKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }
}
