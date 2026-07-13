import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/widgets/primary_button.dart';
import '../../../../core/validation/validator.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_text_field.dart';
import '../../../home/presentation/pages/home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.route,
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
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(
                      title: 'Welcome Back',
                      subtitle:
                      'Login to explore stores and continue shopping.',
                    ),

                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'example@gmail.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType:
                      TextInputType.emailAddress,
                      validator: Validators.email,
                    ),

                    const SizedBox(height: 18),

                    PasswordTextField(
                      controller: _passwordController,
                      label: 'Password',
                      validator: Validators.password,
                    ),

                    const SizedBox(height: 30),

                    PrimaryButton(
                      text: 'Login',
                      icon: Icons.login_rounded,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _login,
                    ),

                    const SizedBox(height: 24),

                    AuthFooter(
                      text: "Don't have an account? ",
                      actionText: 'Create Account',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          SignupPage.route,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}