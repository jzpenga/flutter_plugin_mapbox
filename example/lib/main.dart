import 'dart:core';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_plugin_mapbox/mapbox_gl.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MapboxMapController _mapboxMapController;

  void onCreateMap(MapboxMapController controller){
    _mapboxMapController = controller;
    _mapboxMapController.onSymbolTapped.add(_onSymbolTaped);


  }


  void _onSymbolTaped(Symbol symbol){

    print('大头针点击');
  }


  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('mapbox app'),
        ),
        body: Stack(
          children: <Widget>[
            MapboxMap(
              initialCameraPosition: CameraPosition(
                zoom: 11,
                target: LatLng(39.911337,116.410625),
              ),
              myLocationEnabled: true,
              onMapCreated: onCreateMap,
            ),
            Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    _mapboxMapController.addSymbol(SymbolOptions(
                        title: 'a',
                        desc: 'as',
                        poiImage: 'sdf',
                        id: 2,
                        geometry: LatLng(39.899782,116.393386)
                    ));
                  },
                  child: Text('add symbol'),
                ),
                RaisedButton(
                  onPressed: () {
                    _mapboxMapController.addSymbolList([
                      SymbolOptions(
                          title: '故宫',
                          desc: '距离你2.4km',
                          poiImage: 'http://pic.lvmama.com/uploads/pc/place2/2015-05-19/2af04d1a-3f78-4c4b-925a-1ec21029a15a.jpg',
                          id: 1,
                          geometry: LatLng(39.899782,116.393386)
                      ),
                      SymbolOptions(
                          title: '圆明园',
                          desc: '距离你21.5km',
                          poiImage: 'http://staticfile.tujia.com/upload/info/day_130816/20130816071929867_s.jpg',
                          id: 2,
                          geometry: LatLng(39.903755,116.397724)
                      ),
                      SymbolOptions(
                          title: '鸟巢',
                          desc: '距离你11.5km',
                          poiImage: 'http://i2.dukuai.com/x.attachments/2009/08/07/14864919_200908072139431.jpg',
                          id: 3,
                          geometry: LatLng(39.939299,116.395628)
                      ),
                    ]);
                  },
                  child: Text('add symbol list'),
                ),
                RaisedButton(
                  onPressed: () {
                    _mapboxMapController.addLine(
                        LineOptions(
                        geometry: [
                          LatLng(39.899782,116.393386),
                          LatLng(39.903755,116.397724),
                          LatLng(39.939299,116.395628),
                        ],
                          lineColor: '#000000',
                          lineWidth: 10
                    ),
                    );
                  },
                  child: Text('add line'),
                ),
                RaisedButton(
                  onPressed: () {
                    _mapboxMapController.selectSymbol(
                      SymbolOptions(
                        title: 'a',
                        desc: 'as',
                        poiImage: 'sdf',
                        id: 1,
                        geometry: LatLng(39.899782,116.393386)
                    ),
                    );
                  },
                  child: Text('select symbol'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
