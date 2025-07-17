import 'package:flutter/material.dart';
import 'package:template_app/template1/template1_page.dart';
import 'package:template_app/template10/lib/app.dart';
import 'package:template_app/template11/lib/features/todo/presentation/pages/todo_list_page.dart';
import 'package:template_app/template2/template2_page.dart';
import 'package:template_app/template3/template3_page.dart';
import 'package:template_app/template4/template4_page.dart';
import 'package:template_app/template5/template5_page.dart';
import 'package:template_app/template6/template6_page.dart';
import 'package:template_app/template7/template7_page.dart';
import 'package:template_app/template8/template8_home_page.dart';
import 'package:template_app/template9/template9_home_page.dart';

enum TemplateItem {
  template1('Hooks useState', Template1Page()),
  template2('Hooks TextController', Template2Page()),
  template3('Hooks toggle checkbox', Template3Page()),
  template4('Hooks Animation1', Template4Page()),
  template5('Hooks Animatio2n', Template5Page()),
  template6('Visibility オプション設定の表示/非表示トグル', Template6Page()),
  template7('Visibility アニメーション', Template7Page()),
  template8('bottom navigation bar', Template8HomePage()),
  template9('tabber', Template9HomePage()),
  template10('todoApp', TodoApp()),
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
