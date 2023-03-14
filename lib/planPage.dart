import 'package:flutter/material.dart';
// import  'main.dart';
import 'package:workout_app/data.dart';
import 'package:provider/provider.dart';

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
      body: Center(
        child: _buildPlanGrid(),
      ),
    );
  }

  final _scroll = ScrollController();

  Widget _buildPlanGrid() {
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
}
