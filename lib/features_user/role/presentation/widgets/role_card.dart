import 'package:flutter/material.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';


class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.divider,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(.15)
                        : AppColors.bgSheet,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 34,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.titleL,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        subtitle,
                        style: AppTheme.bodyM,
                      ),
                    ],
                  ),
                ),

                AnimatedSwitcher(
                  duration:
                  const Duration(milliseconds: 250),
                  child: isSelected
                      ? const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    key: ValueKey(1),
                  )
                      : const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textHint,
                    size: 18,
                    key: ValueKey(2),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}