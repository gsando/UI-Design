import 'package:flutter/material.dart';

class PlanList extends StatefulWidget {
  const PlanList({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<PlanList> createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  //contains content for the second page
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(172, 239, 255, 195),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: Text(
          'Plans',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: const Center(
        child: Text(
          'Second page ;)',
          selectionColor: Color.fromARGB(0, 231, 140, 20),
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
