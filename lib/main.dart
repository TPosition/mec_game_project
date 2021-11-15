import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.amber.shade900,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orange.shade300,
        ),
      ),
      home: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {}),
        actions: [
          IconButton(
            icon: Image.asset('assets/reward_icon.png'),
            iconSize: 50,
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/logo_text.png'),
            SizedBox(width: 200, child: Image.asset('assets/logo.png')),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 40,
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  primary: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {},
                child: const Text('Play'),
              ),
            ),
            const Text(
              "Total Chance: 2",
              style: TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "1 mark = 1",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                    height: 40, child: Image.asset('assets/coin_icon.png')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
