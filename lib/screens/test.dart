import 'package:flutter/material.dart';

import '../base/app_config.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: config.box.value.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    config.box.value.delete(config.box.value.keys.elementAt(index));
                    setState(() {});
                  },
                  child: Center(
                    child: Container(
                      color: Colors.blue.withOpacity(0.3),
                      height: 48,
                      child: Text(
                        config.box.value.getAt(index)!.food[0].values.toString(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('add'),
          ),
        ],
      ),
    );
  }
}
