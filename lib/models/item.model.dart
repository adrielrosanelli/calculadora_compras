import 'package:calculadora_compras/models/nutritional_table.model.dart';

class Item {
  int id;
  String name;
  double quantity;
  int type;
  NutritionalTable nutritionalTable;

  Item(this.id,this.name, this.quantity, this.type, this.nutritionalTable);

  String suffix = 'g';
  String bigSuffix = 'kg';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'type': type,
        'nutritionalTable': nutritionalTable.toJson(),
      };


  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['id'],
      json['name'],
      json['quantity'],
      json['type'],
      NutritionalTable.fromJson(json['nutritionalTable']),
    );
  }

  String captalize() {
    String firstLetter = name[0].toUpperCase();
    name = firstLetter + name.substring(1);
    return name;
  }

  String getSuffix(){
        if(type ==0){
      suffix = 'g';
      bigSuffix = 'kg';
    }else if(type ==1){
      suffix ='ml';
      bigSuffix = 'L';
    }else if(type ==2){
      suffix ='un';
      bigSuffix = 'un';
    }
    return suffix;}

  String calculateQuantity() {
    if(type ==0){
      suffix = 'g';
      bigSuffix = 'kg';
    }else if(type ==1){
      suffix ='ml';
      bigSuffix = 'L';
    }else if(type ==2){
      suffix ='un';
      bigSuffix = 'un';
    }
    switch (quantity) {
      case >= 1000:
        return '${quantity / 1000} $bigSuffix';
      default:
        return '$quantity $suffix';
    }
  }
}
