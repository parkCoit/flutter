import 'package:flutter/material.dart';
import 'package:hello_flutter/ch21_counter/providers/count.dart';
import 'package:hello_flutter/ch21_counter/components/count.dart';
import 'package:provider/provider.dart';

class Counter extends StatelessWidget {
  late CountProvider countProvider;


  Counter({super.key});

  @override
  Widget build(BuildContext context) {
    countProvider = Provider.of<CountProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("카운터", style: TextStyle(color: Colors.black, fontSize: 50.0),),
      ),
      body: const Count(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(onPressed: () => countProvider.increase(), icon: const Icon(Icons.add, size: 50,)),
          IconButton(onPressed: () => countProvider.decrease(), icon: const Icon(Icons.remove, size: 50)),
        ],
      ),
    );
  }
}