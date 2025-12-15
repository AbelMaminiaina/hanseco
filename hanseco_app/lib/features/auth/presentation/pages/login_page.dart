import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../providers/oauth_provider.dart';
import '../widgets/oauth_buttons.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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

  Future<void> _handleLogin() async {
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
          SnackBar(content: Text(authState.error!)),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final oauthNotifier = ref.read(oauthNotifierProvider.notifier);
      await oauthNotifier.signInWithGoogle();

      final oauthState = ref.read(oauthNotifierProvider);

      if (oauthState.isAuthenticated && mounted) {
        // Synchronize OAuth data with main auth provider
        if (oauthState.user != null) {
          ref.read(authNotifierProvider.notifier).setUserFromOAuth(oauthState.user!);
        }
        context.go('/home');
      } else if (oauthState.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(oauthState.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google OAuth non configuré. Consultez OAUTH_SETUP.md'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _handleFacebookSignIn() async {
    try {
      final oauthNotifier = ref.read(oauthNotifierProvider.notifier);
      await oauthNotifier.signInWithFacebook();

      final oauthState = ref.read(oauthNotifierProvider);

      if (oauthState.isAuthenticated && mounted) {
        // Synchronize OAuth data with main auth provider
        if (oauthState.user != null) {
          ref.read(authNotifierProvider.notifier).setUserFromOAuth(oauthState.user!);
        }
        context.go('/home');
      } else if (oauthState.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(oauthState.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Facebook OAuth non configuré. Consultez OAUTH_SETUP.md'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    // Don't watch OAuth provider at build time to avoid initialization
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),
              Icon(
                Icons.shopping_bag,
                size: 80.sp,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 20.h),
              Text(
                'Connexion',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'Connectez-vous à votre compte',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),

              // OAuth Buttons
              GoogleSignInButton(
                onPressed: _handleGoogleSignIn,
                isLoading: false,
              ),
              SizedBox(height: 12.h),
              FacebookSignInButton(
                onPressed: _handleFacebookSignIn,
                isLoading: false,
              ),
              SizedBox(height: 24.h),

              // Divider
              const OrDivider(),
              SizedBox(height: 24.h),

              // Email/Password Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
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
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Mot de passe',
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to forgot password
                    },
                    child: const Text('Mot de passe oublié ?'),
                  ),
                ),
                    SizedBox(height: 24.h),
                    CustomButton(
                      text: 'Se connecter',
                      onPressed: isLoading ? null : _handleLogin,
                      isLoading: authState.isLoading,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Vous n\'avez pas de compte ? '),
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: const Text('S\'inscrire'),
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
