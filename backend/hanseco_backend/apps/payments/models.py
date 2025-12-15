from django.db import models
from hanseco_backend.apps.orders.models import Order


class Payment(models.Model):
    """Transaction de paiement"""
    PROVIDER_CHOICES = [
        ('mvola', 'MVola'),
        ('airtel', 'Airtel Money'),
        ('orange', 'Orange Money'),
        ('paypal', 'PayPal'),
        ('stripe', 'Stripe'),
    ]

    STATUS_CHOICES = [
        ('pending', 'En attente'),
        ('processing', 'En traitement'),
        ('completed', 'Complété'),
        ('failed', 'Échoué'),
        ('refunded', 'Remboursé'),
    ]

    order = models.ForeignKey(
        Order,
        on_delete=models.CASCADE,
        related_name='payments'
    )
    provider = models.CharField(max_length=20, choices=PROVIDER_CHOICES)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    amount = models.DecimalField(max_digits=10, decimal_places=2)

    # Identifiants de transaction
    transaction_id = models.CharField(max_length=255, blank=True, null=True)
    provider_transaction_id = models.CharField(max_length=255, blank=True, null=True)

    # Détails supplémentaires
    metadata = models.JSONField(default=dict, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Paiement'
        verbose_name_plural = 'Paiements'
        ordering = ['-created_at']

    def __str__(self):
        return f"Paiement #{self.id} - {self.provider} - {self.status}"
