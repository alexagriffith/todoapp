import 'dart:html';

import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// todo: move done to bottom of the list
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _ToDoList createState() => _ToDoList();
}

void _getSelectedRowInfo(dynamic task) {
  print('$task');
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

// the real deal
class _ToDoList extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My To Do List',
      home: ToDoPage(),
    );
  }
}

class ToDoPage extends StatefulWidget {
  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late List<RowItem> rowItems;
  final allRowItems = <RowItem>[
    RowItem(task: 'get life together', status: 'IP'),
  ];

  @override
  void initState() {
    super.initState();

    this.rowItems = List.of(allRowItems);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
              child: buildDataTable(),
            ),
          ),
        ]),
      );

  Widget buildDataTable() {
    final columns = ['Task', 'Status'];

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
      rowItems.map((RowItem rowItem) {
        final cells = [rowItem.task, rowItem.status];
        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            final showEditIcon = index == 1;
            return DataCell(
              Text('$cell'),
              showEditIcon: showEditIcon,
              onTap: () {
                //todo: on tap, edit the text
                _getSelectedRowInfo('$cell');
                switch (index) {
                  case 1:
                    editStatus(rowItem);
                    break;
                }
              },
            );
          }),
          //TODO: check box
          // selected: rowItems[cell],
          // onSelectChanged: (bool? value) {
          //   setState(() {
          //     selected[cell] = value!;
          //   });
        );
      }).toList();

  Future editStatus(RowItem editRowItem) async {
    final status = await showTextDialog(
      context,
      title: "Test",
      value: editRowItem.status,
    );

    // DropdownButton(
    //     value: _selectedItem,
    //     items: _items.map((item) {
    //       return DropdownMenuIteam(
    //         value: item,
    //         child: Text(item),
    //       );
    //     }).toList(),
    //     onChanged: (value) {
    //       setState(() {
    //         _selectedItem = 'hi';
    //       });
    //     });

    setState(() => rowItems = rowItems.map((rowItem) {
          final isEditedRowItem = rowItem == editRowItem;

          return isEditedRowItem ? rowItem.copy(status: status) : rowItem;
        }).toList());
  }
}

Future<T?> showDropDown<T>(
  BuildContext context, {
  required String value,
}) =>
    showDialog<T>(
      context: context,
      builder: (context) => DropDownWidget(
        value: value,
      ),
    );

class DropDownWidget extends StatefulWidget {
  final String value;

  const DropDownWidget({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  late TextEditingController controller;
  String _selectedItem = 'todo';

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) => Container(
        child: DropdownButton<String>(
          items: <String>['todo', 'IP', 'done'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (_) {
            // setState(() {
            // _selectedItem = value;
            // });
          },
        ),
      );
}

Future<T?> showTextDialog<T>(
  BuildContext context, {
  required String title,
  required String value,
}) =>
    showDialog<T>(
      context: context,
      builder: (context) => TextDialogWidget(
        title: title,
        value: value,
      ),
    );

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;

  const TextDialogWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.value);
  }

  String dropdownValue = 'todo';

  @override
  Widget build(BuildContext context) => AlertDialog(
          //   content: TextField(
          // controller: controller,
          // decoration: InputDecoration(
          //   border: OutlineInputBorder(),
          // ),
          content: Container(
              child: DropdownButton<String>(
        value: dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: <String>['todo', 'IP', 'done']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      )));

  // title: Text(widget.title),
  // content: TextField(
  //   controller: controller,
  //   decoration: InputDecoration(
  //     border: OutlineInputBorder(),
  //   ),
  // ),
  // actions: [
  //   ElevatedButton(
  //     child: Text('Done'),
  //     onPressed: () => Navigator.of(context).pop(controller.text),
  //   )
  // ],

  // Container(
  //       child: DropdownButton<String>(
  //         items: <String>['todo', 'IP', 'done'].map((String value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: new Text(value),
  //           );
  //         }).toList(),
  //         onChanged: (_) {
  //           // setState(() {
  //           // _selectedItem = value;
  //           // });
  //         },
  //       ),
  //     );
}
