import 'package:flutter/material.dart';
import 'package:workout_app/data.dart';
import 'package:workout_app/navigation.dart';
// import 'package:provider/provider.dart';

class OpenPlan extends StatefulWidget {
  final List<PlanExData> planData;
  final String planTitle;

  const OpenPlan({super.key, required this.planData, required this.planTitle});

  @override
  State<OpenPlan> createState() => OpenPlanPage();
}

class OpenPlanPage extends State<OpenPlan> {
  // OpenPlanPage(PlanExData planData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: AppBar(
          leading: BackButton(color: Theme.of(context).colorScheme.onSecondary),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
            widget.planTitle,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          // shadowColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(child: showPlan()));
  }

  Widget showPlan() {
    return GridView.builder(
        itemCount: widget.planData.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200),
        itemBuilder: (context, index) {
          final plan = widget.planData[index];
          return Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    plan.title,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer),
                  ),
                  subtitle: Text(
                    plan.description,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer),
                  ),
                )
              ],
            ),
          );
        });
  }
}
