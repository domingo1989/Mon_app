import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DeviseApp());
}

class DeviseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convertisseur de devises',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ConvertisseurPage(),
    );
  }
}

class ConvertisseurPage extends StatefulWidget {
  @override
  _ConvertisseurPageState createState() => _ConvertisseurPageState();
}

class _ConvertisseurPageState extends State<ConvertisseurPage> {
  final TextEditingController _controller = TextEditingController();
  String _resultat = "";
  String _deviseSource = "USD";
  String _deviseCible = "XOF";
  final List<String> _devises = ["USD", "XOF", "EUR", "GBP", "JPY", "NGN"];

  Future<void> convertir() async {
    final montant = double.tryParse(_controller.text);
    if (montant == null) {
      setState(() => _resultat = "Montant invalide");
      return;
    }

    final url = Uri.parse(
        'https://api.exchangerate.host/convert?from=$_deviseSource&to=$_deviseCible&amount=$montant');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final taux = data["result"];
        setState(() => _resultat = "$montant $_deviseSource = ${taux.toStringAsFixed(2)} $_deviseCible");
      } else {
        setState(() => _resultat = "Erreur serveur");
      }
    } catch (e) {
      setState(() => _resultat = "Erreur réseau");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Convertisseur de devises")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Montant"),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _deviseSource,
                  items: _devises
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (val) => setState(() => _deviseSource = val!),
                ),
                Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: _deviseCible,
                  items: _devises
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (val) => setState(() => _deviseCible = val!),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: convertir,
              child: Text("Convertir"),
            ),
            SizedBox(height: 20),
            Text(_resultat, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
