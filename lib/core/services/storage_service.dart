import 'package:barbell/core/utils/jwt/verify_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static String? accessToken;
  static String? refreshToken;
  static bool? isEmailVerified;
  static bool? isWorkoutSettedup;
  static String? role;
  static String? name;
  static String? imgUrl;
  static List<String> favoriteFoodIds = [];

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _isEmailVerifiedKey = 'isEmailVerified';
  static const String _isWorkoutSettedupKey = 'isWorkoutSettedup';
  static const _roleKey = 'role';
  static const _nameKey = 'name';
  static const _imgUrlKey = 'imgUrl';
  static const _favoriteFoodIdsKey = 'favoriteFoodIds';

  static Future<void> saveAccessToken(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_accessTokenKey, value);
    accessToken = value;
  }

  static Future<void> saveRefreshToken(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_refreshTokenKey, value);
    refreshToken = value;
  }

  static Future<void> saveIsEmailVerified(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_isEmailVerifiedKey, value);
    isEmailVerified = value;
  }

  static Future<void> saveIsWorkoutSettedup(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_isWorkoutSettedupKey, value);
    isWorkoutSettedup = value;
  }

  static Future<void> saveRole(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_roleKey, value);
    role = value;
  }

  static Future<void> saveName(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_nameKey, value);
    name = value;
  }

  static Future<void> saveImgUrl(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_imgUrlKey, value);
    imgUrl = value;
  }

  static Future<void> saveFavoriteFoodIds(List<String> value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_favoriteFoodIdsKey, value);
    favoriteFoodIds = value;
  }

  static Future<List<String>> getFavoriteFoodIds() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(_favoriteFoodIdsKey) ?? [];
  }

  static Future<void> addToFavorites(String foodId) async {
    final preferences = await SharedPreferences.getInstance();
    final currentFavorites =
        preferences.getStringList(_favoriteFoodIdsKey) ?? [];
    if (!currentFavorites.contains(foodId)) {
      currentFavorites.add(foodId);
      await preferences.setStringList(_favoriteFoodIdsKey, currentFavorites);
      favoriteFoodIds = currentFavorites;
    }
  }

  static Future<void> removeFromFavorites(String foodId) async {
    final preferences = await SharedPreferences.getInstance();
    final currentFavorites =
        preferences.getStringList(_favoriteFoodIdsKey) ?? [];
    currentFavorites.remove(foodId);
    await preferences.setStringList(_favoriteFoodIdsKey, currentFavorites);
    favoriteFoodIds = currentFavorites;
  }

  static bool isFavorite(String foodId) {
    return favoriteFoodIds.contains(foodId);
  }

  static Future<String?> getAccessToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_accessTokenKey);
  }

  static Future<void> getAllDataFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(_accessTokenKey);
    final refreshToken = preferences.getString(_refreshTokenKey);
    final isEmailVerified = preferences.getBool(_isEmailVerifiedKey);
    final isWorkoutSettedup = preferences.getBool(_isWorkoutSettedupKey);
    final role = preferences.getString(_roleKey);
    final name = preferences.getString(_nameKey);
    final imgUrl = preferences.getString(_imgUrlKey);
    final favoriteFoodIds =
        preferences.getStringList(_favoriteFoodIdsKey) ?? [];

    if (token != null) {
      StorageService.accessToken = token;
    }
    if (refreshToken != null) {
      StorageService.refreshToken = refreshToken;
    }
    if (isEmailVerified != null) {
      StorageService.isEmailVerified = isEmailVerified;
    }
    if (isWorkoutSettedup != null) {
      StorageService.isWorkoutSettedup = isWorkoutSettedup;
    }
    if (role != null) {
      StorageService.role = role;
    }
    if (name != null) {
      StorageService.name = name;
    }
    if (imgUrl != null) {
      StorageService.imgUrl = imgUrl;
    }
    StorageService.favoriteFoodIds = favoriteFoodIds;
  }

  static Future<void> clearAllDataFromStorage() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_accessTokenKey);
    await preferences.remove(_refreshTokenKey);
    await preferences.remove(_isEmailVerifiedKey);
    await preferences.remove(_isWorkoutSettedupKey);
    await preferences.remove(_roleKey);
    await preferences.remove(_nameKey);
    await preferences.remove(_imgUrlKey);
    await preferences.remove(_favoriteFoodIdsKey);

    accessToken = null;
    refreshToken = null;
    isEmailVerified = null;
    isWorkoutSettedup = null;
    role = null;
    name = null;
    imgUrl = null;
    favoriteFoodIds = [];
    favoriteFoodIds = [];
  }

  static Future<bool> isLoggedIn() async {
    await getAllDataFromStorage();
    if (accessToken != null &&
        accessToken!.isNotEmpty &&
        refreshToken != null &&
        refreshToken!.isNotEmpty) {
      bool isValidToken = verifyToken(accessToken!);
      bool isValidRefreshToken = verifyToken(refreshToken!);

      return isValidToken && isValidRefreshToken;
    }
    return false;
  }

  static bool hasToken() {
    final token = StorageService.accessToken;
    final refreshToken = StorageService.refreshToken;
    return token != null && refreshToken != null;
  }
}
