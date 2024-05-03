class NutritionalTable {
  double quantity;
  double calorie;
  double carbohydrate;
  double protein;
  double fat;

  NutritionalTable(
      this.quantity, this.calorie, this.carbohydrate, this.protein, this.fat);

  factory NutritionalTable.fromJson(Map<String, dynamic> json) {
    return NutritionalTable(
      json['quantity'],
      json['calorie'],
      json['carbohydrate'],
      json['protein'],
      json['fat'],
    );
  }

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'calorie': calorie,
        'carbohydrate': carbohydrate,
        'protein': protein,
        'fat': fat
      };
}
