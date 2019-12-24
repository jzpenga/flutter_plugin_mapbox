// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.mapbox.flutter_plugin_mapbox;

import android.content.Context;

import com.mapbox.mapboxsdk.camera.CameraPosition;
import com.mapbox.mapboxsdk.maps.MapboxMapOptions;
import com.mapbox.mapboxsdk.maps.Style;

import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.PluginRegistry;


class MapboxMapBuilder implements MapboxMapOptionsSink {
  public final String TAG = getClass().getSimpleName();
  private MapboxMapOptions options;
  private boolean myLocationEnabled = false;
  private int myLocationTrackingMode = 0;
  private String styleString = Style.MAPBOX_STREETS;
  private Context context;

  MapboxMapBuilder(Context context) {
    this.context = context;
    initOption(context);
  }

  MapboxMapController build(int id, FlutterPlugin.FlutterPluginBinding registrar, AtomicInteger activityState, PluginRegistry.Registrar pluginRegistry) {

    final MapboxMapController controller = new MapboxMapController(id,context,options,registrar, pluginRegistry);
    controller.init();
    controller.setMyLocationEnabled(myLocationEnabled);
    controller.setMyLocationTrackingMode(myLocationTrackingMode);
    //controller.setTrackCameraPosition(trackCameraPosition);
    return controller;
  }


  private void initOption(Context context){
    options =  MapboxMapOptions.createFromAttributes(context);
    options.attributionEnabled(false);
    options.textureMode(true);
  }

  void setInitialCameraPosition(CameraPosition position) {
//    if (position==null){
//      position = new CameraPosition.Builder()
//              .target(new LatLng(39.909732818604,116.30940246582))
//              .zoom(11)
//              .build();
//    }
    options.camera(position);
  }


  @Override
  public void setStyleString(String styleString) {
    this.styleString = styleString;
  }


  @Override
  public void setMyLocationEnabled(boolean myLocationEnabled) {
    this.myLocationEnabled = myLocationEnabled;
  }

  @Override
  public void setMyLocationTrackingMode(int myLocationTrackingMode) {
    this.myLocationTrackingMode = myLocationTrackingMode;
  }

}
