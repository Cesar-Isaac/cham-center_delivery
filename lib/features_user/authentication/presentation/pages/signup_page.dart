import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/style/widgets/primary_button.dart';


import '../../../../core/validation/validator.dart';
import '../manager/auth_cubit.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_text_field.dart';

import 'location_picker_page.dart';
import 'login_page.dart';

import '../../domain/entities/signup_draft_entity.dart';

class SignupPage extends StatefulWidget {

  static const String route = "/signup";

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {

    nameController.dispose();

    emailController.dispose();

    phoneController.dispose();

    passwordController.dispose();

    confirmPasswordController.dispose();

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

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const AuthHeader(

                  title: "Create Account",

                  subtitle:
                  "Create your account to continue shopping.",

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
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  validator: (value) {
                    return Validators.confirmPassword(
                      value,
                      passwordController.text,
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

                    // منع استخدام بريد أو هاتف لحساب مسجّل سابقاً.
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

                    final draft =
                    SignupDraftEntity(

                      fullName:
                      nameController.text.trim(),

                      email:
                      emailController.text.trim(),

                      phone:
                      phoneController.text.trim(),

                      password:
                      passwordController.text,

                    );

                    Navigator.pushNamed(

                      context,

                      LocationPickerPage.route,

                      arguments: draft,

                    );

                  },

                ),

                const SizedBox(height: 24),

                AuthFooter(

                  text:
                  "Already have an account? ",

                  actionText: "Login",

                  onPressed: () {

                    Navigator.pushReplacementNamed(

                      context,

                      LoginPage.route,

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