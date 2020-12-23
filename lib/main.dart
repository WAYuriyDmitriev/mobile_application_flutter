import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:untitled2/database_helper.dart';
import 'package:untitled2/enviroment.dart';
import 'package:untitled2/ToDoNote.dart';
import 'package:untitled2/event_emitter.dart';
import 'package:untitled2/http_helper.dart';
import 'package:untitled2/list_view_element.dart';
import 'package:untitled2/list_view_items.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  HttpHelper.getToDoList(1).then((value) => null);
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
  double _currentZoom = 15;

  MyHomePage({Key key, this.title}) : super(key: key);

  int currentId = 0;
  final String title;

  List<LatLng> listPoints = [];

  Set<Polyline> _markers = new Set<Polyline>();

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

  /**
   *
   */

  LatLng _initialcameraposition = LatLng(53.2038, 50.1606);
  GoogleMapController _controller;
  Location _location = Location();

  /**
   *
   */

  bool isLocation = false;

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

    _location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentState != EStateApp.Maps) {
        return;
      }
      var polylineId2 = PolylineId('polyline_${widget.currentId}');
      widget._markers.clear();
      widget.listPoints
          .add(LatLng(currentLocation.latitude, currentLocation.longitude));
      widget._markers.add(Polyline(
          polylineId: polylineId2, points: widget.listPoints, width: 2));
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: widget._currentZoom)));
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

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(l.latitude, l.longitude),
              zoom: widget._currentZoom),
        ),
      );
    });
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
                        onPressed: () {
                          currentState = EStateApp.Maps;
                          setState(() {});
                        },
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
          listViewElement),
      EStateApp.Maps: new StateItem(
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
              title: Text('Карта'),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: IconButton(
                        icon: Icon(
                            isLocation ? Icons.location_on : Icons.location_off,
                            size: 26.0),
                        color: Colors.white,
                        onPressed: () {
                          isLocation = !isLocation;
                          widget.listPoints.clear();
                          widget._markers.clear();
                          setState(() {});
                        },
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: IconButton(
                        icon: const Icon(Icons.menu, size: 26.0),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ))
              ]),
          GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition, zoom: 10),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              zoomGesturesEnabled: true,
              compassEnabled: true,
              onCameraMove: (CameraPosition cameraPosition) {
                widget._currentZoom = cameraPosition.zoom;
              },
              polylines: isLocation ? widget._markers : null,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              myLocationEnabled: true))
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
