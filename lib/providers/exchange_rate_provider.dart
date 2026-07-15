import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exchange_rate.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';
import 'services_provider.dart';

// Exchange Rate State
class ExchangeRateState {
  final ExchangeRate? rates;
  final bool isLoading;
  final String? error;
  final bool isOffline;
  final DateTime? lastUpdated;

  const ExchangeRateState({
    this.rates,
    this.isLoading = false,
    this.error,
    this.isOffline = false,
    this.lastUpdated,
  });

  ExchangeRateState copyWith({
    ExchangeRate? rates,
    bool? isLoading,
    String? error,
    bool? isOffline,
    DateTime? lastUpdated,
  }) {
    return ExchangeRateState(
      rates: rates ?? this.rates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isOffline: isOffline ?? this.isOffline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Exchange Rate Notifier
class ExchangeRateNotifier extends StateNotifier<ExchangeRateState> {
  final ApiService _apiService;
  final StorageService _storageService;

  ExchangeRateNotifier(this._apiService, this._storageService)
      : super(const ExchangeRateState()) {
    // Don't load here - let splash screen control it
  }

  Future<void> loadInitialRates() async {
    if (state.rates != null) return; // Prevent double loading
    
    state = state.copyWith(isLoading: true);
    
    final cachedRates = _storageService.getCachedExchangeRates();
    final lastUpdate = _storageService.getLastUpdateTime();
    
    if (cachedRates != null) {
      state = state.copyWith(
        rates: cachedRates,
        isOffline: true,
        lastUpdated: lastUpdate,
        isLoading: false,
      );
    }

    if (_storageService.shouldRefreshRates() || cachedRates == null) {
      await fetchRates(AppConstants.defaultBaseCurrency);
    }
  }

  Future<void> fetchRates(String baseCurrency) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final rates = await _apiService.fetchExchangeRates(baseCurrency);
      
      if (rates != null) {
        await _storageService.cacheExchangeRates(rates);
        state = state.copyWith(
          rates: rates,
          isLoading: false,
          isOffline: false,
          lastUpdated: DateTime.now(),
        );
      } else {
        final cachedRates = _storageService.getCachedExchangeRates();
        if (cachedRates != null) {
          state = state.copyWith(
            rates: cachedRates,
            isLoading: false,
            isOffline: true,
            error: 'Using cached rates',
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to fetch rates. Check your connection.',
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred',
      );
    }
  }

  Future<void> refreshRates() async {
    await fetchRates(AppConstants.defaultBaseCurrency);
  }

  double? getRate(String from, String to) {
    if (state.rates == null) return null;
    return state.rates!.getRate(from, to);
  }

  double convert(double amount, String from, String to) {
    if (state.rates == null) return 0;
    return state.rates!.convert(amount, from, to);
  }
}

// Exchange Rate Provider
final exchangeRateProvider = StateNotifierProvider<ExchangeRateNotifier, ExchangeRateState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return ExchangeRateNotifier(apiService, storageService);
});
