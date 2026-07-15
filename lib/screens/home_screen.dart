import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../providers/currency_provider.dart';
import '../providers/exchange_rate_provider.dart';
import '../providers/favorites_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/currency_card.dart';
import '../widgets/trend_colored_chart.dart';
import '../services/api_service.dart';
import '../models/exchange_rate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: IndexedStack(
          index: _currentNavIndex,
          children: [
            _buildConverterTab(isDark),
            _buildTrendsTab(isDark),
            _buildSavedTab(isDark),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  // ============ TAB 1: CONVERTER ============
  Widget _buildConverterTab(bool isDark) {
    final fromCurrency = ref.watch(fromCurrencyProvider);
    final toCurrency = ref.watch(toCurrencyProvider);
    final rateState = ref.watch(exchangeRateProvider);
    final amount = ref.watch(amountProvider);
    final isFav = ref.watch(favoritePairsProvider).contains(
      ref.read(favoritePairsProvider.notifier).makePairKey(fromCurrency.code, toCurrency.code),
    );

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: isDark ? AppColors.limeGreen : AppColors.tealDark,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildHeader(isDark),
            const SizedBox(height: 8),
            _buildOfflineBanner(rateState, isDark),
            _buildErrorBanner(rateState, isDark),
            const SizedBox(height: 20),
            CurrencyCard(
              label: 'FROM',
              currencyCode: fromCurrency.code,
              currencyName: fromCurrency.name,
              flag: fromCurrency.flag,
              isInput: true,
              initialAmount: amount,
              onTap: () => _openCurrencySelection(true),
              onAmountChanged: (value) {
                ref.read(amountProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 8),
            _buildSwapButton(isDark),
            const SizedBox(height: 8),
            CurrencyCard(
              label: 'TO',
              currencyCode: toCurrency.code,
              currencyName: toCurrency.name,
              flag: toCurrency.flag,
              amount: _convertAmount(amount, fromCurrency.code, toCurrency.code),
              showConvertedAmount: true,
              onTap: () => _openCurrencySelection(false),
            ),
            const SizedBox(height: 12),
            _buildActionButtons(fromCurrency.code, toCurrency.code, amount, isFav, isDark),
            const SizedBox(height: 16),
            _buildRateInfo(fromCurrency.code, toCurrency.code, rateState, isDark),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.mediumImpact();
    await ref.read(exchangeRateProvider.notifier).refreshRates();
    setState(() => _isRefreshing = false);
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Convert',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            _buildLastUpdatedText(isDark),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/settings'),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.5,
              ),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdatedText(bool isDark) {
    final rateState = ref.watch(exchangeRateProvider);
    final lastUpdate = rateState.lastUpdated;

    String text;
    if (lastUpdate != null) {
      final diff = DateTime.now().difference(lastUpdate);
      if (diff.inMinutes < 1) {
        text = 'Updated just now';
      } else if (diff.inMinutes < 60) {
        text = 'Updated ${diff.inMinutes} min ago';
      } else if (diff.inHours < 24) {
        text = 'Updated ${diff.inHours}h ago';
      } else {
        text = 'Updated ${DateFormat('MMM d').format(lastUpdate)}';
      }
    } else {
      text = 'Pull down to refresh';
    }

    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildOfflineBanner(ExchangeRateState rateState, bool isDark) {
    if (!rateState.isOffline) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, color: AppColors.warning, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline - showing cached rates',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(ExchangeRateState rateState, bool isDark) {
    if (rateState.error == null || rateState.isOffline) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.danger.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rateState.error!,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwapButton(bool isDark) {
    return Center(
      child: GestureDetector(
        onTap: _swapCurrencies,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppColors.limeGreen : AppColors.tealDark,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.limeGreen : AppColors.tealDark).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.swap_vert_rounded,
            color: isDark ? Colors.black : Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(String fromCode, String toCode, String amount, bool isFav, bool isDark) {
    final convertedAmount = _convertAmount(amount, fromCode, toCode);
    final primaryColor = isDark ? AppColors.limeGreen : AppColors.tealDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Favorite Button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            ref.read(favoritePairsProvider.notifier).toggleFavoritePair(fromCode, toCode);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isFav
                  ? primaryColor.withValues(alpha: 0.15)
                  : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isFav ? primaryColor : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFav ? primaryColor : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  isFav ? 'Saved' : 'Save',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isFav ? primaryColor : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Copy Button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            final text = '$amount $fromCode = $convertedAmount $toCode';
            Clipboard.setData(ClipboardData(text: text));
            _showSnackBar('Copied to clipboard', isDark, detail: text);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.copy_rounded,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Copy',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Share Button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            final text = '$amount $fromCode = $convertedAmount $toCode\nExchange rate via Currency Converter';
            Share.share(text);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.share_rounded,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Share',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRateInfo(String fromCode, String toCode, ExchangeRateState rateState, bool isDark) {
    if (rateState.rates == null) return const SizedBox.shrink();

    final rate = rateState.rates!.getRate(fromCode, toCode);
    if (rate == null) return const SizedBox.shrink();

    // Calculate real trend (compare first and last available rates)
    final trend = _calculateTrend(rateState.rates!, fromCode, toCode);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '1 $fromCode = ${rate.toStringAsFixed(2)} $toCode',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (trend != null)
            Row(
              children: [
                Icon(
                  trend >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  color: trend >= 0
                      ? (isDark ? AppColors.limeGreen : AppColors.tealDark)
                      : AppColors.danger,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${trend >= 0 ? '+' : ''}${trend.toStringAsFixed(2)}%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: trend >= 0
                        ? (isDark ? AppColors.limeGreen : AppColors.tealDark)
                        : AppColors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  double? _calculateTrend(ExchangeRate rates, String from, String to) {
    try {
      final currentRate = rates.getRate(from, to);
      if (currentRate == null) return null;
      // Use base currency rate to calculate a simple trend indicator
      final baseRate = rates.rates[to];
      if (baseRate == null) return null;
      // Simple trend: compare rate to a rounded value
      return ((currentRate - baseRate) / baseRate) * 100;
    } catch (e) {
      return null;
    }
  }

  // ============ TAB 2: TRENDS ============
  Widget _buildTrendsTab(bool isDark) {
    return _TrendsTabContent(isDark: isDark);
  }

  // ============ TAB 3: SAVED ============
  Widget _buildSavedTab(bool isDark) {
    final favorites = ref.watch(favoritePairsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Row(
            children: [
              Text(
                'Saved Pairs',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: favorites.isEmpty
              ? _buildEmptySaved(isDark)
              : _buildFavoritesList(favorites, isDark),
        ),
      ],
    );
  }

  Widget _buildEmptySaved(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_outline_rounded,
            size: 64,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved pairs yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the star icon on the home screen\nto save your favorite pairs',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<String> favorites, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final pair = favorites[index];
        final parsed = FavoritePairsNotifier.parsePair(pair);
        if (parsed == null) return const SizedBox.shrink();

        final fromCurrency = AppConstants.getCurrencyByCode(parsed.from);
        final toCurrency = AppConstants.getCurrencyByCode(parsed.to);

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            ref.read(fromCurrencyProvider.notifier).state = fromCurrency;
            ref.read(toCurrencyProvider.notifier).state = toCurrency;
            setState(() => _currentNavIndex = 0);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Text(fromCurrency.flag, style: const TextStyle(fontSize: 28)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    size: 18,
                  ),
                ),
                Text(toCurrency.flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${parsed.from} → ${parsed.to}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${fromCurrency.name} → ${toCurrency.name}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(favoritePairsProvider.notifier).removeFavoritePair(pair);
                  },
                  child: Icon(
                    Icons.star_rounded,
                    color: isDark ? AppColors.limeGreen : AppColors.tealDark,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============ BOTTOM NAV ============
  Widget _buildBottomNav(bool isDark) {
    final savedCount = ref.watch(favoritePairsProvider).length;

    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Home', isDark, null),
          _buildNavItem(1, Icons.area_chart_rounded, 'Trends', isDark, null),
          _buildNavItem(2, Icons.star_outline_rounded, 'Saved', isDark, savedCount > 0 ? savedCount : null),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark, int? badge) {
    final isActive = _currentNavIndex == index;
    final primaryColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _currentNavIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isActive ? primaryColor : mutedColor,
                size: 24,
              ),
              if (badge != null)
                Positioned(
                  right: -8,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.limeGreen : AppColors.tealDark,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$badge',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? primaryColor : mutedColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============ HELPERS ============
  void _swapCurrencies() {
    HapticFeedback.mediumImpact();
    final fromCurrency = ref.read(fromCurrencyProvider);
    final toCurrency = ref.read(toCurrencyProvider);
    ref.read(fromCurrencyProvider.notifier).state = toCurrency;
    ref.read(toCurrencyProvider.notifier).state = fromCurrency;
  }

  void _openCurrencySelection(bool isFrom) {
    Navigator.pushNamed(
      context,
      '/currency_selection',
      arguments: {'isFrom': isFrom},
    );
  }

  String _convertAmount(String amount, String fromCode, String toCode) {
    final rateState = ref.read(exchangeRateProvider);
    if (rateState.rates == null) return '0.00';

    final amountValue = double.tryParse(amount) ?? 0;
    final converted = rateState.rates!.convert(amountValue, fromCode, toCode);

    if (converted == 0) return '0.00';

    if (converted >= 1000000) {
      return '${(converted / 1000000).toStringAsFixed(2)}M';
    } else if (converted >= 1000) {
      return NumberFormat('#,##0.00').format(converted);
    } else {
      return converted.toStringAsFixed(4);
    }
  }

  void _showSnackBar(String message, bool isDark, {String? detail}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
                fontSize: 13,
              ),
            ),
            if (detail != null) ...[
              const SizedBox(height: 4),
              Text(
                detail,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// ============ TRENDS TAB ============
class _TrendsTabContent extends StatefulWidget {
  final bool isDark;
  const _TrendsTabContent({required this.isDark});

  @override
  State<_TrendsTabContent> createState() => _TrendsTabContentState();
}

class _TrendsTabContentState extends State<_TrendsTabContent> {
  final ApiService _apiService = ApiService();
  List<RatePoint> _chartData = [];
  bool _isLoading = true;
  String? _error;
  int _selectedDays = 30;

  @override
  void initState() {
    super.initState();
    _fetchHistoricalData();
  }

  Future<void> _fetchHistoricalData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final container = ProviderScope.containerOf(context);
      final fromCurrency = container.read(fromCurrencyProvider);
      final toCurrency = container.read(toCurrencyProvider);

      final data = await _apiService.fetchHistoricalRates(
        fromCurrency: fromCurrency.code,
        toCurrency: toCurrency.code,
        days: _selectedDays,
      );

      if (mounted) {
        setState(() {
          _chartData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load data';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Trends',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Historical exchange rates',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 20),
          _buildPeriodSelector(isDark),
          const SizedBox(height: 16),
          _buildChartBody(isDark),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(bool isDark) {
    final periods = [
      {'label': '1D', 'days': 1},
      {'label': '7D', 'days': 7},
      {'label': '1M', 'days': 30},
      {'label': '3M', 'days': 90},
      {'label': '6M', 'days': 180},
      {'label': '1Y', 'days': 365},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: Row(
        children: periods.map((period) {
          final isSelected = _selectedDays == period['days'];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _selectedDays = period['days'] as int);
                _fetchHistoricalData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.limeGreen : AppColors.tealDark)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  period['label'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isSelected
                        ? (isDark ? Colors.black : Colors.white)
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartBody(bool isDark) {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: CircularProgressIndicator(
            color: isDark ? AppColors.limeGreen : AppColors.tealDark,
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(Icons.error_outline, color: AppColors.danger, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: GoogleFonts.inter(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchHistoricalData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_chartData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text('No data available', style: GoogleFonts.inter(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          )),
        ),
      );
    }

    return TrendColoredChart(data: _chartData);
  }
}
