import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/screens/workout/selectExerciseTile.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class SelectExerciseList extends StatefulWidget {
  final List<Exercise> exercises;
  List<Exercise> selectedExercises;
  SelectExerciseList(
      {required this.exercises, required this.selectedExercises});

  @override
  _SelectExerciseListState createState() => _SelectExerciseListState();
}

class _SelectExerciseListState extends State<SelectExerciseList> {
  TextEditingController controller = new TextEditingController();
  List<Exercise> _searchResult = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new Container(
          color: Constants.accentColor,
          child: new Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: new Card(
              child: new ListTile(
                leading: new Icon(Icons.search),
                title: new TextField(
                  controller: controller,
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(color: Constants.hintColor),
                      hintText: 'Search', border: InputBorder.none),
                  onChanged: onSearchTextChanged,
                ),
                trailing: new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: controller.text.length == 0
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.exercises.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: SelectExerciseTile(
                        exercise: widget.exercises[index],
                        onTap: onExerciseTileTap,
                        isSelected: widget.selectedExercises
                            .contains(widget.exercises[index]),
                      ),
                    );
                  })
              : ListView.builder(
                  itemCount: _searchResult.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: SelectExerciseTile(
                          exercise: _searchResult[index],
                          onTap: onExerciseTileTap,
                          isSelected: widget.selectedExercises
                              .contains(_searchResult[index])),
                    );
                  }),
        )
      ],
    );
  }

  void onExerciseTileTap(Exercise exercise) {
    if (!widget.selectedExercises.contains(exercise)) {
      setState(() => widget.selectedExercises.add(exercise));
    } else {
      setState(() =>
          widget.selectedExercises.removeWhere((val) => val.equals(exercise)));
    }
  }

  onSearchTextChanged(String query) async {
    _searchResult.clear();
    if (query.isEmpty) {
      setState(() {});
      return;
    }

    widget.exercises.forEach((exercise) {
      if (exercise.isSearchHit(query)) {
        _searchResult.add(exercise);
      }
    });

    setState(() => _searchResult.forEach((exercise) => exercise.log()));
  }
}
