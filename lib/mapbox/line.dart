// This file is generated.

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of flutter_mapbox_plugin;

class Line {
  Line(this._id, this._options);

  final String _id;

  String get id => _id;

  LineOptions _options;

  LineOptions get options => _options;
}


class LineOptions {

  const LineOptions({
    this.lineColor,
    this.lineWidth,
    this.geometry,
  });

  final String lineColor;
  final double lineWidth;
  final List<LatLng> geometry;

  static const LineOptions defaultOptions = LineOptions();

  LineOptions copyWith(LineOptions changes) {
    if (changes == null) {
      return this;
    }
    return LineOptions(
      lineColor: changes.lineColor ?? lineColor,
      lineWidth: changes.lineWidth ?? lineWidth,
      geometry: changes.geometry ?? geometry,
    );
  }

  dynamic _toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('lineColor', lineColor);
    addIfPresent('lineWidth', lineWidth);
    addIfPresent('geometry', geometry?.map((LatLng latLng) => latLng._toJson())?.toList());
    return json;
  }
}
