import 'package:flutter/material.dart';

enum MyTab {
  home(icon: Icons.home, label: 'Home', content: 'ホームコンテンツ'),
  search(icon: Icons.search, label: 'Search', content: '検索コンテンツ'),
  profile(icon: Icons.person, label: 'Profile', content: 'プロフィールコンテンツ');

  final IconData icon;
  final String label;
  final String content;

  const MyTab({
    required this.icon,
    required this.label,
    required this.content,
  });
}

class DefaultTabControllerPage extends StatelessWidget {
  const DefaultTabControllerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // length: タブの数と一致させる
    return DefaultTabController(
      length: MyTab.values.length, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DefaultTabControllerの例'),
          bottom: TabBar(
            // TabBar を AppBar の bottom に置くのが一般的
            tabs: MyTab.values
                .map((tab) => Tab(
                      icon: Icon(tab.icon),
                      text: tab.label,
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          // TabBarView を Scaffold の body に置く
          children: MyTab.values
              .map((tab) => Center(
                    child: Text(tab.content),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
