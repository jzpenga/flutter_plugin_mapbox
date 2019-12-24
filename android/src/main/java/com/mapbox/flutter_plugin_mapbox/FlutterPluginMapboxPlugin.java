package com.mapbox.flutter_plugin_mapbox;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterPluginMapboxPlugin */
public class FlutterPluginMapboxPlugin implements Application.ActivityLifecycleCallbacks, FlutterPlugin {
  static final int CREATED = 1;
  static final int STARTED = 2;
  static final int RESUMED = 3;
  static final int PAUSED = 4;
  static final int STOPPED = 5;
  static final int DESTROYED = 6;
  private final AtomicInteger state = new AtomicInteger(0);
  private  int registrarActivityHashCode;


  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
//    final FlutterPluginMapboxPlugin plugin = new FlutterPluginMapboxPlugin(registrar);
    final FlutterPluginMapboxPlugin plugin = new FlutterPluginMapboxPlugin();
    registrar.activity().getApplication().registerActivityLifecycleCallbacks(plugin);

    registrar.platformViewRegistry().registerViewFactory("plugins.flutter.io/mapbox_gl",new MapboxMapFactory(plugin.state,null, registrar));
  }

  @Override
  public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
//    if (activity.hashCode() != registrarActivityHashCode) {
//      return;
//    }
    state.set(CREATED);
  }

  @Override
  public void onActivityStarted(Activity activity) {
//    if (activity.hashCode() != registrarActivityHashCode) {
//      return;
//    }
    state.set(STARTED);
  }

  @Override
  public void onActivityResumed(Activity activity) {
//    if (activity.hashCode() != registrarActivityHashCode) {
//      return;
//    }
    state.set(RESUMED);
  }

  @Override
  public void onActivityPaused(Activity activity) {
//    if (activity.hashCode() != registrarActivityHashCode) {
//      return;
//    }
    state.set(PAUSED);
  }

  @Override
  public void onActivityStopped(Activity activity) {
//    if (activity.hashCode() != registrarActivityHashCode) {
//      return;
//    }
    state.set(STOPPED);
  }

  @Override
  public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
  }

  @Override
  public void onActivityDestroyed(Activity activity) {
//    if (activity.hashCode() != registrarActivityHashCode) {
//      return;
//    }
    state.set(DESTROYED);
  }

//  public FlutterPluginMapboxPlugin(Registrar registrar) {
//    this.registrarActivityHashCode = registrar.activity().hashCode();
//  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    //this.registrarActivityHashCode = binding.getTextureRegistry().hashCode();
    final FlutterPluginMapboxPlugin plugin = new FlutterPluginMapboxPlugin();

    ((Application) binding.getApplicationContext()).registerActivityLifecycleCallbacks(plugin);

    binding.getPlatformViewRegistry().registerViewFactory("plugins.flutter.io/mapbox_gl",new MapboxMapFactory(plugin.state,binding, null));
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {

  }
}
