package com.mapbox.flutter_plugin_mapbox;

/**
 * Receiver of MapboxMap configuration options.
 */
interface MapboxMapOptionsSink {

  void setStyleString(String styleString);

  void setMyLocationEnabled(boolean myLocationEnabled);

  void setMyLocationTrackingMode(int myLocationTrackingMode);
}