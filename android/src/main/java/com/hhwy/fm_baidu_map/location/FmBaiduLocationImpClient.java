package com.hhwy.fm_baidu_map.location;

import com.hhwy.fm_baidu_map.FmToolsBase;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public abstract class FmBaiduLocationImpClient{
    FmToolsBase _ftb;
    // flutter通道名称
    String _name;
    FmBaiduLocationImpClient(String name,PluginRegistry.Registrar registrar){
        _ftb = new FmToolsBase(this, name, registrar);
    }

    /**
     * 开始定位
     */
    public abstract void start();

    /**
     * 结束定位
     */
    public abstract void  stop();


    /**
     * 是否开始定位
     * @return
     */
    public abstract boolean isStarted();

    /**
     * 销毁
     */
    public void dispose() {
        _ftb.dispose();
    };
}
