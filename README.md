# Quezel Cross-Platform Ordering System

A Flutter-based mobile-first ordering system for Quezel's Palamig Treats. The project is currently focused on completing the customer ordering experience, with planned role-specific dashboards for Admin and Rider after the customer side is stable.

## Project Summary

Quezel is designed as a cross-platform ordering app for food, desserts, and palamig products. Customers can browse products, manage favorites, add items to cart, checkout, manage delivery details, and track their own orders through an in-memory service layer.

The app currently uses local Flutter state and in-memory services. Persistent storage, real authentication, payment integration, rider dispatch, and backend APIs are planned for later phases.

## User Roles

### Customer

Current priority and most complete role.

- Browse products by category
- Search products
- View product details
- Add/remove favorites
- Add items to cart
- Update cart quantities
- Checkout orders
- Select delivery/pickup information
- Manage profile and delivery address
- View and manage orders
- Mark orders as received
- Cancel eligible orders
- Request refunds
- Reorder previous purchases

### Admin

Planned management role. Screens already exist as placeholders or early scaffolds.

- Admin dashboard
- Product management
- Order management
- Inventory management
- User management
- Sales analytics

### Rider

Planned delivery role for the Tablon dashboard flow. This will be implemented after the customer experience is completed.

- Assigned delivery list
- Delivery status updates
- Customer address view
- ETA and delivery tracking
- Completed delivery history
- Future map/location integration

## Current Product Categories

- Halo-Halo
- Crema De Leche
- Mais Con Yelo
- Snacks
- Drinks
- Dishes
- Platters

## Main Features

### Landing and Authentication

- Sticky landing header with section burger navigation
- Landing sections: hero, about, menu, how it works, features, testimonials, footer
- Floating scroll-to-top action
- Mobile-first sign-in and sign-up screens
- Demo login buttons for Facebook, Google, and mobile number
- Demo auth routes currently continue into the customer onboarding flow

### Customer App

- Home product browsing
- Favorites page
- Cart page
- Checkout page
- Product detail page
- Profile setup and delivery address management
- My Orders page
- Transaction history page
- Sticky bottom navigation only on Home and Favorites

### In-Memory Services

- `CartService` for cart state and totals
- `FavoriteService` for customer favorites
- `OrderService` for order creation, status updates, refund requests, and reorder flow
- `ProductService` for menu/product data
- `DeliveryLocationService` and `UserAddressService` for delivery location/address state
- `UserProfileService` for profile display data

## Project Structure

```text
lib/
  main.dart

  core/
    constants/
      app_colors.dart
      app_routes.dart
      app_strings.dart
    services/
      auth_service.dart
      cart_service.dart
      delivery_location_service.dart
      favorite_service.dart
      order_service.dart
      product_service.dart
      storage_service.dart
      user_address_service.dart
      user_profile_service.dart
    theme/
      app_theme.dart
    utils/
      helpers.dart
      validators.dart

  data/
    category_data.dart
    product_data.dart

  models/
    cart_item.dart
    delivery_location.dart
    order.dart
    product.dart
    user.dart

  screens/
    landing/
      landing_page.dart
      auth/
        auth_choice_page.dart
        sign_in_page.dart
        sign_up_page.dart
      onboarding/
        onboarding_page.dart
      sections/
        about_section.dart
        features_section.dart
        footer.dart
        hero_section.dart
        how_it_works_section.dart
        menu_section.dart
        testimonials_section.dart
      widgets/
        navbar.dart

    customer/
      home/user_mobile_home.dart
      product/product_detail_page.dart
      cart/cart_page.dart
      checkout/checkout_page.dart
      favorites/favorites_page.dart
      profile/
        profile_page.dart
        delivery_address_page.dart
      orders/
        my_orders_page.dart
        transaction_history_page.dart

    admin/
      dashboard/admin_dashboard.dart
      products/manage_products_page.dart
      orders/manage_orders_page.dart
      inventory/inventory_page.dart
      users/manage_users_page.dart
      analytics/analytics_page.dart

  widgets/
    bottom_nav.dart
    category_chip.dart
    circle_icon_button.dart
    custom_button.dart
    custom_text_field.dart
    product_card.dart
    quantity_button.dart
    search_bar.dart

  routes/
    app_router.dart
```

## Current Routes

Defined in `lib/main.dart`:

- `/` - Landing page
- `/auth/sign-in` - Sign in
- `/auth/sign-up` - Sign up
- `/user/onboarding` - Customer onboarding
- `/user/dashboard` - Customer home/dashboard

## Design Direction

- Mobile-first layout
- Light Quezel theme
- Red brand accents
- Soft green supporting accents
- Clear customer ordering flow
- Simple, readable screens before adding backend complexity
- Bottom navigation limited to screens where it improves customer browsing flow

## Future Work

### Customer Completion

- Finish customer-side polish and edge cases
- Improve order tracking UX
- Add persistence for profile, address, cart, favorites, and orders
- Add payment flow when the backend/data layer is ready

### Rider and Delivery

- Rider role and Tablon dashboard screens
- Rider assignment
- Delivery status updates
- Estimated delivery time
- Customer delivery address handoff
- Optional future packages:
  - `geolocator`
  - `geocoding`
  - `google_maps_flutter`

### Admin

- Product CRUD
- Order status management
- Customer/user management
- Inventory tracking
- Sales analytics

## Development Notes

- This project is currently frontend-first.
- Most state is in memory through service classes.
- Admin and Rider are planned roles, but customer completion is the current priority.
- Avoid adding backend, maps, or real auth dependencies until the customer flow is finished and stable.

Customer selects product
↓
Adds to cart
↓
Checks out
↓
Mock order is created
↓
Customer sees Pending status
↓
Admin opens Orders screen
↓
Admin accepts order
↓
Customer tracking changes to Accepted
↓
Admin marks Preparing
↓
Customer tracking changes to Preparing
↓
Admin marks Out for Delivery
↓
Customer tracking changes to Out for Delivery
↓
Admin marks Delivered
↓
Customer sees Delivered