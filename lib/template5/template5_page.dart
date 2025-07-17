import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math' as math; // 回転のためにmathライブラリをインポート

class Template5Page extends HookWidget {
  const Template5Page({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. AnimationController を作成
    // duration: 2秒で一周するアニメーション
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    // 2. 拡大・縮小のアニメーション値を生成 (0.5 から 1.5 の間で変化)
    final scaleAnimation = useAnimation(
      Tween<double>(begin: 0.5, end: 1.5).animate(
        // CurvedAnimation: アニメーションの速度変化を滑らかにする
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut, // スムーズな加速・減速
        ),
      ),
    );

    // 3. 回転のアニメーション値を生成 (0度 から 360度へ変化)
    final rotationAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 2 * math.pi).animate(animationController),
    );

    // 4. useEffect でアニメーションの繰り返し制御
    // ウィジェットが表示されたらアニメーションを繰り返し、ウィジェットが破棄されたら停止
    useEffect(() {
      animationController.repeat(reverse: true); // 順方向と逆方向で繰り返し
      return () => animationController.stop(); // ウィジェット破棄時に停止
    }, [animationController]);

    return Scaffold(
      appBar: AppBar(title: const Text('拡大・回転アニメーション')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Transform.scale: ウィジェットのサイズを拡大・縮小
            // Transform.rotate: ウィジェットを回転
            Transform.scale(
              scale: scaleAnimation, // scaleAnimation の値で拡大・縮小
              child: Transform.rotate(
                angle: rotationAnimation, // rotationAnimation の値で回転
                child: const Icon(
                  Icons.star,
                  size: 100,
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // ボタンでアニメーションを一時停止/再開
                if (animationController.isAnimating) {
                  animationController.stop();
                } else {
                  animationController.repeat(reverse: true);
                }
              },
              child: Text(animationController.isAnimating ? '停止' : '再開'),
            ),
          ],
        ),
      ),
    );
  }
}
