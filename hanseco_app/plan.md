Overview

 Complete upgrade of HansEco e-commerce platform including cart/orders/payments backend integration, OAuth improvements, and  
 enhanced features (reviews, wishlist, order tracking, notifications).

 Note: Auto-accept all edits during implementation for faster execution.

 Implementation Strategy

 Architecture Approach

 - Backend: Django REST Framework with Clean Architecture, service layer for business logic, Celery for async tasks
 - Frontend: Flutter with Clean Architecture (domain/data/presentation), Riverpod state management, Either monad error        
 handling
 - Payments: Stripe integration with webhooks
 - Notifications: Celery + email templates for order updates

 Default Decisions

 - Payment provider: Stripe (easiest for development)
 - OAuth: Keep custom implementation (fix token refresh, username uniqueness, remove Apple Sign In)
 - Features: Reviews, wishlist, order tracking, email notifications (phased implementation)

 ---
 Phase 0: Critical Foundation Fixes (Days 1-10)

 1. Fix Token Refresh Endpoint Mismatch

 Problem: DioClient uses /auth/refresh but SimpleJWT expects /api/auth/token/refresh/

 Backend:
 - backend/hanseco_backend/apps/auth/urls.py - Add TokenRefreshView from SimpleJWT

 Frontend:
 - hanseco_app/lib/core/network/dio_client.dart - Update endpoint to /api/auth/token/refresh/
 - Fix payload: {'refresh': refreshToken} (not 'refresh_token')

 2. Fix Username Uniqueness Issue

 Problem: OAuth creates usernames from email.split('@')[0], causing collisions

 Solution: Make username nullable and non-unique (email is already USERNAME_FIELD)

 Backend:
 - backend/hanseco_backend/apps/auth/models.py - Modify username field: blank=True, null=True, unique=False
 - backend/hanseco_backend/apps/oauth/views.py - Update user creation logic
 - Create migration to alter username constraint

 3. Create Database Migrations

 Apps: cart, orders, payments (currently untracked)

 Tasks:
 - Run makemigrations for all three apps
 - Add database indexes for performance (user_id, product_id, status, created_at)
 - Run migrations

 4. Remove Apple Sign In

 Backend: Already returns 501 NOT IMPLEMENTED

 Frontend:
 - hanseco_app/lib/features/auth/presentation/pages/login_page_with_oauth_example.dart - Remove Apple button

 ---
 Phase 1: Backend - Cart, Orders, Payments (Days 11-27)

 Cart Backend Enhancement

 Create Serializers (backend/hanseco_backend/apps/cart/serializers.py):
 - CartItemSerializer - Nested product details
 - CartSerializer - Cart with items, total, count
 - AddToCartSerializer - Input validation
 - UpdateCartItemSerializer - Quantity validation

 Update Views (backend/hanseco_backend/apps/cart/views.py):
 - Replace manual dict serialization with DRF serializers
 - Add stock validation when adding items
 - Fix image retrieval (use ProductImage relationship, not main_image)
 - Add POST /api/cart/sync/ endpoint for syncing local cart on login

 Orders Backend Implementation

 Create Serializers (backend/hanseco_backend/apps/orders/serializers.py):
 - OrderItemSerializer - Order line items
 - OrderListSerializer - Lightweight for lists
 - OrderDetailSerializer - Full details with tracking
 - CreateOrderSerializer - Checkout input validation
 - OrderTrackingSerializer - Tracking history

 Enhance Models (backend/hanseco_backend/apps/orders/models.py):
 - Add fields: order_number (unique), shipping_country, notes, tracking_number
 - Add timestamps: cancelled_at, shipped_at, delivered_at
 - Create OrderTracking model for status history

 Create Service Layer (backend/hanseco_backend/apps/orders/services.py):
 - create_order_from_cart(user, shipping_data, payment_method):
   - Validate cart not empty
   - Check stock availability
   - Create order with items (atomic transaction)
   - Decrease product stock
   - Clear cart
 - cancel_order(order):
   - Validate order status
   - Restore stock
   - Trigger refund if paid
 - update_order_status(order, new_status, tracking_info):
   - Update status
   - Create tracking entry
   - Trigger email notification

 Update Views (backend/hanseco_backend/apps/orders/views.py):
 - Add POST /api/orders/ - Create order endpoint
 - Add POST /api/orders/{id}/cancel/ - Cancel order
 - Add GET /api/orders/{id}/tracking/ - Tracking history
 - Add filters: status, date range

 Payments Backend Implementation

 Install: pip install stripe

 Create Stripe Service (backend/hanseco_backend/apps/payments/stripe_service.py):
 - create_payment_intent(order) - Create Stripe PaymentIntent
 - confirm_payment(payment_intent_id) - Verify payment
 - create_refund(payment, amount) - Process refunds
 - handle_webhook(payload, signature) - Stripe webhook handler

 Enhance Models (backend/hanseco_backend/apps/payments/models.py):
 - Add: stripe_payment_intent_id, stripe_charge_id, refund_amount, refunded_at

 Create Serializers (backend/hanseco_backend/apps/payments/serializers.py):
 - PaymentSerializer, CreatePaymentIntentSerializer, ConfirmPaymentSerializer, RefundSerializer

 Update Views (backend/hanseco_backend/apps/payments/views.py):
 - Add POST /api/payments/create-intent/ - Create PaymentIntent
 - Add POST /api/payments/confirm/ - Confirm payment
 - Add POST /api/payments/webhook/ - Stripe webhook (public)
 - Add GET /api/payments/order/{order_id}/ - Get payment status

 ---
 Phase 2: Frontend - Cart Backend Integration (Days 28-34)

 Cart Clean Architecture Refactor

 Domain Layer:
 - hanseco_app/lib/features/cart/domain/entities/cart.dart - Cart entity
 - hanseco_app/lib/features/cart/domain/repositories/cart_repository.dart - Repository interface
 - hanseco_app/lib/features/cart/domain/usecases/ - Use cases (get_cart, add_to_cart, sync_cart)

 Data Layer:
 - hanseco_app/lib/features/cart/data/models/cart_model.dart - Cart model with JSON
 - hanseco_app/lib/features/cart/data/datasources/cart_remote_datasource.dart - API calls
 - hanseco_app/lib/features/cart/data/datasources/cart_local_datasource.dart - Hive operations
 - hanseco_app/lib/features/cart/data/repositories/cart_repository_impl.dart - Implementation
   - Logic: If logged in → use backend (with local backup), else → local only
   - On login: sync local cart to backend

 Presentation Layer:
 - hanseco_app/lib/features/cart/presentation/providers/cart_provider.dart - Refactor to use use cases
 - hanseco_app/lib/features/cart/presentation/pages/cart_page.dart - Add pull-to-refresh, error handling

 ---
 Phase 3: Frontend - Orders Implementation (Days 35-42)

 Orders Clean Architecture

 Domain Layer:
 - Entities: order.dart, order_item.dart, order_tracking.dart
 - Repository: order_repository.dart
 - Use cases: get_orders, get_order_detail, create_order, cancel_order

 Data Layer:
 - Models: order_model.dart, order_item_model.dart, order_tracking_model.dart
 - Data source: order_remote_datasource.dart
 - Repository: order_repository_impl.dart

 Presentation Layer:
 - Provider: orders_provider.dart with StateNotifier
 - Pages:
   - Update hanseco_app/lib/features/profile/presentation/pages/orders_page.dart - List orders with filters
   - Create order_detail_page.dart - Show order details, items, tracking, cancel button
   - Create order_tracking_page.dart - Timeline view of tracking history

 ---
 Phase 4: Frontend - Checkout & Payments (Days 43-54)

 Checkout Flow Implementation

 Shipping Address Feature:
 - Backend: Create ShippingAddress model in backend/hanseco_backend/apps/auth/models.py
 - Backend: Add endpoints: GET/POST/PUT/DELETE /api/auth/addresses/
 - Frontend: Create shipping address entities, models, data sources
 - Frontend: Add address management to profile

 Checkout Page (hanseco_app/lib/features/payments/presentation/pages/checkout_page.dart):
 1. Shipping Address Form (select saved or add new)
 2. Review Cart Items
 3. Payment Method Selection (Stripe)
 4. Order Summary & Confirm Button

 Stripe Integration:
 - Add dependency: flutter_stripe: ^10.0.0 to pubspec.yaml
 - Create hanseco_app/lib/core/services/stripe_service.dart:
   - initStripe() - Initialize with publishable key
   - presentPaymentSheet(clientSecret) - Show Stripe payment UI

 Payment Flow:
 1. User clicks "Place Order"
 2. Call POST /api/orders/ → Create order (status=pending)
 3. Call POST /api/payments/create-intent/ → Get client_secret
 4. Show Stripe payment sheet with client_secret
 5. User completes payment
 6. Stripe webhook confirms to backend → Update order status
 7. Frontend shows success page with order number

 Payment Provider:
 - Create hanseco_app/lib/features/payments/presentation/providers/payment_provider.dart
 - State: PaymentStatus (idle, processing, success, failed)

 Payment Success Page:
 - Create payment_success_page.dart - Show order confirmation

 ---
 Phase 5: Enhanced Features (Days 55-66)

 Product Reviews

 Backend:
 - Add ProductReview model to backend/hanseco_backend/apps/products/models.py:
   - Fields: user, product, rating (1-5), title, comment, is_verified_purchase, helpful_count
   - Unique constraint: (user, product)
 - Create serializers: ProductReviewSerializer, CreateReviewSerializer, ReviewSummarySerializer
 - Create ProductReviewViewSet in views.py
 - Endpoints:
   - GET /api/products/{slug}/reviews/ - List reviews
   - POST /api/products/{slug}/reviews/ - Create review (authenticated)
   - PUT /api/products/reviews/{id}/ - Update review (own only)
   - DELETE /api/products/reviews/{id}/ - Delete review (own only)
   - POST /api/products/reviews/{id}/helpful/ - Mark helpful

 Frontend:
 - Create entities, models, data sources for reviews
 - Update product detail page: Show average rating, review list
 - Create write_review_page.dart - Review submission form

 Wishlist

 Backend:
 - Add Wishlist model to backend/hanseco_backend/apps/products/models.py:
   - Fields: user, product, created_at
   - Unique constraint: (user, product)
 - Create WishlistSerializer
 - Create WishlistViewSet
 - Endpoints:
   - GET /api/wishlist/ - List wishlist
   - POST /api/wishlist/ - Add item
   - DELETE /api/wishlist/{id}/ - Remove item
   - GET /api/wishlist/check/{product_id}/ - Check if in wishlist

 Frontend:
 - Create wishlist entities, models, data sources
 - Add heart icon to product cards (toggle wishlist)
 - Create wishlist_page.dart in profile section

 Email Notifications

 Backend:
 - Configure email settings in backend/hanseco_backend/core/settings/base.py (SMTP or SendGrid)
 - Create email templates:
   - backend/templates/emails/order_confirmation.html
   - backend/templates/emails/order_shipped.html
   - backend/templates/emails/order_delivered.html
 - Create Celery tasks in backend/hanseco_backend/apps/orders/tasks.py:
   - send_order_confirmation_email(order_id)
   - send_order_status_update_email(order_id)
   - send_shipping_notification_email(order_id)
 - Trigger tasks from order service layer

 ---
 Database Schema Changes

 New Tables:

 1. product_review: user_id, product_id, rating, title, comment, is_verified_purchase, helpful_count, timestamps
 2. product_wishlist: user_id, product_id, created_at
 3. order_tracking: order_id, status, location, description, created_at
 4. shipping_address: user_id, address fields, is_default, timestamps

 Modified Tables:

 - auth_user: Make username nullable/non-unique
 - orders_order: Add order_number, shipping_country, notes, tracking_number, cancelled_at, shipped_at, delivered_at
 - payments_payment: Add stripe_payment_intent_id, stripe_charge_id, refund_amount, refunded_at

 Indexes to Add:

 - cart: user_id, cart_item: cart_id, product_id
 - orders: user_id, status, created_at
 - payments: order_id, status, created_at
 - reviews: user_id, product_id, rating, created_at
 - wishlist: user_id, product_id

 ---
 API Endpoints Summary

 New Endpoints:

 - POST /api/auth/token/refresh/ - SimpleJWT token refresh
 - POST /api/cart/sync/ - Sync local cart
 - POST /api/orders/ - Create order
 - POST /api/orders/{id}/cancel/ - Cancel order
 - GET /api/orders/{id}/tracking/ - Order tracking
 - POST /api/payments/create-intent/ - Create Stripe PaymentIntent
 - POST /api/payments/confirm/ - Confirm payment
 - POST /api/payments/webhook/ - Stripe webhook
 - GET /api/payments/order/{order_id}/ - Payment status
 - GET/POST/PUT/DELETE /api/products/{slug}/reviews/ - Reviews CRUD
 - GET/POST/DELETE /api/wishlist/ - Wishlist operations
 - GET/POST/PUT/DELETE /api/auth/addresses/ - Shipping addresses

 ---
 Dependencies to Add

 Backend (requirements.txt):

 stripe==8.0.0
 celery[redis]==5.3.4
 django-celery-beat==2.5.0

 Frontend (pubspec.yaml):

 flutter_stripe: ^10.0.0

 External Services:

 1. Stripe: Create account, get API keys, set up webhook
 2. Email Service: Configure SMTP (Gmail) or SendGrid
 3. Redis: For Celery (local install or managed service)

 ---
 Critical Files to Implement

 Backend Priority:

 1. backend/hanseco_backend/apps/orders/services.py - Order business logic (NEW)
 2. backend/hanseco_backend/apps/payments/stripe_service.py - Stripe integration (NEW)
 3. backend/hanseco_backend/apps/oauth/views.py - Fix username issue (MODIFY)
 4. backend/hanseco_backend/apps/cart/serializers.py - Cart serializers (NEW)
 5. backend/hanseco_backend/apps/orders/serializers.py - Order serializers (NEW)

 Frontend Priority:

 1. hanseco_app/lib/core/network/dio_client.dart - Fix token refresh endpoint (MODIFY)
 2. hanseco_app/lib/features/cart/data/repositories/cart_repository_impl.dart - Cart sync logic (NEW)
 3. hanseco_app/lib/features/payments/presentation/pages/checkout_page.dart - Checkout flow (MODIFY)
 4. hanseco_app/lib/core/services/stripe_service.dart - Stripe SDK integration (NEW)
 5. hanseco_app/lib/features/orders/domain/repositories/order_repository.dart - Order contract (NEW)

 ---
 Testing Strategy

 Backend:

 - Unit tests: Models, serializers, services
 - Integration tests: API endpoints
 - Payment tests: Stripe test cards
 - Email tests: Mock Celery tasks

 Frontend:

 - Unit tests: Entities, use cases, providers
 - Widget tests: Pages and widgets
 - Integration tests: Complete user flows
 - Payment tests: Stripe test mode

 Manual Testing Checklist:

 - Complete checkout flow (cart → order → payment)
 - Token refresh on expiration
 - OAuth login (Google, Facebook)
 - Cart sync on login
 - Order cancellation
 - Email notifications
 - Reviews and wishlist
 - Stock validation

 ---
 Implementation Timeline

 - Days 1-10: Phase 0 - Critical fixes
 - Days 11-27: Phase 1 - Backend cart/orders/payments
 - Days 28-34: Phase 2 - Cart frontend integration
 - Days 35-42: Phase 3 - Orders frontend
 - Days 43-54: Phase 4 - Checkout & payments frontend
 - Days 55-66: Phase 5 - Reviews, wishlist, notifications
 - Days 67-70: Testing, bug fixes, documentation

 Total Estimated Duration: 10-12 weeks

 ---
 Risk Mitigation

 High-Risk Areas:

 1. Payment Integration: Use Stripe test mode, implement webhook verification
 2. Stock Management: Use database transactions to prevent race conditions
 3. Token Refresh: Test token expiration scenarios thoroughly
 4. Cart Sync: Handle merge conflicts intelligently

 Rollback Strategy:

 - Feature flags for new features
 - Backward-compatible database migrations
 - Keep OAuth working throughout changes