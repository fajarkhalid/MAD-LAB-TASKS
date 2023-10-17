import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class FormData {
  String name;
  String password;
  String gen;
  String date;
  FormData(
      {required this.name,
      required this.password,
      required this.gen,
      required this.date});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        "/home": (context) => const MyHomePage(),
        "/details": (context) => Details(),
      },
      //home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController u = TextEditingController();
  TextEditingController p = TextEditingController();
  TextEditingController g = TextEditingController();
  TextEditingController d = TextEditingController();
  String? gender;
  bool showError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Form'),
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: u,
                  decoration: const InputDecoration(labelText: 'username'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter some value';
                    }
                    return null;
                  }),
              TextFormField(
                controller: p,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'password'),
                validator: (value) {
                  if (value!.length < 8) {
                    return 'please enter 8 digit long password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: d,
                decoration: InputDecoration(
                  label: Text('Date of Birth'),
                  hintText: 'YYYY-MM-dd',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter DOB';
                  }
                  try {} catch (e) {
                    return 'invalid format';
                  }
                  return null;
                },
              ),
              const Text('select gender'),
              const SizedBox(height: 20),
              RadioListTile(
                  title: const Text("male"),
                  value: 'male',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                      g.text = value!;
                      showError = false;
                    });
                  }),
              RadioListTile(
                  title: const Text("female"),
                  value: 'female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                      g.text = value;
                      showError = false;
                    });
                  }),
              ElevatedButton(
                  onPressed: () {
                    FormData formd = FormData(
                        name: u.text,
                        password: p.text,
                        gen: g.text,
                        date: d.text);
                    if (gender == null) showError = true;

                    if (formkey.currentState!.validate() &&
                        showError == false) {
                      Navigator.of(context)
                          .pushNamed('/details', arguments: formd);
                    }
                  },
                  child: const Text('submit'))
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    final FormData formd =
        ModalRoute.of(context)!.settings.arguments as FormData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data from Form'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Name: ${formd.name}'),
            Text('Password: ${formd.password}'),
            Text('Gender: ${formd.gen}'),
            Text('DOB: ${formd.date}'),
          ],
        ),
      ),
    );
  }
}
