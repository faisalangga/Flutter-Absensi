
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {

  Future<bool> setPreference(String key,String value)async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
    return true;
  }

  Future<bool> setBool(String key,bool value)async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(key, value);
    return true;
  }

  Future<String> getPreference(String key)async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString(key);
    return token.toString();
  }

  Future<bool> getBool(String key)async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(key) ?? false;
  }

  Future<bool> remove()async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('token');
    return true;
  }
}
