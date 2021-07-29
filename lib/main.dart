import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// todo: move done to bottom of the list

class MyApp extends StatefulWidget {
  @override
  _DataTableExample createState() => _DataTableExample();
}

void _getSelectedRowInfo(dynamic task) {
  print('task: $task');
}

class _DataTableExample extends State<MyApp> {
  static const int numItems = 10; //todo: change this make dynamic
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My To Do List', style: TextStyle(fontSize: 30)),
        ),
        // FAB button
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("add task"),
          onPressed: () {
            // PopupMenuButton(
            //   itemBuilder: (context) => [
            //     PopupMenuItem(
            //       child: Text("First"),
            //       value: 1,
            //     ),
            //   ],
            // );
          },
        ),

        // body starts here
        body: ListView(children: <Widget>[
          // datatable title
          Center(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Thursday, July 29',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ))),
          // row
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              alignment: Alignment.center,
              // margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text('Task',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],

                // define the interactive rows
                rows: List<DataRow>.generate(
                  numItems,
                  (int index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      // All rows will have the same selected color.
                      if (states.contains(MaterialState.selected)) {
                        return Colors.green.withOpacity(0.3);
                      }
                      return null;
                    }),
                    cells: <DataCell>[
                      DataCell(
                        Text('todo thingy $index'),
                        showEditIcon: true,
                        onTap: () {
                          //todo: on tap, edit the text
                          _getSelectedRowInfo('$index');
                        },
                      ),
                    ],
                    selected: selected[index],
                    onSelectChanged: (bool? value) {
                      setState(() {
                        selected[index] = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// define the rows
class RowItem {
  final String task;
  final String status;

  const RowItem({
    required this.task,
    required this.status,
  });

  RowItem copy({
    String? task,
    String? status,
  }) =>
      RowItem(task: task ?? this.task, status: status ?? this.status);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RowItem && task == other.task && status == other.status;
}

class Utils {
  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}

Widget buildDataTable() {
  final columns = ['Status', 'Task'];

  return DataTable(
    columns: getColumns(columns),
    rows: getRows(rowItems),
  );
}

List<DataColumn> getColumns(List<String> columns) {
  return columns.map((String column) {
    return DataColumn(
      label: Text(column,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }).toList();
}

List<DataRow> getRows(List<RowItem> rowItems) =>
    rowItems.map((RowItem rowItems) {
      final cells = [rowItems.task, rowItems.status];
      return DataRow(
        cells: Utils.modelBuilder(cells, (index, cell) {
          return DataCell(
            Text('$cell'),
            showEditIcon: true,
          );
        }),
      );
    }).toList();

// void navigateToTask(Task task, String title, todo_state obj) async {
//   bool result = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => new_task(task, title, obj)),
//   );
//   if (result == true) {
//     updateListView();
//   }
// }
