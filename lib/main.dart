import 'package:calculadora_compras/functions.dart';
import 'package:calculadora_compras/models/item.model.dart';
import 'package:calculadora_compras/utils/colors.dart';
import 'package:calculadora_compras/utils/market_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
  Item? selectedItem;
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

  selectOption(Item newItem) {
    selectedItem = newItem;
    setState(() {});
  }

  void _addItemToList(Item newValue) {
    int? index;
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == newValue.id) {
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
    selectedItem = null;
    setState(() {});
    Navigator.pop(context);
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

  void editItem(int index, Item editedItem) {
    items[index].quantity = editedItem.quantity;
    _nameController.clear();
    _quantityController.clear();
    Functions().encodeItemToLocalStorage(items);
    selectedItem = null;
    setState(() {});
    Navigator.pop(context);
  }

  showNutritionalTable(Item item) {
    return showAdaptiveDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Tabela Nutricional do - ${item.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    
                    children: [
                      const TableRow(children: [
                        Text('Quantidade',textAlign: TextAlign.center),
                        Text('Caloria',textAlign: TextAlign.center),
                        Text('Carboidrato',textAlign: TextAlign.center),
                        Text('Gordura',textAlign: TextAlign.center)
                      ]),
                      TableRow(children: [
                        Text(item.nutritionalTable.quantity.toString(),textAlign: TextAlign.center),
                        Text(item.nutritionalTable.calorie.toString(),textAlign: TextAlign.center),
                        Text(item.nutritionalTable.carbohydrate
                            .toString(),textAlign: TextAlign.center),
                        Text(item.nutritionalTable.fat.toString(),textAlign: TextAlign.center)
                      ]),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text( '* Todos os valores são baseados em 1g/ml do produto'),
                  const SizedBox(height: 8),
                  TextButton(
                    
                    child:const Text('* Todos os valores foram retirados do site Vitat'),
                    onPressed: (){
                      launchUrl(Uri.parse('https://vitat.com.br/alimentacao/busca-de-alimentos/'),mode: LaunchMode.externalApplication);
                    },
                      ),
                ],
              ),
            ));
    // return showAdaptiveDialog(
    //     barrierDismissible: true,
    //     context: context,
    //     builder: (context) => Center(
    //           child: Container(
    //             padding: const EdgeInsets.all(16),
    //             height: MediaQuery.sizeOf(context).height * 0.35,
    //             child: Material(
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Center(
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       const SizedBox(height: 8),
    //                       Text('Tabela Nutricional do - ${item.name}'),
    //                       Table(
    //                         border: TableBorder.all(),
                            
    //                         children: [
    //                           const TableRow(children: [
    //                             Text('Quantidade',textAlign: TextAlign.center),
    //                             Text('Caloria',textAlign: TextAlign.center),
    //                             Text('Carboidrato',textAlign: TextAlign.center),
    //                             Text('Gordura',textAlign: TextAlign.center)
    //                           ]),
    //                           TableRow(children: [
    //                             Text(item.nutritionalTable.quantity.toString(),textAlign: TextAlign.center),
    //                             Text(item.nutritionalTable.calorie.toString(),textAlign: TextAlign.center),
    //                             Text(item.nutritionalTable.carbohydrate
    //                                 .toString(),textAlign: TextAlign.center),
    //                             Text(item.nutritionalTable.fat.toString(),textAlign: TextAlign.center)
    //                           ]),
    //                         ],
    //                       ),
    //                       const SizedBox(height: 8),
    //                       Text(
    //                           '* Todos os valores são baseados em 1g/ml de ${item.name}'),
    //                       const SizedBox(height: 8),
    //                       TextButton(
                            
    //                         child:const Text('* Todos os valores foram retirados do site Vitat'),
    //                         onPressed: (){
    //                           launchUrl(Uri.parse('https://vitat.com.br/alimentacao/busca-de-alimentos/'),mode: LaunchMode.externalApplication);
    //                         },
    //                           ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeDataProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAdaptiveDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Adicinar Item'),
                    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    content: StatefulBuilder(
                      builder: (context,state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: Autocomplete<Item>(
                                initialValue: TextEditingValue.empty,
                                optionsBuilder: (textEditingValue) => marketOptions
                                    .where((obj) => obj.name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase())),
                                displayStringForOption: (option) => option.name,
                                onSelected: (option) => {state(() =>
                                  // selectOption(option);
                                  selectedItem = option
                                )},
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: TextFormField(
                                initialValue: selectedItem != null
                                    ? selectedItem!.quantity.toString()
                                    : '',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration:  InputDecoration(
                                  hintText: 'Quantidade',
                                  label:const Text('Quantidade'),
                                  suffix: Text(selectedItem != null ?selectedItem!.getSuffix():'gramas'),
                                ),
                                textInputAction: TextInputAction.done,
                                onChanged: (value) =>
                                    selectedItem!.quantity = double.parse(value),
                                onFieldSubmitted: (value) {
                                  _addItemToList(selectedItem!);
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.tonal(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.primaryContainer),
                                foregroundColor: WidgetStateProperty.all(
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                                shape:
                                    WidgetStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                              ),
                              onPressed: () {
                                _addItemToList(selectedItem!);
                              },
                              child: const Text('Adicionar'),
                            ),
                          ],
                        );
                      }
                    ),
                  ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                    onTap: () {
                      showNutritionalTable(items[index]);
                    },
                    tileColor: Theme.of(context).colorScheme.primaryContainer,
                    leading: IconButton(
                        onPressed: () {
                          selectedItem = Item.fromJson(items[index].toJson());
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
                                      initialValue: selectedItem!.name,
                                      enabled: false,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        hintText: 'Nome do item',
                                        label: Text('Item'),
                                      ),
                                      onChanged: (value) =>
                                          selectedItem!.name = value,
                                    ),
                                  ),
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 300),
                                    child: TextFormField(
                                      initialValue:
                                          selectedItem!.quantity.toString(),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration:  InputDecoration(
                                        hintText: 'Quantidade',
                                        label: const Text('Quantidade'),
                                        suffix: Text(selectedItem != null ?selectedItem!.getSuffix():'g'),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) => selectedItem!
                                          .quantity = double.parse(value),
                                      onFieldSubmitted: (value) {
                                        editItem(index, selectedItem!);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FilledButton.tonal(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .primaryContainer),
                                      foregroundColor: WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer),
                                      shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                    ),
                                    onPressed: () {
                                      editItem(index, selectedItem!);
                                    },
                                    child: const Text('Salvar'),
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(
                      '${items[index].captalize()} ${items[index].calculateQuantity()}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    trailing: IconButton(
                      padding: EdgeInsets.zero,
                      tooltip: 'Remover item',
                      onPressed: () {
                        removeListItem(index);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
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
  colorScheme: lightColorScheme,
  useMaterial3: true,
);
ThemeData darkTheme = ThemeData(
  colorScheme: darkColorScheme,
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
