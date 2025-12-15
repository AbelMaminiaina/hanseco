import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  String? _selectedPaymentMethod;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  final _paymentMethods = [
    {'id': 'mvola', 'name': 'MVola', 'color': AppColors.mvola},
    {'id': 'airtel', 'name': 'Airtel Money', 'color': AppColors.airtel},
    {'id': 'orange', 'name': 'Orange Money', 'color': AppColors.orange},
    {'id': 'paypal', 'name': 'PayPal', 'color': AppColors.paypal},
    {'id': 'stripe', 'name': 'Carte bancaire (Stripe)', 'color': AppColors.stripe},
  ];

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartNotifierProvider);
    final cartNotifier = ref.read(cartNotifierProvider.notifier);

    if (cartState.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Paiement'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 100.sp,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 16.h),
              Text(
                'Votre panier est vide',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: 'Retour aux produits',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      );
    }

    const deliveryFee = 5000.0;
    final total = cartState.total + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adresse de livraison',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre adresse de livraison',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Numéro de téléphone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Résumé de la commande',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  _OrderSummaryCard(
                    subtotal: cartState.total,
                    deliveryFee: deliveryFee,
                    total: total,
                    itemCount: cartState.itemCount,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Méthode de paiement',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  ...List.generate(
                    _paymentMethods.length,
                    (index) {
                      final method = _paymentMethods[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _PaymentMethodCard(
                          id: method['id'] as String,
                          name: method['name'] as String,
                          color: method['color'] as Color,
                          isSelected: _selectedPaymentMethod == method['id'],
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = method['id'] as String;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: CustomButton(
                text: 'Confirmer le paiement - ${total.toStringAsFixed(0)} Ar',
                onPressed: _selectedPaymentMethod != null &&
                        _addressController.text.isNotEmpty &&
                        _phoneController.text.isNotEmpty
                    ? () async {
                        // Show confirmation dialog
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmer le paiement'),
                            content: Text(
                              'Vous allez payer ${total.toStringAsFixed(0)} Ar via $_selectedPaymentMethod',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Confirmer'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          // TODO: Implement actual payment processing
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Paiement via $_selectedPaymentMethod en cours...',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );

                          // Clear cart after successful payment
                          await cartNotifier.clearCart();

                          // Navigate to order confirmation
                          if (context.mounted) {
                            context.go('/home');
                          }
                        }
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;
  final int itemCount;

  const _OrderSummaryCard({
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _SummaryRow(
            'Sous-total ($itemCount articles)',
            '${subtotal.toStringAsFixed(0)} Ar',
          ),
          SizedBox(height: 8.h),
          _SummaryRow(
            'Livraison',
            '${deliveryFee.toStringAsFixed(0)} Ar',
          ),
          SizedBox(height: 8.h),
          const Divider(),
          SizedBox(height: 8.h),
          _SummaryRow(
            'Total',
            '${total.toStringAsFixed(0)} Ar',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow(
    this.label,
    this.value, {
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge
              : Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String id;
  final String name;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.id,
    required this.name,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.payment,
                color: color,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
              ),
          ],
        ),
      ),
    );
  }
}
