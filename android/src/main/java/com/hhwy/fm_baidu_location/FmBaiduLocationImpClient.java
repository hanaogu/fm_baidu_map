package com.hhwy.fm_baidu_location;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public abstract class FmBaiduLocationImpClient extends  FmToolsBase {
    // flutter通道名称
    String _name;
    FmBaiduLocationImpClient(String name,PluginRegistry.Registrar registrar){
        super(name,registrar);
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
}
