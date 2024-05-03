import 'dart:convert';
import 'package:calculadora_compras/models/item.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Functions {
  late final SharedPreferences prefs;

  Functions();

  Future<List<Item>> decodeItemFromLocalStorage() async {
    prefs = await SharedPreferences.getInstance();
    String savedString = prefs.getString('shop_list')??'';
    List encodedList = [];
    List<Item> list = [];
    if(savedString.isNotEmpty) encodedList = jsonDecode(savedString);
    for (var item in encodedList) {
      list.add(Item.fromJson(item));
    }
    return list;
  }

  encodeItemToLocalStorage(List<Item> items) async {
    prefs = await SharedPreferences.getInstance();
        List<Map<String,dynamic>> listToSave = [];
    for (var item in items) {
      listToSave.add(item.toJson());
    }
    String saveList = jsonEncode(listToSave);
    prefs.setString('shop_list', saveList);
  }
}