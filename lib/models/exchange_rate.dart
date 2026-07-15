class ExchangeRate {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime lastUpdated;

  const ExchangeRate({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      baseCurrency: json['base_code'] as String? ?? json['base'] as String? ?? 'USD',
      rates: Map<String, double>.from(
        (json['rates'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      lastUpdated: DateTime.tryParse(json['time_last_update_utc'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCurrency,
      'rates': rates,
      'time_last_update_utc': lastUpdated.toIso8601String(),
    };
  }

  double? getRate(String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return 1.0;
    
    if (fromCurrency == baseCurrency) {
      return rates[toCurrency];
    }
    
    if (toCurrency == baseCurrency) {
      final rate = rates[fromCurrency];
      return rate != null ? 1.0 / rate : null;
    }
    
    final fromRate = rates[fromCurrency];
    final toRate = rates[toCurrency];
    
    if (fromRate != null && toRate != null) {
      return toRate / fromRate;
    }
    
    return null;
  }

  double convert(double amount, String fromCurrency, String toCurrency) {
    final rate = getRate(fromCurrency, toCurrency);
    if (rate == null) return 0.0;
    return amount * rate;
  }
}
