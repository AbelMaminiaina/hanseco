// EXEMPLE: Comment intégrer OAuth2 dans la page de login existante
// Copiez les parties nécessaires dans login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../providers/oauth_provider.dart';
import '../widgets/oauth_buttons.dart';

class LoginPageWithOAuth extends ConsumerStatefulWidget {
  const LoginPageWithOAuth({super.key});

  @override
  ConsumerState<LoginPageWithOAuth> createState() => _LoginPageWithOAuthState();
}

class _LoginPageWithOAuthState extends ConsumerState<LoginPageWithOAuth> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login traditionnel avec email/password
  Future<void> _handleEmailLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authNotifierProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );

      final authState = ref.read(authNotifierProvider);

      if (authState.isAuthenticated && mounted) {
        context.go('/home');
      } else if (authState.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Login avec Google
  Future<void> _handleGoogleSignIn() async {
    final oauthNotifier = ref.read(oauthNotifierProvider.notifier);

    await oauthNotifier.signInWithGoogle();

    final oauthState = ref.read(oauthNotifierProvider);

    if (oauthState.isAuthenticated && mounted) {
      context.go('/home');
    } else if (oauthState.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(oauthState.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Login avec Facebook
  Future<void> _handleFacebookSignIn() async {
    final oauthNotifier = ref.read(oauthNotifierProvider.notifier);

    await oauthNotifier.signInWithFacebook();

    final oauthState = ref.read(oauthNotifierProvider);

    if (oauthState.isAuthenticated && mounted) {
      context.go('/home');
    } else if (oauthState.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(oauthState.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final oauthState = ref.watch(oauthNotifierProvider);

    // Loading state (soit email login, soit OAuth)
    final isLoading = authState.isLoading || oauthState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),

              // Logo
              Icon(
                Icons.shopping_bag,
                size: 80.sp,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 16.h),

              // Title
              Text(
                'Bienvenue',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),

              Text(
                'Connectez-vous pour continuer',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),

              // ========== BOUTONS OAUTH ==========
              GoogleSignInButton(
                onPressed: _handleGoogleSignIn,
                isLoading: oauthState.isLoading,
              ),
              SizedBox(height: 12.h),

              FacebookSignInButton(
                onPressed: _handleFacebookSignIn,
                isLoading: oauthState.isLoading,
              ),
              SizedBox(height: 24.h),

              // Divider "OU"
              const OrDivider(),
              SizedBox(height: 24.h),

              // ========== LOGIN TRADITIONNEL ==========
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        if (!value.contains('@')) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Mot de passe',
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                        },
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Login Button
                    CustomButton(
                      text: 'Se connecter',
                      onPressed: isLoading ? null : _handleEmailLogin,
                      isLoading: authState.isLoading,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pas encore de compte ? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
