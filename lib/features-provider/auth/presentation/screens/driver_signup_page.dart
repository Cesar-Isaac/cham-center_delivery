import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/widgets/primary_button.dart';
import '../../../../core/validation/validator.dart';
import '../../../../features_user/authentication/presentation/manager/auth_cubit.dart';
import '../widgets/vehicle_type_dropdown.dart';
import '../../../../features_user/authentication/domain/entities/signup_draft_entity.dart';
import '../../../../features_user/authentication/presentation/widgets/auth_footer.dart';
import '../../../../features_user/authentication/presentation/widgets/auth_header.dart';
import '../../../../features_user/authentication/presentation/widgets/auth_text_field.dart';
import '../../../../features_user/authentication/presentation/widgets/password_text_field.dart';
import 'driver_location_picker_page.dart';
import 'driver_login_page.dart';

class DriverSignupPage extends StatefulWidget {
  static const String route = '/driver-signup';

  const DriverSignupPage({super.key});

  @override
  State<DriverSignupPage> createState() =>
      _DriverSignupPageState();
}

class _DriverSignupPageState
    extends State<DriverSignupPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
  TextEditingController();
  final vehiclePlateController =
  TextEditingController();

  String? _selectedVehicleType;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    vehiclePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  title: "Create Driver Account",
                  subtitle:
                  "Create your driver account to start delivering.",
                ),
                AuthTextField(
                  controller: nameController,
                  label: "Full Name",
                  hint: "Enter your full name",
                  prefixIcon: Icons.person,
                  validator: Validators.fullName,
                ),
                const SizedBox(height: 18),
                AuthTextField(
                  controller: emailController,
                  label: "Email",
                  hint: "example@gmail.com",
                  prefixIcon: Icons.email,
                  keyboardType:
                  TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 18),
                AuthTextField(
                  controller: phoneController,
                  label: "Phone",
                  hint: "+963",
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 18),
                PasswordTextField(
                  controller: passwordController,
                  label: "Password",
                  validator: Validators.password,
                ),
                const SizedBox(height: 18),
                PasswordTextField(
                  controller:
                  confirmPasswordController,
                  label: 'Confirm Password',
                  validator: (value) {
                    return Validators.confirmPassword(
                      value,
                      passwordController.text,
                    );
                  },
                ),
                const SizedBox(height: 18),
                VehicleTypeDropdown(
                  value: _selectedVehicleType,
                  onChanged: (value) {
                    setState(() {
                      _selectedVehicleType = value;
                    });
                  },
                ),
                const SizedBox(height: 18),
                AuthTextField(
                  controller:
                  vehiclePlateController,
                  label: "Vehicle Plate Number",
                  hint: "Enter your vehicle plate number",
                  prefixIcon:
                  Icons.pin_outlined,
                  validator: (value) {
                    return Validators.requiredField(
                      value,
                      fieldName:
                      'Vehicle plate number',
                    );
                  },
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  text: "Continue",
                  onPressed: () {
                    if (!formKey.currentState!
                        .validate()) {
                      return;
                    }

                    // منع استخدام بريد أو هاتف لحساب سائق مسجّل سابقاً.
                    final String? availabilityError =
                    context
                        .read<AuthCubit>()
                        .checkAccountAvailability(
                      email: emailController.text
                          .trim(),
                      phone: phoneController.text
                          .trim(),
                    );

                    if (availabilityError != null) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              availabilityError,
                            ),
                            backgroundColor:
                            Colors.red,
                            behavior:
                            SnackBarBehavior
                                .floating,
                          ),
                        );

                      return;
                    }

                    final draft = SignupDraftEntity(
                      fullName:
                      nameController.text.trim(),
                      email:
                      emailController.text.trim(),
                      phone:
                      phoneController.text.trim(),
                      password:
                      passwordController.text,
                      vehicleType:
                      _selectedVehicleType,
                      vehiclePlate:
                      vehiclePlateController.text
                          .trim(),
                    );

                    Navigator.pushNamed(
                      context,
                      DriverLocationPickerPage.route,
                      arguments: draft,
                    );
                  },
                ),
                const SizedBox(height: 24),
                AuthFooter(
                  text: "Already have an account? ",
                  actionText: "Login",
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      DriverLoginPage.route,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

