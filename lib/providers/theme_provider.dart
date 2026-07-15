import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import 'services_provider.dart';

// Theme Mode Provider (0 = System, 1 = Light, 2 = Dark)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, int>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ThemeModeNotifier(storageService);
});

class ThemeModeNotifier extends StateNotifier<int> {
  final StorageService _storageService;

  ThemeModeNotifier(this._storageService) : super(0) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    state = _storageService.getThemeMode();
  }

  Future<void> setThemeMode(int mode) async {
    state = mode;
    await _storageService.saveThemeMode(mode);
  }

  ThemeMode get themeMode {
    switch (state) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
