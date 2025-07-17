import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Template4Page extends HookWidget {
  const Template4Page({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. AnimationController を作成
    // useAnimationController: アニメーションの時間を制御するコントローラー
    // duration: アニメーションにかかる時間
    final animationController = useAnimationController(
      duration: const Duration(seconds: 1), // 1秒かけてアニメーション
    );

    // 2. Animation オブジェクトを作成
    // useAnimation: コントローラーの値を元に、実際に変化する値（この場合は透明度）を生成
    // Tween<double>(begin: 0.0, end: 1.0): 0.0（完全に透明）から1.0（完全に不透明）へ変化
    final opacityAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(animationController),
    );

    // 3. useEffect でアニメーションの挙動を制御（ライフサイクル管理）
    // [] を依存配列にすることで、この useEffect はウィジェットが初めて表示されたときに一度だけ実行されます。
    // return で返される関数は、ウィジェットが破棄されるときに自動で呼び出され、コントローラーを停止します。
    useEffect(() {
      animationController.forward(); // ウィジェットが表示されたらアニメーションを開始 (フェードイン)
      return () => animationController
          .dispose(); // アニメーションコントローラーを破棄 (Hooksが自動でやってくれるが、明示的に記述することも可能)
    }, [animationController]); // animationController が変更されたときに再実行（通常は一度だけ）

    return Scaffold(
      appBar: AppBar(title: const Text('フェードアニメーション')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Opacity ウィジェットを使って、opacityAnimation の値で透明度を制御
            Opacity(
              opacity: opacityAnimation,
              child: const Text(
                'こんにちは、Flutter Hooks！',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // ボタンを押すとアニメーションを逆再生（フェードアウト）し、完了したら順再生（フェードイン）
                if (animationController.status == AnimationStatus.completed ||
                    animationController.status == AnimationStatus.forward) {
                  animationController.reverse(); // 完了または順再生中なら逆再生
                } else {
                  animationController.forward(); // 逆再生中または開始前なら順再生
                }
              },
              child: const Text('アニメーション切り替え'),
            ),
          ],
        ),
      ),
    );
  }
}
