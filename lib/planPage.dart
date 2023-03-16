import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// import  'main.dart';
import 'package:workout_app/data.dart';
import 'package:workout_app/navigation.dart';
import 'package:provider/provider.dart';

bool submitFlag = false;

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
                SizedBox(
                  height: 50,
                  width: 300,
                  child: (submitFlag ? planNameField() : null),
                ),
                const SizedBox(
                  height: 20,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: FloatingActionButton.extended(
        onPressed: () => {},
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
                  final exercise = exercises[index];
                  return AnimatedContainer(
                    color: Colors.transparent,
                    duration: const Duration(milliseconds: 100),
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Theme.of(context).colorScheme.tertiaryContainer,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer),
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
                    return InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      onTap: () {},
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        child: Text(name.titlePlan.toString()),
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
}
