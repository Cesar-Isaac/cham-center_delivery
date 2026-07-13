import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/style/app_theme.dart';


class AuthFooter extends StatelessWidget {
  const AuthFooter({
    super.key,
    required this.text,
    required this.actionText,
    required this.onPressed,
  });

  final String text;
  final String actionText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppTheme.bodyM,
          children: [

            TextSpan(text: text),

            TextSpan(
              text: actionText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer:
              TapGestureRecognizer()
                ..onTap = onPressed,
            ),
          ],
        ),
      ),
    );
  }
}