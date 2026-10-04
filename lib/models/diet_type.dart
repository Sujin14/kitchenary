/// Veg / non-veg classification, shown with the familiar green / red dot.
enum DietType {
  vegan('Vegan'),
  vegetarian('Vegetarian'),
  nonVeg('Non-veg'),
  unknown('');

  const DietType(this.label);
  final String label;

  bool get isVeg => this == vegan || this == vegetarian;
}
