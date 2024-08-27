import 'package:flutter/material.dart';

class Answer extends StatelessWidget
{
  const Answer({super.key});

  @override
  Widget build(BuildContext context) {
    final answer = ModalRoute.of(context)!.settings.arguments as (String,String,String,String,String,String);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(answer.$1+answer.$4+answer.$3+answer.$2,style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
              Text("合并"+answer.$5,style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
              Text(answer.$6,style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
              Text("\n\n\n\n\n\n\n\n\n\n\n\n\n\n如有问题请联系开发者：\nzhangshengxi0192@outlook.com")
            ],
          ),
        ),
      ),
    );
  }
}
