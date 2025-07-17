import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Template3Page extends HookWidget {
  const Template3Page({super.key});

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------
    // 1. チェックボックスの状態管理
    // useMemoizedで初期リストを一度だけ生成
    final initialCheckboxStates =
        useMemoized(() => List<bool>.filled(20, false), []);

    // 各チェックボックスのON/OFF状態を保持するState
    // initialCheckboxStatesのコピーを渡すことで、参照が共有されないようにする
    final checkboxStates =
        useState<List<bool>>(List.from(initialCheckboxStates));

    // ----------------------------------------------------
    // 2. 1~10個目のトグル開閉状態管理
    final isFirstTenVisible = useState<bool>(true); // 初期値は表示状態

    // ----------------------------------------------------
    // 3. トグルが閉じられたときの副作用 (1~10個目のチェックボックスを強制OFF)
    useEffect(() {
      // isFirstTenVisible が false (トグルが閉じた) になった場合のみ実行
      if (!isFirstTenVisible.value) {
        final currentStates =
            List<bool>.from(checkboxStates.value); // 現在の状態をコピー
        bool changed = false; // 変更があったかどうかのフラグ
        for (int i = 0; i < 10; i++) {
          if (currentStates[i]) {
            currentStates[i] = false; // 強制的にOFFにする
            changed = true;
          }
        }
        if (changed) {
          checkboxStates.value = currentStates; // 変更があった場合のみ状態を更新してUIを再ビルド
        }
      }
      return null; // クリーンアップ関数は不要
    }, [isFirstTenVisible.value]); // isFirstTenVisible の値が変化したときに実行

    // ----------------------------------------------------
    // 4. 全てのチェックボックスをリセットする関数
    void resetAllCheckboxes() {
      checkboxStates.value = List.from(initialCheckboxStates); // 初期状態に戻す
    }

    // ----------------------------------------------------
    // UIの構築
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hooksでチェックボックスリスト'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetAllCheckboxes,
            tooltip: '全てのチェックをリセット',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // トグルボタン
            ListTile(
              title: const Text('1～10個目のチェックボックスを表示/非表示'),
              trailing: Switch(
                value: isFirstTenVisible.value,
                onChanged: (bool newValue) {
                  isFirstTenVisible.value = newValue; // トグルの状態を更新
                },
              ),
              onTap: () {
                isFirstTenVisible.value = !isFirstTenVisible.value; // タップでも切り替え
              },
            ),
            const Divider(),

            // 1～10個目のチェックボックスリスト (トグル制御)
            if (isFirstTenVisible.value) // isFirstTenVisibleがtrueの場合のみ表示
              ...List.generate(10, (index) {
                return CheckboxListTile(
                  title: Text('チェックボックス ${index + 1}'),
                  value: checkboxStates.value[index], // 現在の状態
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      final newStates = List<bool>.from(checkboxStates.value);
                      newStates[index] = newValue;
                      checkboxStates.value = newStates; // 状態を更新
                    }
                  },
                );
              }),

            // 11～20個目のチェックボックスリスト (常に表示)
            ...List.generate(10, (index) {
              final actualIndex = index + 10; // 実際のリストのインデックス
              return CheckboxListTile(
                title: Text('チェックボックス ${actualIndex + 1}'),
                value: checkboxStates.value[actualIndex], // 現在の状態
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    final newStates = List<bool>.from(checkboxStates.value);
                    newStates[actualIndex] = newValue;
                    checkboxStates.value = newStates; // 状態を更新
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
