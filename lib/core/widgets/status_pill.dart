import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class StatusPill extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool isFilled;

  const StatusPill({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.icon,
    this.isFilled = true,
  });

  factory StatusPill.verified({String label = 'VERIFIED'}) {
    return StatusPill(
      label: label,
      color: AppColors.primaryGreen,
      textColor: Colors.black,
      icon: Icons.check_circle_rounded,
    );
  }

  factory StatusPill.pending({String label = 'PENDING REVIEW'}) {
    return StatusPill(
      label: label,
      color: AppColors.warningOrange,
      textColor: Colors.black,
      icon: Icons.hourglass_top_rounded,
    );
  }

  factory StatusPill.rejected({String label = 'REJECTED'}) {
    return StatusPill(
      label: label,
      color: AppColors.emergencyRed,
      textColor: Colors.white,
      icon: Icons.cancel_rounded,
    );
  }

  factory StatusPill.critical({String label = 'CRITICAL'}) {
    return StatusPill(
      label: label,
      color: AppColors.emergencyRed,
      textColor: Colors.white,
      icon: Icons.warning_rounded,
    );
  }

  factory StatusPill.cleared({String label = 'GREEN CORRIDOR'}) {
    return StatusPill(
      label: label,
      color: AppColors.corridorGreen,
      textColor: Colors.black,
      icon: Icons.traffic_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pillColor = color ?? AppColors.primaryGreen;
    final txtColor = textColor ?? (isFilled ? Colors.black : pillColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isFilled ? pillColor : pillColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: isFilled ? null : Border.all(color: pillColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: txtColor),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: AppTypography.caption.copyWith(
              color: txtColor,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
