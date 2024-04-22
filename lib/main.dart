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
      child: Consumer<ThemeDataProvider>(
        builder: (context,provider,child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Calculadora de Compras',
            theme: Provider.of<ThemeDataProvider>(context).themeData,
            home: const MyHomePage(title: 'Calculadora de compras'),
          );
        }
      ),
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

  void _addItemToList(Item newValue) {
    int? index;
    for (var i = 0; i < items.length; i++) {
      if (items[i].name.toLowerCase() == newValue.name.toLowerCase()) {
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
    setState(() {});
  }

  void clearList() {
    items.clear();
    setState(() {});
  }

  void removeListItem(int index) {
    items.removeAt(index);
    setState(() {});
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
                // changeLightMode();
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
                decoration: const InputDecoration(
                  hintText: 'Frango',
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
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
                  _addItemToList(Item(_nameController.text, double.parse(_quantityController.text)));
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
                      onPressed:items.isEmpty ?null : () {
                        clearList();
                      },
                      icon:const Icon(
                        Icons.delete_forever,
                      )),
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
                    contentPadding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    tileColor: Theme.of(context).colorScheme.tertiary,
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      '${items[index].captalize()} ${items[index].calculateQuantity()}',
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          removeListItem(index);
                        },
                        icon: const Icon(
                          Icons.close,
                        )),
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

class Item {
  String name;
  double quantity;

  Item(this.name, this.quantity);

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
    secondary:const Color.fromARGB(255, 249, 249, 249),
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
