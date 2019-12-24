# Flutter Mapbox Plugin
Mapbox 没有Flutter插件,所以就封装了一个,实现了基本的定位功能,基本上是按照公司的需求来封装的,所以可定制性并不是很好,等有时间在好好抽出来一下
**实现了
基本的定位功能,
设置当前的定位点,
添加大头针,
划线,
调用原生地图导航(iOS)
基本功能**
![mapbox.gif]('https://github.com/jzpenga/flutter_plugin_mapbox/blob/master/mapbox.gif')


### Install
###### Android
需要添加Mapbox的token android/app/src/main/AndroidManifest.xml:
```<application ...
    <meta-data android:name="com.mapbox.token" android:value="YOUR_TOKEN_HERE" />
```
###### iOS
iOS需要在info.plist 里面添加定位权限和mapbox的token还有显示插件的一句代码
```<key>MGLMapboxAccessToken</key>
	<string>mapbox token</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>允许使用位置</string>
	<key>io.flutter.embedded_views_preview</key>
	<true/>
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
```

##### 使用
需要先定义一个MapboxMapController 用来调用地图的相关方法


```
 MapboxMapController _mapboxMapController;
  //地图初始化完成的回调
  void onCreateMap(MapboxMapController controller){
    _mapboxMapController = controller;
    
  }
  
   MapboxMap(
              initialCameraPosition: CameraPosition(
                zoom: 11,
                target: LatLng(39.911337,116.410625),
              ),
              myLocationEnabled: true,
              symbolShowIndex: false,
              onMapCreated: onCreateMap,
            ),

```
可用方法列表
```
//添加大头一组大头针
 Future<List<dynamic>> addSymbolList(List<SymbolOptions> optionsList) 
 //画线
 Future<Line> addLine(LineOptions options)
 //设置选中某个大头针
Future<Symbol> selectSymbol(SymbolOptions options)
```

