// This file is generated.

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of flutter_mapbox_plugin;

class Symbol {

  Symbol(this._id, this._options);

  final String _id;

  String get id => _id;

  SymbolOptions _options;

  SymbolOptions get options => _options;
}

class SymbolOptions {

  const SymbolOptions( {
    this.id,
    this.geometry, this.title, this.desc, this.poiImage,
  });

  final int id;
  final LatLng geometry;
  final String title;
  final String desc;
  final String poiImage;


  static const SymbolOptions defaultOptions = SymbolOptions(

  );

  SymbolOptions copyWith(SymbolOptions changes) {
    if (changes == null) {
      return this;
    }
    return SymbolOptions(
      geometry: changes.geometry ?? geometry,
      title: changes.title ?? title,
      desc: changes.desc ?? desc,
      poiImage: changes.poiImage ?? poiImage,
      id: changes.id??id,
    );
  }

  dynamic _toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('geometry', geometry?._toJson());
    addIfPresent('title', title);
    addIfPresent('desc', desc);
    addIfPresent('poiImage', poiImage);
    addIfPresent('id', id);

    return json;
  }

}