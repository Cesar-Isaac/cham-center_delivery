import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../../../core/style/widgets/primary_button.dart';
import '../../../../features_user/authentication/presentation/manager/auth_cubit.dart';
import '../../../../features_user/authentication/presentation/manager/auth_state.dart';
import '../../../auth/presentation/screens/driver_login_page.dart';
import 'driver_edit_profile_page.dart';

class DriverProfilePage extends StatelessWidget {
  static const String route = '/driver-profile';

  const DriverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) {
        if (state.status ==
            AuthStatus.unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            DriverLoginPage.route,
                (route) => false,
          );
        }

        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        final driver = state.user;
        final bool isLoading =
            state.status == AuthStatus.loading;

        final String initial =
        driver?.fullName.trim().isNotEmpty == true
            ? driver!.fullName
            .trim()
            .substring(0, 1)
            .toUpperCase()
            : 'D';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Driver Profile'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                          AppColors.primaryLight,
                          width: 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initial,
                        style: AppTheme.titleXL
                            .copyWith(fontSize: 38),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      driver?.fullName ?? 'Driver',
                      style: AppTheme.titleL,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withOpacity(0.12),
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.delivery_dining,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Delivery Driver',
                            style: AppTheme.labelS
                                .copyWith(
                              color:
                              AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _ProfileInfoTile(
                    icon:
                    Icons.person_outline_rounded,
                    title: 'Full Name',
                    value: driver?.fullName ??
                        'Not available',
                  ),
                  const SizedBox(height: 12),
                  _ProfileInfoTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: driver?.email ??
                        'Not available',
                  ),
                  const SizedBox(height: 12),
                  _ProfileInfoTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: driver?.phone ??
                        'Not available',
                  ),
                  const SizedBox(height: 12),
                  _ProfileInfoTile(
                    icon:
                    Icons.location_on_outlined,
                    title: 'Address',
                    value: driver?.address ??
                        'Not available',
                  ),
                  const SizedBox(height: 12),
                  _ProfileInfoTile(
                    icon: Icons
                        .local_shipping_outlined,
                    title: 'Vehicle Type',
                    value: driver?.vehicleType ??
                        'Not available',
                  ),
                  const SizedBox(height: 12),
                  _ProfileInfoTile(
                    icon: Icons.pin_outlined,
                    title: 'Vehicle Plate Number',
                    value: driver?.vehiclePlate ??
                        'Not available',
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          DriverEditProfilePage
                              .route,
                        );
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                      ),
                      label: const Text(
                        'Edit Profile',
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    text: 'Logout',
                    icon: Icons.logout_rounded,
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () {
                      context
                          .read<AuthCubit>()
                          .logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary
                  .withOpacity(0.12),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.labelM,
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: AppTheme.bodyL,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
