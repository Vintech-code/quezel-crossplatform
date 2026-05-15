import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/product_catalog_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../../models/product_availability.dart';
import '../../../widgets/adaptive_image.dart';
import '../widgets/admin_shell.dart';
import '../widgets/admin_surface_card.dart';

class ProductEditorPage extends StatefulWidget {
  final Product? product;

  const ProductEditorPage({super.key, this.product});

  @override
  State<ProductEditorPage> createState() => _ProductEditorPageState();
}

class _ProductEditorPageState extends State<ProductEditorPage> {
  final catalog = ProductCatalogService.instance;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();
  final descriptionController = TextEditingController();
  final savingsController = TextEditingController();
  final imagePicker = ImagePicker();

  late String selectedCategory;
  ProductAvailability selectedAvailability = ProductAvailability.available;
  bool isCombo = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    selectedCategory = product == null
        ? (catalog.categories.isNotEmpty ? catalog.categories.first : "Menu")
        : (catalog.categoryForProduct(product.name) ?? "Menu");
    selectedAvailability =
        product?.availability ?? ProductAvailability.available;
    isCombo = product?.isCombo ?? false;
    nameController.text = product?.name ?? "";
    priceController.text = product?.price ?? "";
    imageController.text = product?.image ?? "";
    descriptionController.text = product?.description ?? "";
    savingsController.text = product?.savings ?? "";
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    imageController.dispose();
    descriptionController.dispose();
    savingsController.dispose();
    super.dispose();
  }

  void _save() {
    if (!formKey.currentState!.validate()) return;

    final product = Product(
      name: nameController.text.trim(),
      price: _normalizePrice(priceController.text),
      kcal: "",
      image: imageController.text.trim(),
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      savings: savingsController.text.trim().isEmpty
          ? null
          : savingsController.text.trim(),
      isCombo: isCombo,
      ingredients: const [],
      addOns: widget.product?.addOns ?? const [],
      availability: selectedAvailability,
      stock: widget.product?.stock ?? 20,
    );

    if (widget.product == null) {
      catalog.addProduct(category: selectedCategory, product: product);
    } else {
      final originalCategory =
          catalog.categoryForProduct(widget.product!.name) ?? selectedCategory;
      catalog.updateProductInCategory(
        originalName: widget.product!.name,
        originalCategory: originalCategory,
        newCategory: selectedCategory,
        product: product,
      );
    }

    Navigator.pop(context);
  }

  String _normalizePrice(String raw) {
    final cleaned = raw.replaceAll("₱", "").replaceAll(",", "").trim();
    if (cleaned.isEmpty) return "";
    final value = double.tryParse(cleaned);
    if (value == null) return raw.trim();
    return "₱${value.toStringAsFixed(2)}";
  }

  Future<void> _pickImage() async {
    final picked = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 92,
    );

    if (picked == null) return;

    final path = picked.path;
    if (!_isSupportedImage(path)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select a PNG or JPG image.")),
      );
      return;
    }

    setState(() => imageController.text = path);
  }

  bool _isSupportedImage(String path) {
    final lower = path.toLowerCase();
    if (lower.startsWith("blob:") ||
        lower.startsWith("http://") ||
        lower.startsWith("https://")) {
      return true;
    }

    return lower.endsWith(".png") ||
        lower.endsWith(".jpg") ||
        lower.endsWith(".jpeg") ||
        lower.startsWith("assets/");
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return AdminShell(
      title: isEditing ? "Edit Product" : "Add Product",
      subtitle: isEditing
          ? "Update product info and availability."
          : "Create a new menu item for customers.",
      activeSection: AdminSection.products,
      body: [
        AdminSurfaceCard(
          padding: const EdgeInsets.all(16),
          radius: AppRadius.md,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product details",
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                _EditorRow(
                  left: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Product name",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter a product name";
                      }
                      return null;
                    },
                  ),
                  right: TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Price (₱)"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter a price";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _EditorRow(
                  left: DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(labelText: "Category"),
                    items: catalog.categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedCategory = value);
                    },
                  ),
                  right: DropdownButtonFormField<ProductAvailability>(
                    initialValue: selectedAvailability,
                    decoration: const InputDecoration(
                      labelText: "Availability",
                    ),
                    items: ProductAvailability.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedAvailability = value);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                _EditorRow(
                  left: TextFormField(
                    controller: savingsController,
                    decoration: const InputDecoration(
                      labelText: "Savings label",
                    ),
                  ),
                  right: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Combo meal",
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                        ),
                      ),
                      Switch(
                        value: isCombo,
                        onChanged: (value) => setState(() => isCombo = value),
                        activeThumbColor: AppColors.coffeeBrown,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _EditorRow(
                  left: TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(labelText: "Image path"),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Select an image";
                      }
                      return null;
                    },
                  ),
                  right: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: const Text("Upload PNG/JPG"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.coffeeBrown,
                        side: BorderSide(
                          color: AppColors.softGold.withValues(alpha: 0.6),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (imageController.text.trim().isNotEmpty)
                  Container(
                    height: 180,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warmBeige,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: AppColors.softGold.withValues(alpha: 0.4),
                      ),
                    ),
                    child: AdaptiveImage(
                      path: imageController.text.trim(),
                      fit: BoxFit.contain,
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coffeeBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(isEditing ? "Save changes" : "Create"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EditorRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const _EditorRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;

        if (!isWide) {
          return Column(children: [left, const SizedBox(height: 12), right]);
        }

        return Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 12),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}
