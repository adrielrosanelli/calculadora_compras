import 'package:calculadora_compras/functions.dart';
import 'package:calculadora_compras/models/item.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (contex) => ThemeDataProvider(),
      child: Consumer<ThemeDataProvider>(builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Calculadora de Compras',
          theme: Provider.of<ThemeDataProvider>(context).themeData,
          home: const MyHomePage(title: 'Calculadora de compras'),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> items = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    Functions().decodeItemFromLocalStorage().then((value) => {
          items = value,
          setState(() {}),
        });
    super.initState();
  }

  void _addItemToList(Item newValue) {
    int? index;
    for (var i = 0; i < items.length; i++) {
      if (items[i].name.trim().toLowerCase() ==
          newValue.name.trim().toLowerCase()) {
        index = i;
      }
    }
    if (index != null) {
      Item existingItem = items[index];
      items[index].quantity = existingItem.quantity + newValue.quantity;
    } else {
      items.add(newValue);
    }
    _nameController.clear();
    _quantityController.clear();
    Functions().encodeItemToLocalStorage(items);
    setState(() {});
  }

  void clearList() {
    items.clear();
    Functions().encodeItemToLocalStorage(items);
    setState(() {});
  }

  void removeListItem(int index) {
    items.removeAt(index);
    Functions().encodeItemToLocalStorage(items);
    setState(() {});
  }

  void editItem(int i, String name, double quantity) {
    int? index;
    for (var i = 0; i < items.length; i++) {
      if (items[i].name.trim().toLowerCase() == name.trim().toLowerCase()) {
        index = i;
      }
    }
    if (index != null) {
      Item existingItem = items[index];
      items[index].quantity = existingItem.quantity + quantity;
      items.removeAt(i);
    } else {
      items[i].name = name;
      items[i].quantity = quantity;
    }

    _nameController.clear();
    _quantityController.clear();
    Functions().encodeItemToLocalStorage(items);
    setState(() {});
    Navigator.pop(context);
  }

  void changeLightMode() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: const Icon(Icons.brightness_4))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Nome do item',
                  label: Text('Item'),
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: '150',
                  label: Text('Quantidade'),
                  suffix: Text('gramas'),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  if (_nameController.text.isNotEmpty &&
                      _quantityController.text.isNotEmpty) {
                    _addItemToList(Item(_nameController.text,
                        double.parse(_quantityController.text)));
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _quantityController.text.isNotEmpty) {
                  _addItemToList(Item(_nameController.text,
                      double.parse(_quantityController.text)));
                }
              },
              child: const Text('Adicionar'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lista de Compras'),
                  IconButton(
                      onPressed: items.isEmpty
                          ? null
                          : () {
                              clearList();
                            },
                      icon: const Icon(
                        Icons.delete_forever,
                      )),
                      ///TODO Fazer botão de compartilhar;
                  // IconButton(onPressed: (){
                  //   Share.share('text');
                  // }, icon:const Icon(Icons.share))
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.edit,
                        color: Theme.of(context).colorScheme.secondary),
                    onTap: () {
                      _nameController.text = items[index].name;
                      _quantityController.text =
                          items[index].quantity.toString();
                      showModalBottomSheet(
                        isDismissible: true,
                        context: context,
                        builder: (context) => SizedBox(
                          width: 400,
                          height: 250,
                          child: Column(
                            children: [
                              const SizedBox(height: 50),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                child: TextFormField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: 'Nome do item',
                                    label: Text('Item'),
                                  ),
                                ),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                child: TextFormField(
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'Peso',
                                    label: Text('Quantidade'),
                                    suffix: Text('gramas'),
                                  ),
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) {
                                    editItem(index, _nameController.text,
                                        double.parse(_quantityController.text));
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: () {
                                  editItem(index, _nameController.text,
                                      double.parse(_quantityController.text));
                                },
                                child: const Text('Salvar'),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      );
                    },
                    //contentPadding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    tileColor: Theme.of(context).colorScheme.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      '${items[index].captalize()} ${items[index].calculateQuantity()}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          removeListItem(index);
                        },
                        icon: Icon(Icons.close,
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF3e6cc7),
    secondary: Colors.white,
    tertiary: const Color(0xFF3b5faa),
  ),
  useMaterial3: true,
);
ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF3e6cc7),
    secondary: const Color.fromARGB(255, 249, 249, 249),
    tertiary: const Color(0xFF3b5faa),
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);

class ThemeDataProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData == lightTheme ? darkTheme : lightTheme;
    notifyListeners();
  }
}
