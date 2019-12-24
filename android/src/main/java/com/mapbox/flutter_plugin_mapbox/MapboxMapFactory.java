package com.mapbox.flutter_plugin_mapbox;

import android.content.Context;

import com.mapbox.mapboxsdk.camera.CameraPosition;

import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * Created by jiazhen on 2019-12-10.
 * Desc:
 */
public class MapboxMapFactory extends PlatformViewFactory {

    private final FlutterPlugin.FlutterPluginBinding mPluginRegistrar;
    private final AtomicInteger mActivityState;


    MapboxMapFactory(AtomicInteger state, FlutterPlugin.FlutterPluginBinding registrar) {
        super(StandardMessageCodec.INSTANCE);
        this.mPluginRegistrar = registrar;
        mActivityState = state;
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;

        MapboxMapBuilder mapboxMapBuilder = new MapboxMapBuilder(context);
        Convert.interpretMapboxMapOptions(params.get("options"),mapboxMapBuilder);
        if (params.containsKey("initialCameraPosition")) {
            CameraPosition position = Convert.toCameraPosition(params.get("initialCameraPosition"));
            mapboxMapBuilder.setInitialCameraPosition(position);
        }
        return mapboxMapBuilder.build(id, mPluginRegistrar,mActivityState);
    }
}
