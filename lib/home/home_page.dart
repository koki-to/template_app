import 'package:flutter/material.dart';
import 'package:template_app/template11/lib/features/todo/presentation/pages/todo_list_page.dart';

enum TemplateItem {
  template11('todoApp', TodoListPage());

  const TemplateItem(this.pageName, this.pageWidget);
  final String pageName;
  final Widget pageWidget;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('template_app'),
      ),
      body: ListView.builder(
        itemCount: TemplateItem.values.length,
        itemBuilder: (BuildContext context, int index) {
          return _ListTileCard(
            templateItem: TemplateItem.values[index],
          );
        },
      ),
    );
  }
}

class _ListTileCard extends StatelessWidget {
  const _ListTileCard({required this.templateItem});

  final TemplateItem templateItem;

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
                return templateItem.pageWidget;
              },
            ),
          );
        },
        child: ListTile(
          title: Text(
            templateItem.pageName,
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
