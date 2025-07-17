import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // これを忘れずに！

class Template1Page extends HookWidget {
  const Template1Page({super.key});
  // HookWidgetを継承
  @override
  Widget build(BuildContext context) {
    // useStateを使って、カウンターの数字（初期値は0）を保持する「箱」を作る
    final counter = useState(0);

    return Scaffold(
      appBar: AppBar(title: const Text('Hooksカウンター')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ボタンを押した回数:'),
            Text(
              '${counter.value}', // counter.value で現在の値を取得
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                counter.value = 0;
              },
              child: const Text('リセット'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++; // counter.value に新しい値を代入すると、画面が自動で更新される！
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
