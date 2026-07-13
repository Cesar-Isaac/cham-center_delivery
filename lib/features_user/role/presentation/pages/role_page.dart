import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/widgets/primary_button.dart';
import '../../../authentication/presentation/pages/signup_page.dart';
import '../manager/role_cubit.dart';
import '../manager/role_state.dart';
import '../widgets/role_card.dart';

class RolePage extends StatelessWidget {
  static const String route = "/role";

  const RolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<RoleCubit, RoleState>(
          builder: (context, state) {
            final cubit = context.read<RoleCubit>();

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Column(
                children: [
                  const Spacer(),

                  /// Illustration
                  Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    "Choose Your Role",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Select how you want to continue.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 40),

                  RoleCard(
                    title: "Customer",
                    subtitle: "Browse stores and order products.",
                    icon: Icons.person,
                    isSelected:
                    state.selectedRole == UserRole.customer,
                    onTap: cubit.selectCustomer,
                  ),

                  RoleCard(
                    title: "Driver",
                    subtitle: "Deliver orders (Coming Soon).",
                    icon: Icons.delivery_dining,
                    isSelected:
                    state.selectedRole == UserRole.driver,
                    onTap: cubit.selectDriver,
                  ),

                  const Spacer(),

                  PrimaryButton(
                    text: "Continue",
                    onPressed: () {
                      switch (state.selectedRole) {
                        case UserRole.customer:
                          Navigator.pushNamed(
                            context,
                            SignupPage.route,
                          );
                          break;

                        case UserRole.driver:
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Driver mode is coming soon.",
                              ),
                            ),
                          );
                          break;

                        case UserRole.none:
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please select your role.",
                              ),
                            ),
                          );
                          break;
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}