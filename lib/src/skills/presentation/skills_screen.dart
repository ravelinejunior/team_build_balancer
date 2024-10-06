import 'package:flutter/material.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Center(
        child: Text('Skills'),
      ),
    );
  }
}
