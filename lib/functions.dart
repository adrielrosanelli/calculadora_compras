import 'dart:convert';
import 'dart:developer';

import 'package:flu/models/item.model.dart';
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
    log(jsonEncode(list),name:'listaLida');
    return list;
  }

  encodeItemToLocalStorage(List<Item> items) async {
    prefs = await SharedPreferences.getInstance();
        List<Map<String,dynamic>> listToSave = [];
    for (var item in items) {
      listToSave.add(item.toJson());
    }
    String saveList = jsonEncode(listToSave);
    log(saveList,name:'lista');
    prefs.setString('shop_list', saveList);
  }
}