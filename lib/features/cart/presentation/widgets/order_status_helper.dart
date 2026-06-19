import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

class OrderStatusHelper {
  static Color getColor(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xFFF59E0B); // Amber
      case 'Processing':
        return AppColors.primary;
      case 'Shipped':
        return const Color(0xFF8B5CF6); // Purple
      case 'Delivered':
        return AppColors.success;
      case 'Cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  static String getLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'Pending':
        return l10n.statusPending;
      case 'Processing':
        return l10n.statusProcessing;
      case 'Shipped':
        return l10n.statusShipped;
      case 'Delivered':
        return l10n.statusDelivered;
      case 'Cancelled':
        return l10n.statusCancelled;
      default:
        return status;
    }
  }
}
