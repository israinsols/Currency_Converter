import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exchange_rate.dart';
import '../constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Box _box;
  late SharedPreferences _prefs;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('currency_converter');
    _prefs = await SharedPreferences.getInstance();
  }

  // Exchange Rates Caching
  Future<void> cacheExchangeRates(ExchangeRate rates) async {
    await _box.put(AppConstants.ratesCacheKey, jsonEncode(rates.toJson()));
    await _box.put(AppConstants.lastUpdateKey, DateTime.now().toIso8601String());
  }

  ExchangeRate? getCachedExchangeRates() {
    final cachedData = _box.get(AppConstants.ratesCacheKey);
    if (cachedData != null) {
      try {
        final json = jsonDecode(cachedData as String) as Map<String, dynamic>;
        return ExchangeRate.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  DateTime? getLastUpdateTime() {
    final lastUpdate = _box.get(AppConstants.lastUpdateKey);
    if (lastUpdate != null) {
      return DateTime.tryParse(lastUpdate as String);
    }
    return null;
  }

  // Favorites (individual currencies)
  Future<void> saveFavorites(List<String> favorites) async {
    await _prefs.setStringList(AppConstants.favoritesKey, favorites);
  }

  List<String> getFavorites() {
    return _prefs.getStringList(AppConstants.favoritesKey) ?? [];
  }

  // Favorite Pairs (e.g., "USD→PKR")
  Future<void> saveFavoritePairs(List<String> pairs) async {
    await _prefs.setStringList('favorite_pairs', pairs);
  }

  List<String> getFavoritePairs() {
    return _prefs.getStringList('favorite_pairs') ?? [];
  }

  // Recently Used Currencies
  Future<void> saveRecentlyUsed(List<String> codes) async {
    await _prefs.setStringList('recently_used', codes);
  }

  List<String> getRecentlyUsed() {
    return _prefs.getStringList('recently_used') ?? [];
  }

  // Base Currency
  Future<void> saveBaseCurrency(String currency) async {
    await _prefs.setString(AppConstants.baseCurrencyKey, currency);
  }

  String getBaseCurrency() {
    return _prefs.getString(AppConstants.baseCurrencyKey) ?? AppConstants.defaultBaseCurrency;
  }

  // Theme Mode (0 = System, 1 = Light, 2 = Dark)
  Future<void> saveThemeMode(int mode) async {
    await _prefs.setInt('theme_mode', mode);
  }

  int getThemeMode() {
    return _prefs.getInt('theme_mode') ?? 0;
  }

  // Dark Mode (legacy)
  Future<void> saveDarkMode(bool isDark) async {
    await _prefs.setBool(AppConstants.darkModeKey, isDark);
  }

  bool getDarkMode() {
    return _prefs.getBool(AppConstants.darkModeKey) ?? true;
  }

  // Check if rates need refresh (older than 1 hour)
  bool shouldRefreshRates() {
    final lastUpdate = getLastUpdateTime();
    if (lastUpdate == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastUpdate);
    return difference.inHours >= 1;
  }
}
