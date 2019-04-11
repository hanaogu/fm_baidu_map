package com.hhwy.fm_baidu_location;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FmBaiduLocationImp {
    /**
     * 插件对象
     */
    final private PluginRegistry.Registrar _registrar;
    // 构造函数
    FmBaiduLocationImp(PluginRegistry.Registrar registrar){
        _registrar = registrar;
    }

    /**
     * 新增实例
     * @param obj
     */
    public  void newInstance(final JSONObject obj){
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
}
