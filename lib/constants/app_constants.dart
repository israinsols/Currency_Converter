import '../models/currency.dart';

class AppConstants {
  static const String appName = 'Currency Converter';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.exchangerate-api.com';
  static const String apiEndpoint = '/v4/latest';
  
  // Storage Keys
  static const String ratesCacheKey = 'cached_rates';
  static const String lastUpdateKey = 'last_update_time';
  static const String favoritesKey = 'favorite_currencies';
  static const String favoritePairsKey = 'favorite_pairs';
  static const String recentlyUsedKey = 'recently_used';
  static const String baseCurrencyKey = 'base_currency';
  static const String darkModeKey = 'dark_mode';
  static const String themeModeKey = 'theme_mode';
  
  // Default Values
  static const String defaultBaseCurrency = 'USD';
  static const String defaultFromCurrency = 'USD';
  static const String defaultToCurrency = 'PKR';
  
  // Popular currencies for quick access
  static const List<String> popularCurrencyCodes = [
    'USD', 'EUR', 'GBP', 'INR', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY', 'SGD'
  ];
  
  // All available currencies
  static final List<Currency> allCurrencies = [
    const Currency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸'),
    const Currency(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺'),
    const Currency(code: 'GBP', name: 'British Pound', symbol: '£', flag: '🇬🇧'),
    const Currency(code: 'INR', name: 'Indian Rupee', symbol: '₹', flag: '🇮🇳'),
    const Currency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flag: '🇯🇵'),
    const Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', flag: '🇦🇺'),
    const Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$', flag: '🇨🇦'),
    const Currency(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr', flag: '🇨🇭'),
    const Currency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', flag: '🇨🇳'),
    const Currency(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$', flag: '🇸🇬'),
    const Currency(code: 'HKD', name: 'Hong Kong Dollar', symbol: 'HK\$', flag: '🇭🇰'),
    const Currency(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr', flag: '🇳🇴'),
    const Currency(code: 'KRW', name: 'South Korean Won', symbol: '₩', flag: '🇰🇷'),
    const Currency(code: 'TRY', name: 'Turkish Lira', symbol: '₺', flag: '🇹🇷'),
    const Currency(code: 'RUB', name: 'Russian Ruble', symbol: '₽', flag: '🇷🇺'),
    const Currency(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$', flag: '🇧🇷'),
    const Currency(code: 'ZAR', name: 'South African Rand', symbol: 'R', flag: '🇿🇦'),
    const Currency(code: 'MXN', name: 'Mexican Peso', symbol: 'Mex\$', flag: '🇲🇽'),
    const Currency(code: 'SEK', name: 'Swedish Krona', symbol: 'kr', flag: '🇸🇪'),
    const Currency(code: 'NZD', name: 'New Zealand Dollar', symbol: 'NZ\$', flag: '🇳🇿'),
    const Currency(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ', flag: '🇦🇪'),
    const Currency(code: 'SAR', name: 'Saudi Riyal', symbol: '﷼', flag: '🇸🇦'),
    const Currency(code: 'THB', name: 'Thai Baht', symbol: '฿', flag: '🇹🇭'),
    const Currency(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp', flag: '🇮🇩'),
    const Currency(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM', flag: '🇲🇾'),
    const Currency(code: 'PHP', name: 'Philippine Peso', symbol: '₱', flag: '🇵🇭'),
    const Currency(code: 'CZK', name: 'Czech Koruna', symbol: 'Kč', flag: '🇨🇿'),
    const Currency(code: 'ILS', name: 'Israeli Shekel', symbol: '₪', flag: '🇮🇱'),
    const Currency(code: 'PLN', name: 'Polish Zloty', symbol: 'zł', flag: '🇵🇱'),
    const Currency(code: 'ISK', name: 'Icelandic Krona', symbol: 'kr', flag: '🇮🇸'),
    const Currency(code: 'HUF', name: 'Hungarian Forint', symbol: 'Ft', flag: '🇭🇺'),
    const Currency(code: 'KWD', name: 'Kuwaiti Dinar', symbol: 'د.ك', flag: '🇰🇼'),
    const Currency(code: 'QAR', name: 'Qatari Riyal', symbol: '﷼', flag: '🇶🇦'),
    const Currency(code: 'BHD', name: 'Bahraini Dinar', symbol: 'BD', flag: '🇧🇭'),
    const Currency(code: 'OMR', name: 'Omani Rial', symbol: '﷼', flag: '🇴🇲'),
    const Currency(code: 'EGP', name: 'Egyptian Pound', symbol: 'E£', flag: '🇪🇬'),
    const Currency(code: 'PKR', name: 'Pakistani Rupee', symbol: '₨', flag: '🇵🇰'),
    const Currency(code: 'BDT', name: 'Bangladeshi Taka', symbol: '৳', flag: '🇧🇩'),
    const Currency(code: 'LKR', name: 'Sri Lankan Rupee', symbol: 'Rs', flag: '🇱🇰'),
    const Currency(code: 'NPR', name: 'Nepalese Rupee', symbol: 'Rs', flag: '🇳🇵'),
    const Currency(code: 'VND', name: 'Vietnamese Dong', symbol: '₫', flag: '🇻🇳'),
    const Currency(code: 'UAH', name: 'Ukrainian Hryvnia', symbol: '₴', flag: '🇺🇦'),
    const Currency(code: 'ARS', name: 'Argentine Peso', symbol: 'AR\$', flag: '🇦🇷'),
    const Currency(code: 'CLP', name: 'Chilean Peso', symbol: 'CL\$', flag: '🇨🇱'),
    const Currency(code: 'COP', name: 'Colombian Peso', symbol: 'COL\$', flag: '🇨🇴'),
    const Currency(code: 'PEN', name: 'Peruvian Sol', symbol: 'S/', flag: '🇵🇪'),
    const Currency(code: 'RON', name: 'Romanian Leu', symbol: 'lei', flag: '🇷🇴'),
    const Currency(code: 'BGN', name: 'Bulgarian Lev', symbol: 'лв', flag: '🇧🇬'),
    const Currency(code: 'NGN', name: 'Nigerian Naira', symbol: '₦', flag: '🇳🇬'),
    const Currency(code: 'KES', name: 'Kenyan Shilling', symbol: 'KSh', flag: '🇰🇪'),
    const Currency(code: 'GHS', name: 'Ghanaian Cedi', symbol: 'GH₵', flag: '🇬🇭'),
    const Currency(code: 'TZS', name: 'Tanzanian Shilling', symbol: 'TSh', flag: '🇹🇿'),
    const Currency(code: 'UGX', name: 'Ugandan Shilling', symbol: 'USh', flag: '🇺🇬'),
    const Currency(code: 'MAD', name: 'Moroccan Dirham', symbol: 'MAD', flag: '🇲🇦'),
    const Currency(code: 'DZD', name: 'Algerian Dinar', symbol: 'DA', flag: '🇩🇿'),
    const Currency(code: 'TND', name: 'Tunisian Dinar', symbol: 'DT', flag: '🇹🇳'),
    const Currency(code: 'JOD', name: 'Jordanian Dinar', symbol: 'JD', flag: '🇯🇴'),
    const Currency(code: 'LBP', name: 'Lebanese Pound', symbol: 'L£', flag: '🇱🇧'),
    const Currency(code: 'GEL', name: 'Georgian Lari', symbol: '₾', flag: '🇬🇪'),
    const Currency(code: 'AMD', name: 'Armenian Dram', symbol: '֏', flag: '🇦🇲'),
    const Currency(code: 'KZT', name: 'Kazakhstani Tenge', symbol: '₸', flag: '🇰🇿'),
    const Currency(code: 'UZS', name: 'Uzbekistani Som', symbol: 'сўм', flag: '🇺🇿'),
    const Currency(code: 'MNT', name: 'Mongolian Tugrik', symbol: '₮', flag: '🇲🇳'),
    const Currency(code: 'KHR', name: 'Cambodian Riel', symbol: '៛', flag: '🇰🇭'),
    const Currency(code: 'MMK', name: 'Myanmar Kyat', symbol: 'K', flag: '🇲🇲'),
    const Currency(code: 'LAK', name: 'Laotian Kip', symbol: '₭', flag: '🇱🇦'),
    const Currency(code: 'BND', name: 'Brunei Dollar', symbol: 'B\$', flag: '🇧🇳'),
    const Currency(code: 'FJD', name: 'Fijian Dollar', symbol: 'FJ\$', flag: '🇫🇯'),
    const Currency(code: 'TOP', name: 'Tongan Pa\'anga', symbol: 'T\$', flag: '🇹🇴'),
    const Currency(code: 'XPF', name: 'CFP Franc', symbol: '₣', flag: '🇵🇫'),
    const Currency(code: 'JMD', name: 'Jamaican Dollar', symbol: 'J\$', flag: '🇯🇲'),
    const Currency(code: 'TTD', name: 'Trinidad Dollar', symbol: 'TT\$', flag: '🇹🇹'),
    const Currency(code: 'BSD', name: 'Bahamian Dollar', symbol: 'B\$', flag: '🇧🇸'),
    const Currency(code: 'BZD', name: 'Belize Dollar', symbol: 'BZ\$', flag: '🇧🇿'),
    const Currency(code: 'GTQ', name: 'Guatemalan Quetzal', symbol: 'Q', flag: '🇬🇹'),
    const Currency(code: 'HNL', name: 'Honduran Lempira', symbol: 'L', flag: '🇭🇳'),
    const Currency(code: 'NIO', name: 'Nicaraguan Cordoba', symbol: 'C\$', flag: '🇳🇮'),
    const Currency(code: 'CRC', name: 'Costa Rican Colón', symbol: '₡', flag: '🇨🇷'),
    const Currency(code: 'PAB', name: 'Panamanian Balboa', symbol: 'B/.', flag: '🇵🇦'),
    const Currency(code: 'UYU', name: 'Uruguayan Peso', symbol: '\$U', flag: '🇺🇾'),
    const Currency(code: 'PYG', name: 'Paraguayan Guarani', symbol: '₲', flag: '🇵🇾'),
    const Currency(code: 'BOB', name: 'Bolivian Boliviano', symbol: 'Bs', flag: '🇧🇴'),
    const Currency(code: 'VES', name: 'Venezuelan Bolívar', symbol: 'Bs.S', flag: '🇻🇪'),
    const Currency(code: 'IRR', name: 'Iranian Rial', symbol: '﷼', flag: '🇮🇷'),
    const Currency(code: 'IQD', name: 'Iraqi Dinar', symbol: 'ع.د', flag: '🇮🇶'),
    const Currency(code: 'AFN', name: 'Afghan Afghani', symbol: '؋', flag: '🇦🇫'),
    const Currency(code: 'ALL', name: 'Albanian Lek', symbol: 'L', flag: '🇦🇱'),
    const Currency(code: 'BAM', name: 'Bosnia-Herzegovina Mark', symbol: 'KM', flag: '🇧🇦'),
    const Currency(code: 'MKD', name: 'Macedonian Denar', symbol: 'ден', flag: '🇲🇰'),
    const Currency(code: 'RSD', name: 'Serbian Dinar', symbol: 'din', flag: '🇷🇸'),
    const Currency(code: 'MDL', name: 'Moldovan Leu', symbol: 'lei', flag: '🇲🇩'),
    const Currency(code: 'BYN', name: 'Belarusian Ruble', symbol: 'Br', flag: '🇧🇾'),
    const Currency(code: 'MUR', name: 'Mauritian Rupee', symbol: '₨', flag: '🇲🇺'),
    const Currency(code: 'BTN', name: 'Bhutanese Ngultrum', symbol: 'Nu.', flag: '🇧🇹'),
    const Currency(code: 'MOP', name: 'Macanese Pataca', symbol: 'MOP\$', flag: '🇲🇴'),
    const Currency(code: 'TWD', name: 'Taiwan New Dollar', symbol: 'NT\$', flag: '🇹🇼'),
    const Currency(code: 'SYP', name: 'Syrian Pound', symbol: '£', flag: '🇸🇾'),
    const Currency(code: 'YER', name: 'Yemeni Rial', symbol: '﷼', flag: '🇾🇪'),
    const Currency(code: 'DJF', name: 'Djiboutian Franc', symbol: 'Fdj', flag: '🇯🇮'),
    const Currency(code: 'ERN', name: 'Eritrean Nakfa', symbol: 'Nfk', flag: '🇪🇷'),
    const Currency(code: 'SZL', name: 'Swazi Lilangeni', symbol: 'E', flag: '🇸🇿'),
    const Currency(code: 'NAD', name: 'Namibian Dollar', symbol: 'N\$', flag: '🇳🇦'),
    const Currency(code: 'MWK', name: 'Malawian Kwacha', symbol: 'MK', flag: '🇲🇼'),
    const Currency(code: 'ZMW', name: 'Zambian Kwacha', symbol: 'ZK', flag: '🇿🇲'),
    const Currency(code: 'BWP', name: 'Botswana Pula', symbol: 'P', flag: '🇧🇼'),
    const Currency(code: 'SOS', name: 'Somali Shilling', symbol: 'Sh', flag: '🇸🇴'),
    const Currency(code: 'XOF', name: 'West African CFA Franc', symbol: 'CFA', flag: '🇸🇳'),
    const Currency(code: 'XAF', name: 'Central African CFA Franc', symbol: 'FCFA', flag: '🇨🇲'),
    const Currency(code: 'RWF', name: 'Rwandan Franc', symbol: 'FRw', flag: '🇷🇼'),
    const Currency(code: 'CDF', name: 'Congolese Franc', symbol: 'FC', flag: '🇨🇩'),
    const Currency(code: 'AOA', name: 'Angolan Kwanza', symbol: 'Kz', flag: '🇦🇴'),
    const Currency(code: 'MZN', name: 'Mozambican Metical', symbol: 'MT', flag: '🇲🇿'),
  ];

  // Currency map for O(1) lookup
  static final Map<String, Currency> _currencyMap = {
    for (var c in allCurrencies) c.code: c,
  };

  static Currency getCurrencyByCode(String code) {
    return _currencyMap[code] ?? const Currency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸');
  }

  static bool isValidCurrencyCode(String code) {
    return _currencyMap.containsKey(code);
  }
}
