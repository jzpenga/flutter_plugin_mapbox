// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.mapbox.flutter_plugin_mapbox;

import android.graphics.Point;

import com.mapbox.mapboxsdk.camera.CameraPosition;
import com.mapbox.mapboxsdk.camera.CameraUpdate;
import com.mapbox.mapboxsdk.camera.CameraUpdateFactory;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.geometry.LatLngBounds;
import com.mapbox.mapboxsdk.maps.MapboxMap;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Conversions between JSON-like values and MapboxMaps data types.
 */
class Convert {

  private final static String TAG = "Convert";

//  private static BitmapDescriptor toBitmapDescriptor(Object o) {
//    final List<?> data = toList(o);
//    switch (toString(data.get(0))) {
//      case "defaultMarker":
//        if (data.size() == 1) {
//          return BitmapDescriptorFactory.defaultMarker();
//        } else {
//          return BitmapDescriptorFactory.defaultMarker(toFloat(data.get(1)));
//        }
//      case "fromAsset":
//        if (data.size() == 2) {
//          return BitmapDescriptorFactory.fromAsset(
//              FlutterMain.getLookupKeyForAsset(toString(data.get(1))));
//        } else {
//          return BitmapDescriptorFactory.fromAsset(
//              FlutterMain.getLookupKeyForAsset(toString(data.get(1)), toString(data.get(2))));
//        }
//      default:
//        throw new IllegalArgumentException("Cannot interpret " + o + " as BitmapDescriptor");
//    }
//  }

  private static boolean toBoolean(Object o) {
    return (Boolean) o;
  }

  static CameraPosition toCameraPosition(Object o) {
    final Map<?, ?> data = toMap(o);
    final CameraPosition.Builder builder = new CameraPosition.Builder();
    builder.bearing(toFloat(data.get("bearing")));
    builder.target(toLatLng(data.get("target")));
    builder.tilt(toFloat(data.get("tilt")));
    builder.zoom(toFloat(data.get("zoom")));
    return builder.build();
  }

  static boolean isScrollByCameraUpdate(Object o) {
    return toString(toList(o).get(0)).equals("scrollBy");
  }

  static CameraUpdate toCameraUpdate(Object o, MapboxMap mapboxMap, float density) {
    final List<?> data = toList(o);
    switch (toString(data.get(0))) {
      case "newCameraPosition":
        return CameraUpdateFactory.newCameraPosition(toCameraPosition(data.get(1)));
      case "newLatLng":
        return CameraUpdateFactory.newLatLng(toLatLng(data.get(1)));
      case "newLatLngBounds":
        return CameraUpdateFactory.newLatLngBounds(
          toLatLngBounds(data.get(1)), toPixels(data.get(2), density));
      case "newLatLngZoom":
        return CameraUpdateFactory.newLatLngZoom(toLatLng(data.get(1)), toFloat(data.get(2)));
      case "scrollBy":
        mapboxMap.scrollBy(
          toFractionalPixels(data.get(1), density),
          toFractionalPixels(data.get(2), density)
        );
        return null;
      case "zoomBy":
        if (data.size() == 2) {
          return CameraUpdateFactory.zoomBy(toFloat(data.get(1)));
        } else {
          return CameraUpdateFactory.zoomBy(toFloat(data.get(1)), toPoint(data.get(2), density));
        }
      case "zoomIn":
        return CameraUpdateFactory.zoomIn();
      case "zoomOut":
        return CameraUpdateFactory.zoomOut();
      case "zoomTo":
        return CameraUpdateFactory.zoomTo(toFloat(data.get(1)));
      case "bearingTo":
        return CameraUpdateFactory.bearingTo(toFloat(data.get(1)));
      case "tiltTo":
        return CameraUpdateFactory.tiltTo(toFloat(data.get(1)));
      default:
        throw new IllegalArgumentException("Cannot interpret " + o + " as CameraUpdate");
    }
  }

  private static double toDouble(Object o) {
    return ((Number) o).doubleValue();
  }

  private static float toFloat(Object o) {
    return ((Number) o).floatValue();
  }

  private static Float toFloatWrapper(Object o) {
    return (o == null) ? null : toFloat(o);
  }

  static int toInt(Object o) {
    return ((Number) o).intValue();
  }

  static Object toJson(CameraPosition position) {
    if (position == null) {
      return null;
    }
    final Map<String, Object> data = new HashMap<>();
    data.put("bearing", position.bearing);
    data.put("target", toJson(position.target));
    data.put("tilt", position.tilt);
    data.put("zoom", position.zoom);
    return data;
  }

  private static Object toJson(LatLng latLng) {
    return Arrays.asList(latLng.getLatitude(), latLng.getLongitude());
  }

  private static LatLng toLatLng(Object o) {
    final List<?> data = toList(o);
    return new LatLng(toDouble(data.get(0)), toDouble(data.get(1)));
  }

  private static LatLngBounds toLatLngBounds(Object o) {
    if (o == null) {
      return null;
    }
    final List<?> data = toList(o);
    LatLng[] boundsArray = new LatLng[] {toLatLng(data.get(0)), toLatLng(data.get(1))};
    List<LatLng> bounds = Arrays.asList(boundsArray);
    LatLngBounds.Builder builder = new LatLngBounds.Builder();
    builder.includes(bounds);
    return builder.build();
  }

  private static List<LatLng> toLatLngList(Object o) {
    if (o == null) {
      return null;
    }
    final List<?> data = toList(o);
    List<LatLng> latLngList = new ArrayList<>();
    for (int i=0; i<data.size(); i++) {
      final List<?> coords = toList(data.get(i));
      latLngList.add(new LatLng(toDouble(coords.get(0)), toDouble(coords.get(1))));
    }
    return latLngList;
  }

  static List<?> toList(Object o) {
    return (List<?>) o;
  }

  static long toLong(Object o) {
    return ((Number) o).longValue();
  }

  static Map<?, ?> toMap(Object o) {
    return (Map<?, ?>) o;
  }

  private static float toFractionalPixels(Object o, float density) {
    return toFloat(o) * density;
  }

  static int toPixels(Object o, float density) {
    return (int) toFractionalPixels(o, density);
  }

  private static Point toPoint(Object o, float density) {
    final List<?> data = toList(o);
    return new Point(toPixels(data.get(0), density), toPixels(data.get(1), density));
  }

  private static String toString(Object o) {
    return String.valueOf(o);
  }

  static void interpretMapboxMapOptions(Object o, MapboxMapOptionsSink sink) {
    final Map<?, ?> data = toMap(o);

    final Object styleString = data.get("styleString");
    if (styleString != null) {
      sink.setStyleString(toString(styleString));
    }

    final Object myLocationEnabled = data.get("myLocationEnabled");
    if (myLocationEnabled != null) {
      sink.setMyLocationEnabled(toBoolean(myLocationEnabled));
    }

    final Object myLocationTrackingMode = data.get("myLocationTrackingMode");
    if (myLocationTrackingMode != null) {
      sink.setMyLocationTrackingMode(toInt(myLocationTrackingMode));
    }
  }


  static void interpretSymbolOptions(Object o, SymbolOption options) {
    final Map<?, ?> data = toMap(o);

    final Object desc = data.get("desc");
    if (desc != null) {
      options.setDesc(toString(desc));
    }

    final Object title = data.get("title");
    if (title != null) {
      options.setTitle(toString(title));
    }

    final Object poiImage = data.get("poiImage");
    if (poiImage != null) {
      options.setPoiImage(toString(poiImage));
    }

    final Object geometry = data.get("geometry");
    if (geometry != null) {
      options.setGeometry(toLatLng(geometry));
    }

    final Object id = data.get("id");
    if (id != null) {
      options.setId(toString(id));
    }
  }

  static void interpretLineOptions(Object o, LineOption options) {

    final Map<?, ?> data = toMap(o);

    final Object lineColor = data.get("lineColor");
    if (lineColor != null) {
      options.setLineColor(toString(lineColor));
    }

    final Object lineWidth = data.get("lineWidth");
    if (lineWidth != null) {
      options.setLineWidth(toDouble(lineWidth));
    }

    final Object geometry = data.get("geometry");
    if (geometry != null) {
      options.setGeometry(toLatLngList(geometry));
    }

  }


}