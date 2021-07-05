import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/screens/workout/selectExerciseTile.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/gradientMask.dart';
import 'package:flutter/material.dart';

class SelectExerciseList extends StatefulWidget {
  final List<Exercise> exercises;
  final List<Exercise> selectedExercises;
  SelectExerciseList(
      {required this.exercises, required this.selectedExercises});

  @override
  _SelectExerciseListState createState() => _SelectExerciseListState();
}

class _SelectExerciseListState extends State<SelectExerciseList> {
  TextEditingController controller = new TextEditingController();
  List<Exercise> _searchResult = [];
  Set<String> selectedChips = {};
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    onSearchTextChanged(String query) async {
      setState(() {
        _searchResult.clear();
        if (query.isEmpty && selectedChips.isEmpty) {
          setState(() {});
          return;
        }

        widget.exercises.forEach((exercise) {
          if (exercise.isSearchHit(query, selectedChips)) {
            _searchResult.add(exercise);
          }
        });
      });
    }

    Widget _filterChip(String filterValue) {
      return GestureDetector(
        onTap: () => setState(() {
          if (selectedChips.contains(filterValue)) {
            selectedChips.remove(filterValue);
          } else {
            selectedChips.add(filterValue);
          }
          onSearchTextChanged(_searchQuery);
        }),
        child: Container(
          padding: EdgeInsets.all(5),
          child: GradientMask(
            overrideColor:
                selectedChips.contains(filterValue) ? null : Colors.grey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Text(filterValue, style: TextStyle(color: Colors.black)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
            ),
          ),
        ),
      );
    }

    Widget _filterChips() {
      return Wrap(
        children: Constants.muscleGroups
            .map((muscleGroup) => _filterChip(muscleGroup))
            .toList(),
      );
    }

    return Column(
      children: [
        new Container(
          // decoration: BoxDecoration(
          //   border: Border(bottom: BorderSide(width: 1.0, color: Constants.textColor)),
          // ),
          child: new Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                GradientMask(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Ink(
                    color: Colors.transparent,
                    child: new ListTile(
                      title: new TextField(
                          // style: TextStyle(color: Constants.textColor),
                          controller: controller,
                          decoration: new InputDecoration(
                            prefixIcon: GradientMask(
                                child: Icon(Icons.search, color: Colors.white)),
                            suffixIcon: IconButton(
                              icon: new Icon(Icons.cancel,
                                  color: Constants.hintColor),
                              onPressed: () {
                                controller.clear();
                                onSearchTextChanged('');
                              },
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Constants.primaryColor, width: 1.0)),
                            filled: false,
                            hintStyle: TextStyle(color: Constants.hintColor),
                            hintText: 'Search',
                          ),
                          onChanged: (val) {
                            _searchQuery = val;
                            onSearchTextChanged(val);
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _filterChips(),
        Expanded(
          child: (controller.text.length == 0 && selectedChips.isEmpty)
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
}
