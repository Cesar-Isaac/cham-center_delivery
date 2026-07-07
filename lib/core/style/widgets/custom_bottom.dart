import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracking_provider/core/style/style/app_theme.dart';

import '../repo/app_colors.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 40,
      child:ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? CircularProgressIndicator.adaptive(backgroundColor: AppColors.primary,)
              : Text(text,
            style: AppTheme.titleM,
          )
      ),
    );


  }
}