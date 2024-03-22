import 'package:flutter/material.dart';

import 'api.dart';
import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Country> countries = [];
  Country? selectedCountry;
  Future<List<Country>> future = getAllCountries();

  List<DropdownMenuItem<Country>> buildDropDownItem(List<Country> countries) {
    return countries.map((country) => DropdownMenuItem<Country>(
        value: country,
        child: Text(country.name),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder(
              future: getAllCountries(),
              builder: (context,AsyncSnapshot<List<Country>> snapshot){
                final countries = snapshot.data;
                if(snapshot.connectionState==ConnectionState.done){
                  if(snapshot.hasData) {
                    return DropdownButtonFormField(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Pick Country",
                        border: OutlineInputBorder()
                      ),
                      items: buildDropDownItem(countries!),
                      onChanged: (Country? country){
                        setState(() {
                          selectedCountry = country;
                        });
                      }
                    );
                  }else{
                    return const Center(child: Text('No Data Found!'));
                  }
                }
                return const Center(child: CircularProgressIndicator());
              }
            ),
            if(selectedCountry!=null)
              FutureBuilder<Country>(
                future: getCountry(selectedCountry!.code),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.hasError){
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  Country? country = snapshot.data;
                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      SelectableText('Country : ${country?.name}',
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(country!.emoji!,
                          style: const TextStyle(fontSize: 75),
                          textAlign: TextAlign.center
                        ),
                      ),
                      SelectableText('Capital : ${country.capital}',
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center
                      ),
                      SelectableText('Code : ${country.code}',
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center
                      ),
                      SelectableText('Native : ${country.native}',
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      SelectableText('Currency : ${country.currency}',
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center
                      ),
                      SelectableText('Phone : ${country.phone}',
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center
                      ),
                    ],
                  );
                }
              )
          ],
        ),
      ),
    );
  }
}
