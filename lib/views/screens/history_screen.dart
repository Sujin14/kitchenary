import 'package:flutter/material.dart';
import 'package:kitchenary/views/widgets/history/clear_history_button.dart';
import 'package:kitchenary/views/widgets/history/history_list.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently viewed'),
        actions: const [ClearHistoryButton()],
      ),
      body: const SafeArea(child: HistoryList()),
    );
  }
}
