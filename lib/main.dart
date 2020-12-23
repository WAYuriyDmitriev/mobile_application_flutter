import 'package:flutter/material.dart';
import 'package:untitled2/ToDoNote.dart';
import 'package:untitled2/event_emitter.dart';
import 'package:untitled2/list_view_element.dart';
import 'package:untitled2/list_view_items.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'ToDoApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum EStateApp { Maps, View, Add }

class StateItem {
  AppBar appBar;
  Object body;

  StateItem(this.appBar, this.body);
}

class _MyHomePageState extends State<MyHomePage> {
  EventEmitter eventEmitter = new EventEmitter();
  ListViewItems listViewItems;

  ToDoNote toDoNote = new ToDoNote('New Task', '', '', false);
  ListViewElement listViewElement;
  String _title = 'Hello';

  Map<EStateApp, StateItem> mapState;

  EStateApp currentState = EStateApp.View;

  _MyHomePageState() {
    listViewItems = ListViewItems(eventEmitter);
    eventEmitter.selectNodeUpdateObserver$.listen((event) {
      toDoNote = event;
      addOrEditNote();
    });

    eventEmitter.titleUpdateObserver$.listen((event) {
      _title = event;
      setState(() {});
    });
  }

  Object getCurrentItemBody() {
    return mapState != null && mapState[currentState] != null
        ? mapState[currentState].body
        : null;
  }

  AppBar getCurrentItemAppBar() {
    return mapState != null && mapState[currentState] != null
        ? mapState[currentState].appBar
        : null;
  }

  @override
  Widget build(BuildContext context) {
    listViewElement = new ListViewElement(toDoNote, eventEmitter);
    mapState = {
      EStateApp.View: new StateItem(
          AppBar(
              backgroundColor: HexColor("#6200ED"),
              title: Text('ToDoApp'),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: IconButton(
                        icon: const Icon(Icons.sync_outlined, size: 26.0),
                        onPressed: () {
                          listViewItems.update();
                        },
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: IconButton(
                        icon: const Icon(Icons.map),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    )),
              ]),
          listViewItems),
      EStateApp.Add: new StateItem(
          AppBar(
              backgroundColor: HexColor("#6200ED"),
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    currentState = EStateApp.View;
                    setState(() {});
                  },
                ),
              ),
              title: Text(_title),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: IconButton(
                        icon: const Icon(Icons.check, size: 26.0),
                        color: Colors.white,
                        onPressed: () {
                          currentState = EStateApp.View;
                          eventEmitter.saveOrUpdateEmit(toDoNote);
                          setState(() {});
                        },
                      ),
                    ))
              ]),
          listViewElement)
    };
    return Scaffold(
      appBar: getCurrentItemAppBar(),
      body: getCurrentItemBody(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return currentState == EStateApp.View
        ? FloatingActionButton(
            backgroundColor: HexColor('#6200ED'),
            onPressed: () {
              toDoNote = new ToDoNote('Наименование', '', '', false);
              addOrEditNote();
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        : null;
  }

  void addOrEditNote() {
    _title = toDoNote.title;
    listViewElement = new ListViewElement(toDoNote, eventEmitter);
    currentState = EStateApp.Add;
    setState(() {});
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
