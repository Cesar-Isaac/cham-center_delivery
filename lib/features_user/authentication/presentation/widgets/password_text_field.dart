import 'package:flutter/material.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';


class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;

  @override
  State<PasswordTextField> createState() =>
      _PasswordTextFieldState();
}

class _PasswordTextFieldState
    extends State<PasswordTextField> {

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Text(
          widget.label,
          style: AppTheme.titleM,
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: obscure,

          style: AppTheme.bodyL,

          decoration: InputDecoration(

            filled: true,

            fillColor: AppColors.bgCard,

            prefixIcon:
            const Icon(Icons.lock),

            suffixIcon: IconButton(

              onPressed: () {

                setState(() {

                  obscure = !obscure;

                });

              },

              icon: Icon(

                obscure
                    ? Icons.visibility
                    : Icons.visibility_off,

              ),

            ),

            border: OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(18),

            ),

            enabledBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(18),

              borderSide:
              const BorderSide(

                color: AppColors.divider,

              ),

            ),

            focusedBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(18),

              borderSide:
              const BorderSide(

                color: AppColors.primary,

                width: 2,

              ),

            ),
          ),
        ),
      ],
    );
  }
}