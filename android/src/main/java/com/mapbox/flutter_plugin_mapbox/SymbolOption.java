package com.mapbox.flutter_plugin_mapbox;

import com.mapbox.mapboxsdk.geometry.LatLng;

/**
 * Created by jiazhen on 2019-12-12.
 * Desc:
 */
public class SymbolOption {

    private String id;
    private LatLng geometry;
    private String title;
    private String desc;
    private String poiImage;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public LatLng getGeometry() {
        return geometry;
    }

    public void setGeometry(LatLng geometry) {
        this.geometry = geometry;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getPoiImage() {
        return poiImage;
    }

    public void setPoiImage(String poiImage) {
        this.poiImage = poiImage;
    }
}
