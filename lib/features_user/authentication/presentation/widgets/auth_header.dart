import 'package:flutter/material.dart';
import '../../../../core/style/style/app_theme.dart';


class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 20),

        Icon(
          Icons.shopping_bag_rounded,
          size: 70,
          color: Theme.of(context).colorScheme.primary,
        ),

        const SizedBox(height: 24),

        Text(
          title,
          style: AppTheme.titleXL,
        ),

        const SizedBox(height: 8),

        Text(
          subtitle,
          style: AppTheme.bodyM,
        ),

        const SizedBox(height: 36),
      ],
    );
  }
}