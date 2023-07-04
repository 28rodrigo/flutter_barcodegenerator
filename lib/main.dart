import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Barcode Scanner'),
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
  List<String> result = <String>[];
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerta Enviado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Alerta foi enviado'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  if (res is String) {
                    result.add(res);
                  }
                });
              },
              child: const Text('Open Scanner'),
            ),
            Text(
              "Lista de Materiais",
              style: TextStyle(fontSize: 30),
            ),
            result.isEmpty
                ? Text("Empty List")
                : Container(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: result.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text("Material Name"),
                          subtitle: Text(result[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                result.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
            !result.isEmpty
                ? ElevatedButton(
                    onPressed: () {
                      _showMyDialog();
                      setState(() {
                        result.clear();
                      });
                    },
                    child: Text("Send Alert"))
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
