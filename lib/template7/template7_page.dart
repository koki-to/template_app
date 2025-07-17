import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Template7Page extends HookWidget {
  const Template7Page({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);

    void toggleCard() {
      if (animationController.isCompleted) {
        animationController.reverse();
      } else {
        animationController.forward();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('下からスライドインアニメーション')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: toggleCard,
              child: Text(
                animationController.isCompleted ? 'カードを隠す' : 'カードを表示',
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        width: 200,
                        height: 150,
                        alignment: Alignment.center,
                        child: const Text(
                          'スライドインカード!',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
