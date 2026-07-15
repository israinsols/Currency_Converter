import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../models/currency.dart';
import '../providers/currency_provider.dart';
import '../providers/favorites_provider.dart';

class CurrencySelectionScreen extends ConsumerStatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  ConsumerState<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState
    extends ConsumerState<CurrencySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Currency> _filteredCurrencies = [];
  bool _isFrom = true;
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _isFrom = args?['isFrom'] ?? true;
    _filteredCurrencies = List.from(AppConstants.allCurrencies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filterCurrencies(query);
    });
  }

  void _filterCurrencies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = List.from(AppConstants.allCurrencies);
      } else {
        _filteredCurrencies = AppConstants.allCurrencies
            .where((currency) =>
                currency.code.toLowerCase().contains(query.toLowerCase()) ||
                currency.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectCurrency(Currency currency) {
    HapticFeedback.lightImpact();
    if (_isFrom) {
      ref.read(fromCurrencyProvider.notifier).state = currency;
    } else {
      ref.read(toCurrencyProvider.notifier).state = currency;
    }
    ref.read(recentlyUsedProvider.notifier).addCurrency(currency.code);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final recentlyUsed = ref.watch(recentlyUsedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isFrom ? 'Select From Currency' : 'Select To Currency',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(isDark),
          if (favorites.isNotEmpty) _buildFavoritesSection(favorites, isDark),
          if (recentlyUsed.isNotEmpty && _searchController.text.isEmpty)
            _buildRecentlyUsedSection(recentlyUsed, isDark),
          if (_searchController.text.isEmpty) _buildPopularSection(isDark),
          Expanded(
            child: _buildCurrencyList(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: GoogleFonts.inter(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search currency...',
          hintStyle: GoogleFonts.inter(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFavoritesSection(List<String> favorites, bool isDark) {
    final favoriteCurrencies = favorites
        .where((code) => AppConstants.isValidCurrencyCode(code))
        .map((code) => AppConstants.getCurrencyByCode(code))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'FAVORITES',
            style: GoogleFonts.inter(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: favoriteCurrencies.length,
            itemBuilder: (context, index) {
              final currency = favoriteCurrencies[index];
              return _buildQuickCurrencyItem(currency, isDark);
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildRecentlyUsedSection(List<String> recentlyUsed, bool isDark) {
    final currencies = recentlyUsed
        .where((code) => AppConstants.isValidCurrencyCode(code))
        .map((code) => AppConstants.getCurrencyByCode(code))
        .toList();

    if (currencies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'RECENTLY USED',
            style: GoogleFonts.inter(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              return _buildQuickCurrencyItem(currencies[index], isDark);
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPopularSection(bool isDark) {
    final popularCurrencies = AppConstants.popularCurrencyCodes
        .map((code) => AppConstants.getCurrencyByCode(code))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'POPULAR',
            style: GoogleFonts.inter(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: popularCurrencies.length,
            itemBuilder: (context, index) {
              return _buildQuickCurrencyItem(popularCurrencies[index], isDark);
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildQuickCurrencyItem(Currency currency, bool isDark) {
    return GestureDetector(
      onTap: () => _selectCurrency(currency),
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currency.flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              currency.code,
              style: GoogleFonts.inter(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredCurrencies.length,
      itemBuilder: (context, index) {
        final currency = _filteredCurrencies[index];
        return _buildCurrencyListItem(currency, isDark);
      },
    );
  }

  Widget _buildCurrencyListItem(Currency currency, bool isDark) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(currency.code);

    return GestureDetector(
      onTap: () => _selectCurrency(currency),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Text(currency.flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.code,
                    style: GoogleFonts.inter(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currency.name,
                    style: GoogleFonts.inter(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              currency.symbol,
              style: GoogleFonts.inter(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(favoritesProvider.notifier).toggleFavorite(currency.code);
              },
              child: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isFavorite
                    ? AppColors.warning
                    : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
