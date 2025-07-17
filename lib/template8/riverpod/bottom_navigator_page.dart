// 1. 型安全なenum定義
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BottomTab {
  home(icon: Icons.home, label: 'Home'),
  search(icon: Icons.search, label: 'Search'),
  profile(icon: Icons.person, label: 'Profile');

  const BottomTab({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

// 2. 適切なState管理
final bottomTabNotifierProvider =
    NotifierProvider<BottomTabNotifier, BottomTab>(
  () => BottomTabNotifier(),
);

class BottomTabNotifier extends Notifier<BottomTab> {
  @override
  BottomTab build() => BottomTab.home;

  void changeTab(BottomTab tab) {
    state = tab;
  }
}

// 3. Factory pattern for screen creation
class ScreenFactory {
  static Widget createScreen(BottomTab tab) {
    switch (tab) {
      case BottomTab.home:
        return const HomeScreen();
      case BottomTab.search:
        return const SearchScreen();
      case BottomTab.profile:
        return const ProfileScreen();
    }
  }
}

// 4. 修正されたWidget
class BottomNavApp extends ConsumerWidget {
  const BottomNavApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(bottomTabNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Navigation Bar'),
      ),
      body: IndexedStack(
        index: currentTab.index,
        children: BottomTab.values
            .map((tab) => ScreenFactory.createScreen(tab))
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab.index,
        onTap: (index) {
          if (index >= 0 && index < BottomTab.values.length) {
            ref
                .read(bottomTabNotifierProvider.notifier)
                .changeTab(BottomTab.values[index]);
          }
        },
        items: BottomTab.values
            .map((tab) => BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ))
            .toList(),
      ),
    );
  }
}

/// 各画面のウィジェット（本番環境ではそれぞれページごとに分離）
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('Home'));
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('Search'));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('Profile'));
}
