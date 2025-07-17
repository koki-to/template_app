import 'package:flutter/material.dart';
import 'package:template_app/template8/riverpod/bottom_navigator_page.dart';

class Template8HomePage extends StatelessWidget {
  const Template8HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('bottom navigation bar'),
      ),
      body: const Column(
        children: [
          _ListTileCard(
            pageName: 'riverpodのみ',
            pageWidget: BottomNavApp(),
          ),
        ],
      ),
    );
  }
}

class _ListTileCard extends StatelessWidget {
  const _ListTileCard({
    required String pageName,
    required Widget pageWidget,
  })  : _pageName = pageName,
        _pageWidget = pageWidget;

  final String _pageName;
  final Widget _pageWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 204, 230, 242),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return _pageWidget;
              },
            ),
          );
        },
        child: ListTile(
          title: Text(
            _pageName,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ),
      ),
    );
  }
}
