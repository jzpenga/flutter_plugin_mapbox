package com.mapbox.flutter_plugin_mapbox;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jiazhen on 2019-12-11.
 * Desc:
 */
public class FeatureCollectionBean {


    /**
     * type : FeatureCollectionBean
     * features : [{"type":"Feature","properties":{"marker-color":"#7e7e7e","marker-size":"medium","marker-symbol":"","name":"Washington","capital":"Olympia"},"geometry":{"type":"Point","coordinates":[-122.9048,47.03676]}},{"type":"Feature","properties":{"marker-color":"#7e7e7e","marker-size":"medium","marker-symbol":"","name":"Oregon","capital":"Salem"},"geometry":{"type":"Point","coordinates":[-123.03048,44.93847]}},{"type":"Feature","properties":{"marker-color":"#7e7e7e","marker-size":"medium","marker-symbol":"","name":"California","capital":"Sacramento"},"geometry":{"type":"Point","coordinates":[-121.493779,38.576641]}},{"type":"Feature","properties":{"marker-color":"#7e7e7e","marker-size":"medium","marker-symbol":"","name":"Idaho","capital":"Boise"},"geometry":{"type":"Point","coordinates":[-116.199,43.61777]}}]
     */

    private String type = "FeatureCollection";
    private List<FeaturesBean> features;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<FeaturesBean> getFeatures() {
        return features;
    }

    public void setFeatures(List<FeaturesBean> features) {
        this.features = features;
    }

    public static class FeaturesBean {
        /**
         * type : Feature
         * properties : {"marker-color":"#7e7e7e","marker-size":"medium","marker-symbol":"","name":"Washington","capital":"Olympia"}
         * geometry : {"type":"Point","coordinates":[-122.9048,47.03676]}
         */

        private String type = "Feature";
        private PropertiesBean properties;
        private GeometryBean geometry;

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public PropertiesBean getProperties() {
            return properties;
        }

        public void setProperties(PropertiesBean properties) {
            this.properties = properties;
        }

        public GeometryBean getGeometry() {
            return geometry;
        }

        public void setGeometry(GeometryBean geometry) {
            this.geometry = geometry;
        }

        public static class PropertiesBean {
            /**
             * marker-color : #7e7e7e
             * marker-size : medium
             * marker-symbol :
             * name : Washington
             * capital : Olympia
             */

            @SerializedName("marker-color")
            private String markercolor;
            @SerializedName("marker-size")
            private String markersize;
            @SerializedName("marker-symbol")
            private String markersymbol;
            private String desc;
            private String title;
            private String id;


            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getMarkercolor() {
                return markercolor;
            }

            public void setMarkercolor(String markercolor) {
                this.markercolor = markercolor;
            }

            public String getMarkersize() {
                return markersize;
            }

            public void setMarkersize(String markersize) {
                this.markersize = markersize;
            }

            public String getMarkersymbol() {
                return markersymbol;
            }

            public void setMarkersymbol(String markersymbol) {
                this.markersymbol = markersymbol;
            }

            public String getDesc() {
                return desc;
            }

            public void setDesc(String desc) {
                this.desc = desc;
            }

            public String getTitle() {
                return title;
            }

            public void setTitle(String title) {
                this.title = title;
            }
        }

        public static class GeometryBean {
            /**
             * type : Point
             * coordinates : [-122.9048,47.03676]
             */

            private String type = "Point";
            private List<Double> coordinates;

            public String getType() {
                return type;
            }

            public void setType(String type) {
                this.type = type;
            }

            public List<Double> getCoordinates() {
                return coordinates;
            }

            public void setCoordinates(List<Double> coordinates) {
                this.coordinates = coordinates;
            }
        }
    }


   static String symbolInfoToJson(List<SymbolOption> symbolOptionList){
        FeatureCollectionBean featureCollectionBean = new FeatureCollectionBean();

       ArrayList<FeaturesBean> featuresBeans = new ArrayList<>();

       for (SymbolOption symbolOption : symbolOptionList) {
           FeaturesBean featuresBean = new FeaturesBean();

           FeaturesBean.GeometryBean geometryBean = new FeaturesBean.GeometryBean();
           ArrayList<Double> coordinates = new ArrayList<>();
           coordinates.add(symbolOption.getGeometry().getLongitude());
           coordinates.add(symbolOption.getGeometry().getLatitude());
           geometryBean.setCoordinates(coordinates);

           FeaturesBean.PropertiesBean propertiesBean = new FeaturesBean.PropertiesBean();
           propertiesBean.setTitle(symbolOption.getTitle());
           propertiesBean.setMarkercolor("#7e7e7e");
           propertiesBean.setMarkersize("medium");
           propertiesBean.setMarkersymbol("");
           propertiesBean.setDesc(symbolOption.getDesc());
           propertiesBean.setId(String.valueOf(symbolOption.getId()));

           featuresBean.setGeometry(geometryBean);
           featuresBean.setProperties(propertiesBean);

           featuresBeans.add(featuresBean);
       }

        featureCollectionBean.setFeatures(featuresBeans);
        Gson gson = new Gson();
        return gson.toJson(featureCollectionBean);
    }

}
