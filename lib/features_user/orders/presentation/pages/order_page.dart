import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../../../core/style/widgets/primary_button.dart';
import '../../../home/presentation/manager/navigation_cubit.dart';

class OrdersPage extends StatelessWidget {
  static const String route = '/orders';

  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Orders',
                style: AppTheme.titleXL,
              ),
            ),
            const Spacer(),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color:
                AppColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 68,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 26),
            Text(
              'No Orders Yet',
              style: AppTheme.titleL,
            ),
            const SizedBox(height: 10),
            Text(
              'Your orders will appear here after you start shopping.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyM,
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              text: 'Start Shopping',
              icon: Icons.storefront_rounded,
              onPressed: () {
                context
                    .read<NavigationCubit>()
                    .openHome();
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}