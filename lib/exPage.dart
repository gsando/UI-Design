import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_app/data.dart';
import 'package:drift/drift.dart' as drift;

class ExScreen extends StatefulWidget {
  const ExScreen({Key? key}) : super(key: key);

  @override
  State<ExScreen> createState() => ExPageContent();
}

class ExPageContent extends State<ExScreen> {
  //contains content for the exercises page (to enter)
  static const String route = '/';

  // late MyDatabase _db;

  final _db = MyDatabase();

  final _controllerName = TextEditingController();
  final _controllerDes = TextEditingController();
  final _controllerMin = TextEditingController();
  final _controllerSec = TextEditingController();
  final _controllerTitleUpdate = TextEditingController();
  final _controllerDesUpdate = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    // Future forBuilder = _db.getExercises();
    // _buildList();
    super.initState();
  }

  @override
  void dispose() {
    _db.close();
    _controllerName.dispose();
    _controllerDes.dispose();
    _controllerMin.dispose();
    _controllerSec.dispose();
    _controllerTitleUpdate.dispose();
    _controllerDesUpdate.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _db = MyDatabase();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.edit),
          //     onPressed: () {
          //       navigate(context, ProfileEdit.route);
          //     },
          //   )
          // ],
          title: Text(
            'Excercises',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _controllerName,
                      decoration: InputDecoration(
                          // fillColor: Colors.white,
                          border: const OutlineInputBorder(),
                          hintText: 'Enter the exercise name',
                          suffixIcon: IconButton(
                            onPressed: _controllerName.clear,
                            icon: const Icon(Icons.clear),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Enter the estimated time to complete:   ',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      // keyboardType: TextInputType.number,
                      controller: _controllerMin,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Minutes',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _controllerSec,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Seconds',
                      ),
                    ),
                  ),
                  // Text('sec'),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 300,
                      child: TextField(
                        controller: _controllerDes,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter the description of the exercise',
                            suffixIcon: IconButton(
                              onPressed: _controllerDes.clear,
                              icon: const Icon(Icons.clear),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        height: 50, //height of button
                        width: 100, //width of button
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () {
                            addExercise();
                            setState(() {});
                          },
                          child: const Text('Submit'),
                        )),
                  ],
                )),
            Expanded(
              flex: 5,
              child: _buildGrid(),
            ),
            SizedBox(
                height: kBottomNavigationBarHeight + 10,
                width: MediaQuery.of(context).size.width),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return FutureBuilder<List<ExerciseData>>(
        future: _db.getExercises(),
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
                    duration: const Duration(milliseconds: 100),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: ((context) => AlertDialog(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  title: Text(exercise.title.toString()),
                                  content:
                                      Text(exercise.description.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () => {
                                              // _db.deleteExercise(exercise.id),
                                              setState(() {
                                                _db.deleteExercise(exercise.id);
                                              }),
                                              Navigator.pop(context)
                                            },
                                        child: const Text("Delete")),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"))
                                  ],
                                )));
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: ListTile(
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
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        IconButton(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                            onPressed: () => {
                                                  setState(() {
                                                    _db.deleteExercise(
                                                        exercise.id);
                                                  }),
                                                },
                                            icon: const Icon(Icons.delete)),
                                        IconButton(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                            onPressed: () => {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          ((context) =>
                                                              AlertDialog(
                                                                backgroundColor: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiaryContainer,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(32.0))),
                                                                title:
                                                                    TextField(
                                                                  // style: TextStyle(
                                                                  // color: Theme.of(
                                                                  //         context)
                                                                  //     .colorScheme
                                                                  //     .onTertiaryContainer),
                                                                  controller: _controllerTitleUpdate
                                                                    ..text = exercise
                                                                        .title
                                                                        .toString(),
                                                                  decoration: InputDecoration(
                                                                      // border:
                                                                      //     const OutlineInputBorder(),
                                                                      suffixIcon: IconButton(
                                                                    onPressed:
                                                                        _controllerTitleUpdate
                                                                            .clear,
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .clear),
                                                                  )),
                                                                ),
                                                                content:
                                                                    TextField(
                                                                  controller: _controllerDesUpdate
                                                                    ..text = exercise
                                                                        .description
                                                                        .toString(),
                                                                  decoration: InputDecoration(
                                                                      // border: const OutlineInputBorder(),
                                                                      // labelText: exercise
                                                                      //     .description
                                                                      //     .toString(),
                                                                      suffixIcon: IconButton(
                                                                    onPressed:
                                                                        _controllerDesUpdate
                                                                            .clear,
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .clear),
                                                                  )),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      child: const Text(
                                                                          "Cancel")),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              {
                                                                                updateExercise(exercise.id),
                                                                                Navigator.pop(context),
                                                                                setState(() {})
                                                                              },
                                                                      child: const Text(
                                                                          "Update")),
                                                                ],
                                                              )))
                                                },
                                            icon: const Icon(Icons.edit))
                                      ])),
                            ]),
                      ),
                    ),
                  );
                });
          }
          return const Text('Santa is coming');
        });
    //   ],
    // );
  }

  void addExercise() {
    final entity = ExerciseCompanion(
        title: drift.Value(_controllerName.text),
        description: drift.Value(_controllerDes.text),
        minutes: drift.Value(int.tryParse(_controllerMin.text) == null
            ? 0
            : int.parse(_controllerMin.text)),
        seconds: drift.Value(int.tryParse(_controllerSec.text) == null
            ? 0
            : int.parse(_controllerSec.text)));
    _db.insertExercise(entity);

    _controllerName.clear();
    _controllerDes.clear();
    _controllerMin.clear();
    _controllerSec.clear();
  }

  void updateExercise(int id) {
    final entity = ExerciseCompanion(
      id: drift.Value(id),
      title: drift.Value(_controllerTitleUpdate.text),
      description: drift.Value(_controllerDesUpdate.text),
      // minutes: drift.Value(int.tryParse(_controllerMin.text) == null
      //     ? 0
      //     : int.parse(_controllerMin.text)),
      // seconds: drift.Value(int.tryParse(_controllerSec.text) == null
      //     ? 0
      //     : int.parse(_controllerSec.text)));
    );

    _db.updateEx(entity);
  }
}
