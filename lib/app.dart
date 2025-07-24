import 'package:flutter/material.dart';
import 'package:template_app/features/function/presentation/pages/post_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: PostPage(),
    );
  }
}
