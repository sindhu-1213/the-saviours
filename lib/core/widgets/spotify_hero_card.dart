import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'status_pill.dart';

class SpotifyHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? bottomWidget;
  final Gradient? gradient;
  final String? footerText;

  const SpotifyHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.badgeColor,
    required this.icon,
    this.iconBgColor = AppColors.primaryGreen,
    this.onTap,
    this.trailing,
    this.bottomWidget,
    this.gradient,
    this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        gradient: gradient ?? AppColors.heroGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: iconBgColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: iconBgColor.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Icon(icon, color: iconBgColor, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    if (badgeText != null)
                      StatusPill(
                        label: badgeText!,
                        color: badgeColor ?? AppColors.primaryGreen,
                      )
                    else if (trailing != null)
                      trailing!,
                  ],
                ),
                if (bottomWidget != null) ...[
                  const SizedBox(height: 16),
                  bottomWidget!,
                ],
                if (footerText != null) ...[
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          footerText!,
                          style: AppTypography.caption,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.textSecondary),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
