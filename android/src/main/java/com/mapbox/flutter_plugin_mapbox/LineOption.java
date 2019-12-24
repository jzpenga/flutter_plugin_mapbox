package com.mapbox.flutter_plugin_mapbox;

import com.mapbox.mapboxsdk.geometry.LatLng;

import java.util.List;

/**
 * Created by jiazhen on 2019-12-12.
 * Desc:
 */
public class LineOption {

    private String lineColor;
    private double lineWidth;
    private List<LatLng> geometry;


    public List<LatLng> getGeometry() {
        return geometry;
    }

    public void setGeometry(List<LatLng> geometry) {
        this.geometry = geometry;
    }

    public String getLineColor() {
        return lineColor;
    }

    public void setLineColor(String lineColor) {
        this.lineColor = lineColor;
    }

    public double getLineWidth() {
        return lineWidth;
    }

    public void setLineWidth(double lineWidth) {
        this.lineWidth = lineWidth;
    }
}
