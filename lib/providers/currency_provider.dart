// Currency Providers - From/To Currency & Amount
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency.dart';
import '../constants/app_constants.dart';

// From Currency Provider
final fromCurrencyProvider = StateProvider<Currency>((ref) {
  return AppConstants.getCurrencyByCode(AppConstants.defaultFromCurrency);
});

// To Currency Provider
final toCurrencyProvider = StateProvider<Currency>((ref) {
  return AppConstants.getCurrencyByCode(AppConstants.defaultToCurrency);
});

// Amount Provider
final amountProvider = StateProvider<String>((ref) {
  return '1';
});
