import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import 'services_provider.dart';

// Favorite Pairs Provider (stores "USD→PKR" format)
final favoritePairsProvider = StateNotifierProvider<FavoritePairsNotifier, List<String>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return FavoritePairsNotifier(storageService);
});

class FavoritePairsNotifier extends StateNotifier<List<String>> {
  final StorageService _storageService;

  FavoritePairsNotifier(this._storageService) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    state = _storageService.getFavoritePairs();
  }

  String makePairKey(String from, String to) => '$from→$to';

  bool isFavoritePair(String fromCode, String toCode) {
    return state.contains(makePairKey(fromCode, toCode));
  }

  Future<void> toggleFavoritePair(String fromCode, String toCode) async {
    final key = makePairKey(fromCode, toCode);
    if (state.contains(key)) {
      state = state.where((pair) => pair != key).toList();
    } else {
      state = [...state, key];
    }
    await _storageService.saveFavoritePairs(state);
  }

  Future<void> removeFavoritePair(String pair) async {
    state = state.where((p) => p != pair).toList();
    await _storageService.saveFavoritePairs(state);
  }

  // Safe pair parsing
  static ({String from, String to})? parsePair(String pair) {
    final parts = pair.split('→');
    if (parts.length != 2) return null;
    if (parts[0].isEmpty || parts[1].isEmpty) return null;
    return (from: parts[0], to: parts[1]);
  }
}

// Favorites Provider (individual currencies)
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return FavoritesNotifier(storageService);
});

class FavoritesNotifier extends StateNotifier<List<String>> {
  final StorageService _storageService;

  FavoritesNotifier(this._storageService) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    state = _storageService.getFavorites();
  }

  Future<void> toggleFavorite(String currencyCode) async {
    if (state.contains(currencyCode)) {
      state = state.where((code) => code != currencyCode).toList();
    } else {
      state = [...state, currencyCode];
    }
    await _storageService.saveFavorites(state);
  }

  bool isFavorite(String currencyCode) {
    return state.contains(currencyCode);
  }
}

// Recently Used Currencies Provider
final recentlyUsedProvider = StateNotifierProvider<RecentlyUsedNotifier, List<String>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return RecentlyUsedNotifier(storageService);
});

class RecentlyUsedNotifier extends StateNotifier<List<String>> {
  final StorageService _storageService;

  RecentlyUsedNotifier(this._storageService) : super([]) {
    _loadRecentlyUsed();
  }

  void _loadRecentlyUsed() {
    state = _storageService.getRecentlyUsed();
  }

  Future<void> addCurrency(String currencyCode) async {
    state = [currencyCode, ...state.where((c) => c != currencyCode)].take(10).toList();
    await _storageService.saveRecentlyUsed(state);
  }
}
