c# AI Agent Refactoring Guide for Clean Code Architecture

## Purpose

Refactor all code that needs improvement to make the project clean, maintainable, scalable, and professional. The main goal is to avoid spaghetti code, duplicated UI, inline styling everywhere, and large files that are hard to maintain.

This guide should be followed by the AI agent whenever refactoring existing code or creating new code.

---

## Main Refactoring Goals

The AI agent must refactor the codebase with these goals:

1. Avoid inline styles when styles are repeated.
2. Avoid duplicated UI code.
3. Separate UI, logic, constants, themes, widgets, and data models.
4. Create reusable components/widgets.
5. Keep files small and focused.
6. Improve folder structure.
7. Improve naming conventions.
8. Remove unused imports, unused variables, and dead code.
9. Make the code easier to read, debug, and extend.
10. Prevent spaghetti code.

---

## Refactoring Rules

### 1. Do Not Inline Repeated Styles

Avoid writing the same `TextStyle`, `BoxDecoration`, padding, margin, colors, border radius, and shadows repeatedly inside widgets.

Instead, move reusable styles into:

- `app_theme.dart`
- `app_colors.dart`
- `app_text_styles.dart`
- `app_spacing.dart`
- reusable widgets

Bad:

```dart
Text(
  "Hello",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF5A2D0C),
  ),
)
```

Good:

```dart
Text(
  "Hello",
  style: AppTextStyles.heading,
)
```

---

### 2. Create Reusable Widgets

If a UI block is used more than once, create a reusable widget.

Examples:

- Product card
- Category card
- Custom button
- Custom text field
- Loading widget
- Empty state widget
- Error widget
- Section header
- Bottom navigation item
- App bar/header
- Cart item tile
- Address card

Suggested folder:

```text
lib/shared/widgets/
lib/features/customer/widgets/
lib/features/admin/widgets/
```

---

### 3. Separate Screens From Widgets

Screens should only organize the page layout.

Avoid putting too much UI inside one screen file.

Bad:

```text
home_screen.dart
- header
- product card
- category list
- promo banner
- cart button
- bottom nav
- all logic
```

Good:

```text
home_screen.dart
widgets/
  home_header.dart
  promo_banner.dart
  category_list.dart
  product_card.dart
  product_section.dart
```

---

### 4. Use a Clean Folder Structure

Follow a professional project structure like this:

```text
lib/
  core/
    constants/
    theme/
    utils/
    routes/
  shared/
    widgets/
    models/
    services/
  features/
    auth/
      screens/
      widgets/
      models/
      services/
    customer/
      screens/
      widgets/
      models/
      services/
    admin/
      screens/
      widgets/
      models/
      services/
```

---

### 5. Keep Business Logic Away From UI

Avoid putting too much logic inside the `build()` method.

Move logic into:

- controller
- provider
- service
- helper function
- state management file

Bad:

```dart
Widget build(BuildContext context) {
  final total = products.fold(0, (sum, item) => sum + item.price);
  return ...
}
```

Good:

```dart
final total = CartHelper.calculateTotal(products);
```

---

### 6. Use Constants for Fixed Values

Do not hardcode repeated strings, colors, asset paths, route names, or numbers.

Create files like:

```text
app_assets.dart
app_routes.dart
app_strings.dart
app_sizes.dart
app_colors.dart
```

Example:

```dart
class AppAssets {
  static const logo = "assets/images/logo.png";
  static const deliveryRider = "assets/images/delivery_rider.png";
}
```

---

### 7. Use Meaningful Names

Use clear and professional names.

Bad:

```dart
Container box1;
String txt;
Widget btn;
```

Good:

```dart
Container productCard;
String customerName;
Widget checkoutButton;
```

---

### 8. Avoid Very Large Files

If a file becomes too long, split it.

Recommended maximum:

- Screen file: around 150–250 lines
- Widget file: around 50–150 lines
- Helper/service file: focused on one responsibility

---

### 9. Remove Dead Code

The AI agent must remove:

- unused imports
- commented old code
- unused variables
- duplicate functions
- unused widgets
- old test credentials
- unnecessary debug prints

Do not remove code that is still required.

---

### 10. Improve UI Consistency

All UI should follow one consistent design system.

Use shared values for:

- colors
- font sizes
- border radius
- shadows
- spacing
- button styles
- input styles
- card styles

---

## AI Agent Prompt

Use this prompt when asking the AI agent to refactor code:

```text
Refactor this code professionally.

Goals:
- Avoid spaghetti code.
- Avoid repeated inline styles.
- Move reusable UI into separate widgets.
- Move repeated styles into theme/style files.
- Keep the screen clean and readable.
- Separate logic from UI.
- Use proper naming conventions.
- Remove unused imports, dead code, and unnecessary comments.
- Preserve the existing UI design and functionality.
- Do not break routing, assets, imports, or existing features.
- Follow Flutter/Dart clean code best practices.
- If needed, suggest a better folder structure before modifying.
- Return the complete updated code, not partial snippets.
```

---

## Refactoring Checklist

Before finishing, the AI agent must check:

- [ ] No unnecessary inline repeated styles.
- [ ] Reusable UI is extracted into widgets.
- [ ] Screen files are not too large.
- [ ] Logic is not heavily mixed inside UI.
- [ ] Constants are moved to proper files.
- [ ] Naming is clear and professional.
- [ ] No unused imports.
- [ ] No unused variables.
- [ ] No duplicated code.
- [ ] Existing UI still looks the same unless improvement was requested.
- [ ] Existing functionality still works.
- [ ] Code is easy to maintain.

---

## Important Instruction

Do not refactor everything blindly.

Only refactor code that needs refactoring. Preserve working code unless it has clear issues such as duplication, poor structure, inline repeated styles, messy logic, or poor naming.

Always prioritize clean code, maintainability, scalability, and professional structure.
