package com.hhwy.fm_baidu_map;


import com.baidu.mapapi.CoordType;
import com.baidu.mapapi.SDKInitializer;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.utils.DistanceUtil;
import com.hhwy.fm_baidu_map.location.FmBaiduLocationImpClient;
import com.hhwy.fm_baidu_map.location.FmBaiduLocationImpClientBaidu;
import com.hhwy.fm_baidu_map.location.FmBaiduLocationImpClientGPS;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;

public class FmBaiduMapPluginImp {
    final private PluginRegistry.Registrar _registrar;

    FmBaiduMapPluginImp(PluginRegistry.Registrar registrar){
        _registrar = registrar;
        registrar.platformViewRegistry().registerViewFactory("FmBaiduMapView",
                new FmBaiduMapViewFactory(new StandardMessageCodec(),_registrar));

        //在使用SDK各组件之前初始化context信息，传入ApplicationContext
        SDKInitializer.initialize(_registrar.activity().getApplicationContext());

        //自4.3.0起，百度地图SDK所有接口均支持百度坐标和国测局坐标，用此方法设置您使用的坐标类型.
        //包括BD09LL和GCJ02两种坐标，默认是BD09LL坐标。
        SDKInitializer.setCoordType(CoordType.BD09LL);

    }
    /**
     * 新增定位实例
     * @param obj
     */
    public  void newInstanceLocation(final JSONObject obj){
        try {
            // 获取名字
            String name = obj.getString("name");
            boolean isBaidu = obj.getBoolean("isBaidu");
            // 新增定位
            FmBaiduLocationImpClient client = isBaidu ?
                    new FmBaiduLocationImpClientBaidu(name,_registrar,obj.getJSONObject("options")):
                    new FmBaiduLocationImpClientGPS(name,_registrar);
            System.out.println("newInstance,name:"+name);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取距离
     * @param obj
     * @return
     */
    public  double getDistance(final  JSONObject obj){
        try {
            double dist = DistanceUtil.getDistance(
                new LatLng(obj.getDouble("latitude1"),obj.getDouble("longitude1")),
                new LatLng(obj.getDouble("latitude2"),obj.getDouble("longitude2"))
            );
            return dist;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return -1.0;
    }
}
