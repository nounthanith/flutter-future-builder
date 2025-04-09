import 'package:flutter/material.dart';
import 'package:jsonapp_test/http_view.dart';

void main () {
  runApp(HomeView());
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: HttpView(),
    );
  }
}

