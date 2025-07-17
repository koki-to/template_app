import 'package:flutter/material.dart';

class Template6Page extends StatefulWidget {
  const Template6Page({super.key});

  @override
  State<Template6Page> createState() => _Template6PageState();
}

class _Template6PageState extends State<Template6Page> {
  bool _showAdvancedSettings = false;
  final TextEditingController _setting1Controller = TextEditingController();
  final TextEditingController _setting2Controller = TextEditingController();

  @override
  void dispose() {
    _setting1Controller.dispose();
    _setting2Controller.dispose();
    super.dispose();
  }

  void _toggleAdvancedSettings() {
    setState(() {
      _showAdvancedSettings = !_showAdvancedSettings;
    });
  }

  Future<void> _saveSettings() async {
    // 実際の保存処理をここに実装
    // 例: SharedPreferences、データベース、API呼び出しなど

    // 保存処理のシミュレーション
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('設定を保存しました'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定トグル例')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('詳細設定を表示'),
              value: _showAdvancedSettings,
              onChanged: (bool value) => _toggleAdvancedSettings(),
              secondary: const Icon(Icons.settings),
            ),
            const Divider(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showAdvancedSettings
                  ? _buildAdvancedSettings()
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('保存'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '詳細設定',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _setting1Controller,
              decoration: const InputDecoration(
                labelText: '設定値1',
                border: OutlineInputBorder(),
                helperText: '設定値1の説明をここに記載',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _setting2Controller,
              decoration: const InputDecoration(
                labelText: '設定値2',
                border: OutlineInputBorder(),
                helperText: '設定値2の説明をここに記載',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
