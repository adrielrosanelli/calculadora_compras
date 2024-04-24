class Item {
  String name;
  double quantity;

  Item(this.name, this.quantity);

  Map<String,dynamic> toJson ()=>{
    'name': name,
    'quantity': quantity
  };

  factory Item.fromJson(Map<String,dynamic> json){
    return Item(json['name'], json['quantity']);
  }

  String captalize() {
    String firstLetter = name[0].toUpperCase();
    name = firstLetter + name.substring(1);
    return name;
  }

  String calculateQuantity() {
    switch (quantity) {
      case > 1000:
        return '${quantity / 1000} kg';
      default:
        '$quantity g';
    }
    return '$quantity g';
  }
}