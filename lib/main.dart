import 'package:flutter/material.dart';
import 'package:mec_game_project/hit_a_mole.dart';
import 'package:mec_game_project/reward_page.dart';

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
      home: const App(
        chance: 3,
        marks: 0,
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key, required this.chance, required this.marks})
      : super(key: key);

  final int chance;
  final int marks;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RewardPage(
                          chance: widget.chance,
                          marks: widget.marks,
                        )),
              );
            },
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
                onPressed: widget.chance == 0
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameArea(
                                    marks: widget.marks,
                                    chance: widget.chance,
                                  )),
                        );
                      },
                child: const Text('Play'),
              ),
            ),
            Text(
              "Total Chance: ${widget.chance.toString()}",
              style: const TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 38),
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
