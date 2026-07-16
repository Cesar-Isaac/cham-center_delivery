import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../../../core/style/widgets/primary_button.dart';
import '../../../../core/validation/validator.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../../authentication/presentation/manager/auth_cubit.dart';
import '../../../authentication/presentation/manager/auth_state.dart';
import '../../../authentication/presentation/pages/address_picker_page.dart';
import '../../../authentication/presentation/widgets/auth_text_field.dart';
import '../../../authentication/presentation/widgets/password_text_field.dart';

class EditProfilePage extends StatefulWidget {
  static const String route = '/edit-profile';

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final TextEditingController _passwordController =
  TextEditingController();

  late String _address;
  late double _latitude;
  late double _longitude;

  @override
  void initState() {
    super.initState();

    final user =
        context.read<AuthCubit>().state.user;

    _nameController = TextEditingController(
      text: user?.fullName ?? '',
    );
    _emailController = TextEditingController(
      text: user?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: user?.phone ?? '',
    );

    _address = user?.address ?? '';
    _latitude = user?.latitude ?? 0;
    _longitude = user?.longitude ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _changeAddress() async {
    final Object? result =
    await Navigator.pushNamed(
      context,
      AddressPickerPage.route,
      arguments: LatLng(_latitude, _longitude),
    );

    if (result is! PickedAddressResult ||
        !mounted) {
      return;
    }

    setState(() {
      _address = result.address;
      _latitude = result.location.latitude;
      _longitude = result.location.longitude;
    });
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ??
        false)) {
      return;
    }

    final user =
        context.read<AuthCubit>().state.user;

    if (user == null) return;

    final String newPassword =
    _passwordController.text;

    final UserEntity updatedUser = user.copyWith(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: newPassword.isEmpty
          ? user.password
          : newPassword,
      address: _address,
      latitude: _latitude,
      longitude: _longitude,
    );

    await context
        .read<AuthCubit>()
        .updateProfile(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) {
        if (state.status ==
            AuthStatus.profileUpdated) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'تم تحديث معلومات الحساب بنجاح.',
                ),
                backgroundColor: Colors.green,
                behavior:
                SnackBarBehavior.floating,
              ),
            );

          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final bool isLoading =
            state.status == AuthStatus.loading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    AuthTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      prefixIcon: Icons
                          .person_outline_rounded,
                      validator:
                      Validators.fullName,
                    ),
                    const SizedBox(height: 18),
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType
                          .emailAddress,
                      prefixIcon:
                      Icons.email_outlined,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 18),
                    AuthTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      hint:
                      'Enter your phone number',
                      keyboardType:
                      TextInputType.phone,
                      prefixIcon:
                      Icons.phone_outlined,
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 18),
                    PasswordTextField(
                      controller:
                      _passwordController,
                      label:
                      'New Password (optional)',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return null;
                        }

                        return Validators.password(
                          value,
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Address',
                      style: AppTheme.titleM,
                    ),
                    const SizedBox(height: 8),
                    _AddressTile(
                      address: _address,
                      onEdit: isLoading
                          ? null
                          : _changeAddress,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      text: 'Save Changes',
                      icon: Icons.check_rounded,
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : _saveProfile,
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

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    required this.onEdit,
  });

  final String address;
  final VoidCallback? onEdit;

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
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              address.isEmpty
                  ? 'No address selected'
                  : address,
              style: AppTheme.bodyM,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_location_alt_outlined,
              size: 18,
            ),
            label: const Text('Change'),
          ),
        ],
      ),
    );
  }
}
