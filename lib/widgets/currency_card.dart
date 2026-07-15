import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CurrencyCard extends StatefulWidget {
  final String label;
  final String currencyCode;
  final String currencyName;
  final String flag;
  final String? amount;
  final String? initialAmount;
  final bool isInput;
  final VoidCallback onTap;
  final ValueChanged<String>? onAmountChanged;
  final bool showConvertedAmount;

  const CurrencyCard({
    super.key,
    required this.label,
    required this.currencyCode,
    required this.currencyName,
    required this.flag,
    this.amount,
    this.initialAmount,
    this.isInput = false,
    required this.onTap,
    this.onAmountChanged,
    this.showConvertedAmount = false,
  });

  @override
  State<CurrencyCard> createState() => _CurrencyCardState();
}

class _CurrencyCardState extends State<CurrencyCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialAmount ?? '');
  }

  @override
  void didUpdateWidget(CurrencyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialAmount != oldWidget.initialAmount && widget.initialAmount != null) {
      if (_controller.text != widget.initialAmount) {
        _controller.text = widget.initialAmount!;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final amountColor = widget.showConvertedAmount
        ? (isDark ? AppColors.limeGreen : AppColors.tealDark)
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceLight = isDark ? AppColors.darkSurfaceLight : AppColors.lightBorder.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.showConvertedAmount
            ? (isDark ? const Color(0xFF1A2E1A) : const Color(0xFFE8F5E9))
            : cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.showConvertedAmount
              ? (isDark ? AppColors.limeGreen.withValues(alpha: 0.3) : AppColors.tealDark.withValues(alpha: 0.3))
              : borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  color: mutedColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.flag,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.currencyCode,
                        style: GoogleFonts.inter(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: secondaryColor,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.isInput)
            _buildAmountInput(textColor, mutedColor)
          else
            _buildConvertedAmount(amountColor),
        ],
      ),
    );
  }

  Widget _buildAmountInput(Color textColor, Color mutedColor) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      style: GoogleFonts.inter(
        color: textColor,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
      ),
      decoration: InputDecoration(
        hintText: '0',
        hintStyle: GoogleFonts.inter(
          color: mutedColor,
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      onChanged: widget.onAmountChanged,
    );
  }

  Widget _buildConvertedAmount(Color amountColor) {
    return Text(
      widget.amount ?? '0.00',
      style: GoogleFonts.inter(
        color: amountColor,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
      ),
    );
  }
}
