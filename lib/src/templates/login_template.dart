import 'package:flutter/material.dart';
import '../core/layout_helpers.dart';

class LoginTemplate extends StatelessWidget {
  const LoginTemplate({
    super.key,
    this.logo,
    this.title = 'Welcome back',
    this.subtitle,
    required this.emailField,
    required this.passwordField,
    required this.loginButton,
    this.forgotPasswordButton,
    this.signUpButton,
    this.socialButtons,
    this.backgroundColor,
  });

  final Widget? logo;
  final String title;
  final String? subtitle;
  final Widget emailField;
  final Widget passwordField;
  final Widget loginButton;
  final Widget? forgotPasswordButton;
  final Widget? signUpButton;
  final List<Widget>? socialButtons;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 48 : 24,
              vertical: 32,
            ),
            child: ContentWidth(
              maxWidth: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (logo != null) ...[
                    Center(child: logo!),
                    const SizedBox(height: 40),
                  ],
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 32),
                  emailField,
                  const SizedBox(height: 16),
                  passwordField,
                  if (forgotPasswordButton != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: forgotPasswordButton!,
                    ),
                  ],
                  const SizedBox(height: 24),
                  loginButton,
                  if (socialButtons != null && socialButtons!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ...socialButtons!,
                  ],
                  if (signUpButton != null) ...[
                    const SizedBox(height: 24),
                    Center(child: signUpButton!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
