package com.hhwy.fm_baidu_location;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * 百度监听类
 */
public class FmBaiduLocationImpClientBaidu extends FmBaiduLocationImpClient {
    // 控制监听
    LocationClient _client;
    // 监听消息
    BDLocationListener _listener;

    // 构造函数
    FmBaiduLocationImpClientBaidu(String name, PluginRegistry.Registrar registrar, JSONObject options) {
        super(name, registrar);
        _client = new LocationClient(_registrar.activity());
        // 设置
        LocationClientOption locationClientOption = new LocationClientOption();
        locationClientOption.setCoorType("bd09ll");
        locationClientOption.setOpenGps(true);
        locationClientOption.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);
        locationClientOption.setScanSpan(1000);
        locationClientOption.disableCache(true);
        locationClientOption.setIsNeedAltitude(true);
        locationClientOption.setNeedDeviceDirect(true);
        _client.setLocOption(locationClientOption);

        _listener = new BDLocationListener() {
            @Override
            public void onReceiveLocation(BDLocation bdLocation) {
                HashMap<String, Object> jsonObject = new HashMap();
                jsonObject.put("coordType", "Baidu");
                jsonObject.put("time", System.currentTimeMillis());
                jsonObject.put("speed", bdLocation.getSpeed());
                jsonObject.put("altitude", bdLocation.getAltitude());
                jsonObject.put("latitude", bdLocation.getLatitude());
                jsonObject.put("longitude", bdLocation.getLongitude());
                jsonObject.put("bearing", bdLocation.getDirection());
                invokeMethod("onLocation", jsonObject);
            }
        };
        _client.registerLocationListener(_listener);

    }

    @Override
    public void start() {
        if (_client.isStarted()) {
            return;
        }
        _client.start();

    }

    @Override
    public boolean isStarted() {
        return _client.isStarted();
    }

    @Override
    public void stop() {
        _client.stop();
    }

    @Override
    public void dispose() {
        _client.unRegisterLocationListener(_listener);
        _listener = null;
        _client.stop();
        _client = null;
        super.dispose();
    }
}
