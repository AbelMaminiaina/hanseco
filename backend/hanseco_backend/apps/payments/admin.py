from django.contrib import admin
from .models import Payment


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ('id', 'order', 'provider', 'status', 'amount', 'created_at')
    list_filter = ('provider', 'status', 'created_at')
    search_fields = ('order__id', 'transaction_id', 'provider_transaction_id')
    readonly_fields = ('created_at', 'updated_at')

    fieldsets = (
        ('Informations générales', {
            'fields': ('order', 'provider', 'status', 'amount')
        }),
        ('Identifiants de transaction', {
            'fields': ('transaction_id', 'provider_transaction_id')
        }),
        ('Métadonnées', {
            'fields': ('metadata',)
        }),
        ('Dates', {
            'fields': ('created_at', 'updated_at')
        }),
    )
