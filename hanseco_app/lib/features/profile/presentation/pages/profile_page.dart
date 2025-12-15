import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/oauth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _ProfileHeader(
            name: authState.user?.name ?? 'Utilisateur',
            email: authState.user?.email ?? 'email@example.com',
          ),
          SizedBox(height: 24.h),
          _MenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Mes commandes',
            onTap: () => context.push('/orders'),
          ),
          _MenuItem(
            icon: Icons.favorite_outline,
            title: 'Mes favoris',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.location_on_outlined,
            title: 'Adresses',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.payment_outlined,
            title: 'Moyens de paiement',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.help_outline,
            title: 'Aide',
            onTap: () {},
          ),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 16.h),
          _MenuItem(
            icon: Icons.logout,
            title: 'Déconnexion',
            onTap: () async {
              // Logout from both auth providers
              await ref.read(authNotifierProvider.notifier).logout();
              try {
                await ref.read(oauthNotifierProvider.notifier).signOut();
              } catch (e) {
                // OAuth provider might not be initialized
              }
              if (context.mounted) {
                context.go('/login');
              }
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileHeader({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              name[0].toUpperCase(),
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4.h),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? Colors.black87;

    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(
        title,
        style: TextStyle(color: itemColor),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    );
  }
}
