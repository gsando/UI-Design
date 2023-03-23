// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// import  'main.dart';
import 'package:workout_app/data.dart';
import 'package:workout_app/navigation.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

bool submitFlag = false;
bool holder = false;

class PlanList extends StatefulWidget {
  const PlanList({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<PlanList> createState() => PlanListState();
}

class PlanListState extends State<PlanList> {
  //contains content for the second page
  final _scrollController = ScrollController();
  final _scroll = ScrollController();
  final _controllerPlanName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controllerPlanName.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          (submitFlag ? FloatingActionButtonLocation.centerFloat : null),
      floatingActionButton: (submitFlag ? floatingButton() : null),
      // backgroundColor: const Color.fromARGB(172, 239, 255, 195),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: Text(
          'Plans',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 80,
                    width: 500, //width of button
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  textStyle: const TextStyle(fontSize: 20)),
                              onPressed: () {
                                // if (submitFlag) {
                                //   submitFlag = false;
                                // } else {
                                submitFlag = false;
                                // }
                                // setState(() {});
                                Phoenix.rebirth(context);
                              },
                              child: Text(
                                'View Existing Plans',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  textStyle: const TextStyle(fontSize: 20)),
                              onPressed: () {
                                // if (submitFlag) {
                                //   submitFlag = false;
                                // } else {
                                submitFlag = true;
                                // }
                                // setState(() {});
                                Phoenix.rebirth(context);
                              },
                              child: Text(
                                'Start New Plan',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  color: (Theme.of(context).colorScheme.brightness ==
                          Brightness.dark
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : null),
                ),
                SizedBox(
                  height: 50,
                  width: (submitFlag ? 300 : null),
                  child: (submitFlag
                      ? planNameField()
                      : Row(
                          children: [
                            Text(
                              "\t\tExisting plans",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                          ],
                        )),
                ),
                SizedBox(
                  height: 30,
                  child: (submitFlag
                      ? null
                      : Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                "\t\t\t\tClick on a plan to view plan details. ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer),
                              ),
                            ),
                          ],
                        )),
                ),
              ],
            ),
            // ),
            // ),
            Expanded(
                flex: 2,
                child: (submitFlag ? buildPlanGrid() : getExistingPlans())),
          ],
        ),
      ),
    );
  }

  Widget floatingButton() {
    // print("Here is the numOfPlans $numOfPlans");
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: FloatingActionButton.extended(
        onPressed: () async {
          if (_controllerPlanName.text.isEmpty) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      title: Text("Woah!",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer)),
                      content: const Text(
                          "The plan has no title. Please add a title to submit/ save the plan."),
                    ));
          } else if (_controllerPlanName.text.length < 3) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      title: Text("Woah!",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer)),
                      content: const Text(
                          "The plan must have at least 3 characters. Please change the title to submit/ save the plan."),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => {Navigator.pop(context)},
                            child: const Text("Okay"))
                      ],
                    ));
          } else {
            Provider.of<MyDatabase>(context, listen: false).insertPlanName(
                PlanNameCompanion(
                    titlePlan: drift.Value(_controllerPlanName.text)));

            PlanNameData lastPlan =
                await Provider.of<MyDatabase>(context, listen: false)
                    .getLastPlanID();

            int numOfPlans = lastPlan.planID;

            List<ExerciseData> exercises =
                await Provider.of<MyDatabase>(context, listen: false)
                    .getExercises();

            if (exercises.isNotEmpty) {
              for (int i = 0; i < exercises.length; i++) {
                holder = exercises[i].selected ?? false;
                // randHold = exercises[i].id;
                if (holder) {
                  // print(
                  //     "here, holder is true, value of i is $i and id is $randHold");
                  addPlanEx(exercises[i], numOfPlans);
                  Provider.of<MyDatabase>(context, listen: false)
                      .makeExFalse(exercises[i].id);
                }
              }
            }
            _controllerPlanName.clear();
            Phoenix.rebirth(context);
          }
        },
        label: Text(
          "Submit plan",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 15),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget planNameField() {
    return TextField(
      controller: _controllerPlanName,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          hintText: 'Enter the name of the plan',
          suffixIcon: IconButton(
            onPressed: _controllerPlanName.clear,
            icon: const Icon(Icons.clear),
          )),
    );
  }

  Widget buildPlanGrid() {
    //FOR NEW PLAN***************************
    return FutureBuilder<List<ExerciseData>>(
        future: Provider.of<MyDatabase>(context, listen: false).getExercises(),
        builder: (context, snapshot) {
          final List<ExerciseData>? exercises = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (exercises != null) {
            // print("here in the gridbuilder");
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                controller: _scroll,
                // reverse: true,
                // shrinkWrap: true,
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  // holder = false;
                  final exercise = exercises[index];
                  holder = exercise.selected ?? false;
                  return AnimatedContainer(
                    color: Colors.transparent,
                    duration: const Duration(milliseconds: 100),
                    child: InkWell(
                      onTap: () {
                        // print("here");
                        if (exercise.selected != null &&
                            exercise.selected == true) {
                          Provider.of<MyDatabase>(context, listen: false)
                              .makeExFalse(exercise.id);
                          holder = false;
                          // print("here");
                        } else if (exercise.selected != null) {
                          Provider.of<MyDatabase>(context, listen: false)
                              .makeExTrue(exercise.id);
                          holder = true;
                          // print("here");
                        }
                        Phoenix.rebirth(context);
                      },
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: (holder //no problem here
                            ? Theme.of(context).colorScheme.tertiaryContainer
                            : Theme.of(context).colorScheme.tertiary),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                // leading: Icon(Icons.album),
                                title: Center(
                                    child: Text(
                                  exercise.title.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: (holder
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onTertiaryContainer
                                          : Theme.of(context)
                                              .colorScheme
                                              .onTertiary)),
                                )),
                                // trailing: const Icon(Icons.more_horiz),
                                // subtitle: Text(exercise.description.toString()),
                              )
                            ]),
                      ),
                    ),
                  );
                });
          }
          return const Text('Santa is coming');
        });
  }

  void addPlanEx(ExerciseData exercise, int idofPlan) {
    final entity = PlanExCompanion(
      planID: drift.Value(idofPlan),
      title: drift.Value(exercise.title),
      description: drift.Value(exercise.description),
    );
    Provider.of<MyDatabase>(context, listen: false).insertPlanEx(entity);
  }

  Widget getExistingPlans() {
    return Center(
      child: FutureBuilder<List<PlanNameData>>(
          future:
              Provider.of<MyDatabase>(context, listen: false).getAllPlanNames(),
          builder: (context, snapshot) {
            final List<PlanNameData>? names = snapshot.data;

            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (names != null && names.isNotEmpty) {
              // print("here, names is not null");
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200),
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    final name = names[index];
                    final String nameString = name.titlePlan;
                    return InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      onTap: () async {
                        List<PlanExData> plan = await Provider.of<MyDatabase>(
                                context,
                                listen: false)
                            .getPlanEx(name.planID);

                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(
                                    name.titlePlan,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  content: Container(
                                    width: 400,
                                    height: 300,
                                    child: planOnDialog(plan, name.titlePlan),
                                  ),
                                ));
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Theme.of(context).colorScheme.tertiary,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                // leading: Icon(Icons.album),
                                title: Center(
                                    child: Text(
                                  name.titlePlan.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                )),
                                // subtitle: Text(name.planID.toString()),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .tertiaryContainer,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0))),
                                                title: Text("Woah!",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onTertiaryContainer)),
                                                content: Text(
                                                    "Are you sure you want to delete \"$nameString\"?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () => {
                                                            setState(() {
                                                              Provider.of<MyDatabase>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .deletePlan(name
                                                                      .planID);
                                                            }),
                                                            Phoenix.rebirth(
                                                                context),
                                                          },
                                                      child:
                                                          const Text("Delete")),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text("Cancel"))
                                                ],
                                              ));
                                      // Phoenix.rebirth(context);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                    )),
                                // subtitle: Text(exercise.description.toString()),
                              )
                            ]),
                      ),
                    );
                  });
            }

            return const Text(
              "No existing plans.",
              style: TextStyle(fontSize: 20),
            );
          }),
    );
  }

  Widget planOnDialog(List<PlanExData> planData, String planTitle) {
    return GridView.builder(
        itemCount: planData.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150),
        itemBuilder: (context, index) {
          final plan = planData[index];
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
