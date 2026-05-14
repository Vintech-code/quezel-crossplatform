import '../models/product.dart';

const customerCategories = [
  "All",
  "Palamig",
  "Burgers",
  "Fries",
  "Drinks",
  "Combos",
];

const Map<String, List<Product>> customerProductSections = {
  "Palamig": [
    Product(
      name: "Halo-Halo Large",
      price: "₱78.00",
      kcal: "354 kcal",
      image: "assets/images/1.png",
      ingredients: [
        IngredientItem(name: "Shaved ice", calories: "35 kcal"),
        IngredientItem(name: "Evaporated milk", calories: "45 kcal"),
        IngredientItem(name: "Sweetened banana", calories: "60 kcal"),
        IngredientItem(name: "Sweet beans", calories: "55 kcal"),
        IngredientItem(name: "Nata de coco", calories: "35 kcal"),
        IngredientItem(name: "Leche flan", calories: "75 kcal"),
        IngredientItem(name: "Ube topping", calories: "49 kcal"),
      ],
    ),
    Product(
      name: "Halo-Halo Medium",
      price: "₱55.00",
      kcal: "285 kcal",
      image: "assets/images/2.png",
      ingredients: [
        IngredientItem(name: "Shaved ice", calories: "30 kcal"),
        IngredientItem(name: "Evaporated milk", calories: "38 kcal"),
        IngredientItem(name: "Sweetened banana", calories: "48 kcal"),
        IngredientItem(name: "Sweet beans", calories: "42 kcal"),
        IngredientItem(name: "Nata de coco", calories: "28 kcal"),
        IngredientItem(name: "Leche flan", calories: "60 kcal"),
        IngredientItem(name: "Ube topping", calories: "39 kcal"),
      ],
    ),
    Product(
      name: "Crema De Leche",
      price: "₱78.00",
      kcal: "320 kcal",
      image: "assets/images/3.png",
      ingredients: [
        IngredientItem(name: "Shaved ice", calories: "35 kcal"),
        IngredientItem(name: "Evaporated milk", calories: "45 kcal"),
        IngredientItem(name: "Cream milk", calories: "85 kcal"),
        IngredientItem(name: "Leche flan", calories: "90 kcal"),
        IngredientItem(name: "Caramel syrup", calories: "40 kcal"),
        IngredientItem(name: "Cheese topping", calories: "25 kcal"),
      ],
    ),
    Product(
      name: "Mais Con Yelo",
      price: "₱65.00",
      kcal: "260 kcal",
      image: "assets/images/4.png",
      ingredients: [
        IngredientItem(name: "Shaved ice", calories: "30 kcal"),
        IngredientItem(name: "Sweet corn", calories: "85 kcal"),
        IngredientItem(name: "Evaporated milk", calories: "45 kcal"),
        IngredientItem(name: "Condensed milk", calories: "55 kcal"),
        IngredientItem(name: "Cornflakes", calories: "30 kcal"),
        IngredientItem(name: "Cheese topping", calories: "15 kcal"),
      ],
    ),
  ],
  "Burgers": [
    Product(
      name: "Regular Burger",
      price: "₱59.00",
      kcal: "360 kcal",
      image: "assets/images/burger_regular.png",
      addOns: [
        ProductAddOn(name: "Egg Add-on", price: "₱16.00", type: "Add-on"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Burger bun", calories: "150 kcal"),
        IngredientItem(name: "Burger patty", calories: "180 kcal"),
        IngredientItem(name: "Burger sauce", calories: "30 kcal"),
      ],
    ),
    Product(
      name: "Cheese Burger",
      price: "₱69.00",
      kcal: "390 kcal",
      image: "assets/images/burger_cheese.png",
      addOns: [
        ProductAddOn(name: "Egg Add-on", price: "₱16.00", type: "Add-on"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Burger bun", calories: "150 kcal"),
        IngredientItem(name: "Burger patty", calories: "180 kcal"),
        IngredientItem(name: "Cheese", calories: "60 kcal"),
      ],
    ),
    Product(
      name: "Bacon Lettuce Cheese Burger",
      price: "₱85.00",
      kcal: "430 kcal",
      image: "assets/images/burger_lettucecheese.png",
      addOns: [
        ProductAddOn(name: "Egg Add-on", price: "₱16.00", type: "Add-on"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Burger bun", calories: "150 kcal"),
        IngredientItem(name: "Burger patty", calories: "180 kcal"),
        IngredientItem(name: "Bacon", calories: "70 kcal"),
        IngredientItem(name: "Lettuce", calories: "10 kcal"),
        IngredientItem(name: "Cheese", calories: "60 kcal"),
      ],
    ),
  ],
  "Fries": [
    Product(
      name: "Regular Fries Solo",
      price: "₱35.00",
      kcal: "270 kcal",
      image: "assets/images/fries_regular.png",
      addOns: [
        ProductAddOn(
          name: "Cheese Flavor Upgrade",
          price: "₱3.00",
          type: "Flavor",
        ),
        ProductAddOn(
          name: "Sour Cream Flavor Upgrade",
          price: "₱5.00",
          type: "Flavor",
        ),
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Potato fries", calories: "250 kcal"),
        IngredientItem(name: "Salt", calories: "20 kcal"),
      ],
    ),
    Product(
      name: "Fries with Cheese",
      price: "₱39.00",
      kcal: "310 kcal",
      image: "assets/images/fries_cheese.png",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Potato fries", calories: "250 kcal"),
        IngredientItem(name: "Cheese flavor", calories: "60 kcal"),
      ],
    ),
    Product(
      name: "Sour Cream Fries",
      price: "₱45.00",
      kcal: "300 kcal",
      image: "assets/images/fries_sourcream.png",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Potato fries", calories: "250 kcal"),
        IngredientItem(name: "Sour cream flavor", calories: "50 kcal"),
      ],
    ),
  ],
  "Drinks": [
    Product(
      name: "Solo Drinks Large",
      price: "₱20.00",
      kcal: "120 kcal",
      image: "assets/images/icedtea_large.png",
      ingredients: [IngredientItem(name: "Large drink", calories: "120 kcal")],
    ),
    Product(
      name: "Lemon Juice Large",
      price: "₱45.00",
      kcal: "140 kcal",
      image: "assets/images/lemonjuice_large.png",
      ingredients: [
        IngredientItem(name: "Lemon juice", calories: "25 kcal"),
        IngredientItem(name: "Sugar syrup", calories: "115 kcal"),
      ],
    ),
    Product(
      name: "Iced Tea Regular",
      price: "₱35.00",
      kcal: "120 kcal",
      image: "assets/images/icedtea_regular.png",
      ingredients: [
        IngredientItem(name: "Tea", calories: "15 kcal"),
        IngredientItem(name: "Sugar syrup", calories: "105 kcal"),
      ],
    ),
    Product(
      name: "Lemon Juice Regular",
      price: "₱35.00",
      kcal: "110 kcal",
      image: "assets/images/lemonjuice_regular.png",
      ingredients: [
        IngredientItem(name: "Lemon juice", calories: "20 kcal"),
        IngredientItem(name: "Sugar syrup", calories: "90 kcal"),
      ],
    ),
  ],
  "Combos": [
    Product(
      name: "Regular Burger with Large Drink",
      price: "₱76.00",
      kcal: "480 kcal",
      image: "assets/images/regular_burger_combo.png",
      savings: "Save ₱3",
      isCombo: true,
      description: "Regular burger paired with a large drink.",
      addOns: [
        ProductAddOn(name: "Egg Add-on", price: "₱16.00", type: "Add-on"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Regular burger", calories: "360 kcal"),
        IngredientItem(name: "Large drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Regular Burger Combo Meal",
      price: "₱99.00",
      kcal: "750 kcal",
      image: "assets/images/regular_sulit_pairs.png",
      savings: "Save ₱10",
      isCombo: true,
      description: "Regular burger with regular fries and regular drink.",
      addOns: [
        ProductAddOn(
          name: "Cheese Fries Upgrade",
          price: "₱3.00",
          type: "Flavor",
        ),
        ProductAddOn(
          name: "Sour Cream Fries Upgrade",
          price: "₱5.00",
          type: "Flavor",
        ),
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Regular burger", calories: "360 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Cheese Burger Combo Meal",
      price: "₱109.00",
      kcal: "780 kcal",
      image: "assets/images/cheese_burger_combo.png",
      savings: "Save ₱10",
      isCombo: true,
      description: "Cheese burger with regular fries and regular drink.",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Cheese burger", calories: "390 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Cheese Sulit Pairs",
      price: "₱109.00",
      kcal: "780 kcal",
      image: "assets/images/cheese_sulit_pairs.png",
      savings: "Save ₱10",
      isCombo: true,
      description: "Cheese burger with regular fries and regular drink.",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Cheese burger", calories: "390 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Supreme Regular Burger Combo",
      price: "₱152.00",
      kcal: "1035 kcal",
      image: "assets/images/regular_supreme_combo.png",
      savings: "Save ₱12",
      isCombo: true,
      description:
          "Regular burger, medium halo-halo, regular fries, and regular drink.",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Regular burger", calories: "360 kcal"),
        IngredientItem(name: "Medium halo-halo", calories: "285 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Cheese Supreme Combo",
      price: "₱152.00",
      kcal: "1065 kcal",
      image: "assets/images/cheese_supreme_combo.png",
      savings: "Save ₱12",
      isCombo: true,
      description:
          "Cheese burger, medium halo-halo, regular fries, and regular drink.",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Cheese burger", calories: "390 kcal"),
        IngredientItem(name: "Medium halo-halo", calories: "285 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
  ],
};
