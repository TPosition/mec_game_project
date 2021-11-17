import 'package:flutter/material.dart';
import 'package:mec_game_project/main.dart';

class RewardPage extends StatefulWidget {
  RewardPage({Key? key, required this.marks, required this.chance})
      : super(key: key);
  int marks;
  int chance;

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  void buyItem(int value) {
    setState(() {
      widget.marks = widget.marks - value;
    });
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const List<Item> listItem = [
      Item("5% off voucher", 20, Icon(Icons.local_offer)),
      Item("25% off voucher", 50, Icon(Icons.local_offer)),
      Item("50% off voucher", 90, Icon(Icons.local_offer)),
      Item("Free shipping", 30, Icon(Icons.local_shipping)),
      Item("Mystery Gift", 80, Icon(Icons.card_giftcard)),
    ];

    Future<bool> backPress() async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => App(
                    marks: widget.marks,
                    chance: widget.chance,
                  )));
      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reward"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 8,
      ),
      body: WillPopScope(
        onWillPop: () => backPress(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.marks.toString(),
                ),
                SizedBox(
                    height: 40, child: Image.asset('assets/coin_icon.png')),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    width: MediaQuery.of(context).size.width - 60,
                    child: ListView.builder(
                        key: UniqueKey(),
                        shrinkWrap: true,
                        itemCount: listItem.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                listItem[index].icon,
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(listItem[index].name),
                              ],
                            ),
                            trailing: ElevatedButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      child:
                                          Image.asset('assets/coin_icon.png')),
                                  Text(
                                    listItem[index].price.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  if (widget.marks >= listItem[index].price) {
                                    buyItem(listItem[index].price);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Your coins are not enough.'),
                                      duration: Duration(seconds: 10),
                                    ));
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                primary: Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        }));
              }),
            ),
            Text(
              "Or convert to RM ${(widget.marks * 0.05).toStringAsFixed(2)}",
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class Item {
  const Item(final this.name, final this.price, final this.icon);
  final String name;
  final int price;
  final Icon icon;
}
