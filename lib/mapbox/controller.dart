// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of flutter_mapbox_plugin;

typedef void OnMapClickCallback(Point<double> point, LatLng coordinates);

typedef void OnCameraTrackingDismissedCallback();
typedef void OnCameraTrackingChangedCallback(MyLocationTrackingMode mode);

///地图控制中心 可以与原生交互
class MapboxMapController extends ChangeNotifier {
  MapboxMapController._(
      this._id, MethodChannel channel, CameraPosition initialCameraPosition,
      {this.onMapClick})
      : assert(_id != null),
        assert(channel != null),
        _channel = channel {
    _cameraPosition = initialCameraPosition;
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<MapboxMapController> init(
      int id, CameraPosition initialCameraPosition,
      {OnMapClickCallback onMapClick,
      OnCameraTrackingDismissedCallback onCameraTrackingDismissed,
      OnCameraTrackingChangedCallback onCameraTrackingChanged}) async {
    assert(id != null);
    final MethodChannel channel =
        MethodChannel('plugins.flutter.io/mapbox_maps_$id');
    await channel.invokeMethod('map#waitForMap');
    return MapboxMapController._(id, channel, initialCameraPosition,
        onMapClick: onMapClick,);
  }

  final MethodChannel _channel;

  final OnMapClickCallback onMapClick;

  /// info window 点击回调
  final ArgumentCallbacks<Symbol> onInfoWindowTapped =
  ArgumentCallbacks<Symbol>();

  /// symbol点击回调
  final ArgumentCallbacks<Symbol> onSymbolTapped = ArgumentCallbacks<Symbol>();

  /// 当前地图的symbol集合
  Set<Symbol> get symbols => Set<Symbol>.from(_symbols.values);
  final Map<String, Symbol> _symbols = <String, Symbol>{};


 ///
  Set<Line> get lines => Set<Line>.from(_lines.values);
  final Map<String, Line> _lines = <String, Line>{};


  /// True if the map camera is currently moving.
  bool get isCameraMoving => _isCameraMoving;
  bool _isCameraMoving = false;

  /// Returns the most recent camera position reported by the platform side.
  /// Will be null, if [MapboxMap.trackCameraPosition] is false.
  CameraPosition get cameraPosition => _cameraPosition;
  CameraPosition _cameraPosition;

  final int _id;

  Future<dynamic> _handleMethodCall(MethodCall call) async {

    switch (call.method) {
      case 'infoWindow#onTap':
        final String symbolId = call.arguments['symbol'];
        final Symbol symbol = _symbols[symbolId];
        if (symbol != null) {
          onInfoWindowTapped(symbol);
        }
        break;
      case 'symbol#onTap':
        print(call.method);
        print(call.arguments);
        final String symbolId = call.arguments['symbol'];
        final Symbol symbol = _symbols[symbolId];
        if (symbol != null) {
          onSymbolTapped(symbol);
        }
        onSymbolTapped(symbol);
        break;
      case 'map#onMapClick':
        final double x = call.arguments['x'];
        final double y = call.arguments['y'];
        final double lng = call.arguments['lng'];
        final double lat = call.arguments['lat'];
        if (onMapClick != null) {
          onMapClick(Point<double>(x, y), LatLng(lat, lng));
        }
        break;

      default:
        throw MissingPluginException();
    }
  }



  /// Adds a symbol to the map, configured using the specified custom [options].
  ///
  /// Change listeners are notified once the symbol has been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added symbol once listeners have
  /// been notified.
  Future<Symbol> addSymbol(SymbolOptions options) async {
    final SymbolOptions effectiveOptions =
        SymbolOptions.defaultOptions.copyWith(options);
    final String symbolId = await _channel.invokeMethod(
      'symbol#add',
      <String, dynamic>{
        'options': effectiveOptions._toJson(),
      },
    );
    final Symbol symbol = Symbol('$symbolId', effectiveOptions);
    _symbols[symbolId] = symbol;
    notifyListeners();
    return symbol;
  }

//选中大头针
  Future<Symbol> selectSymbol(SymbolOptions options) async {
    final SymbolOptions effectiveOptions =
    SymbolOptions.defaultOptions.copyWith(options);
    final String symbolId = await _channel.invokeMethod(
      'symbol#select',
      <String, dynamic>{
        'options': effectiveOptions._toJson(),
      },
    );
    final Symbol symbol = Symbol(symbolId, effectiveOptions);
    _symbols[symbolId] = symbol;
    notifyListeners();
    return symbol;
  }


  Future<List<dynamic>> addSymbolList(List<SymbolOptions> optionsList) async {
    List<dynamic> optionListParam = [];
    for (var options in optionsList) {
      final SymbolOptions effectiveOptions =
      SymbolOptions.defaultOptions.copyWith(options);
      optionListParam.add(effectiveOptions._toJson());
    }

    final List<dynamic> symbolIds = await _channel.invokeMethod(
      'symbol#addList',
      <String, dynamic>{
        'optionsList': optionListParam,
      },
    );
    //final Symbol symbol = Symbol(symbolId, effectiveOptions);
    //_symbols[symbolId] = symbol;
    //notifyListeners();
    return symbolIds;
  }

  /// Adds a line to the map, configured using the specified custom [options].
  ///
  /// Change listeners are notified once the line has been added on the
  /// platform side.
  ///
  /// The returned [Future] completes with the added line once listeners have
  /// been notified.
  Future<Line> addLine(LineOptions options) async {
    final LineOptions effectiveOptions =
        LineOptions.defaultOptions.copyWith(options);
    final String lineId = await _channel.invokeMethod(
      'line#add',
      <String, dynamic>{
        'options': effectiveOptions._toJson(),
      },
    );
    final Line line = Line(lineId, effectiveOptions);
    _lines[lineId] = line;
    notifyListeners();
    return line;
  }


}
