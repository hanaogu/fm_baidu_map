package com.hhwy.fm_baidu_location;

import io.flutter.plugin.common.PluginRegistry;

public class FmBaiduLocationImpClientGPS extends FmBaiduLocationImpClient {
    FmBaiduLocationImpClientGPS(String name, PluginRegistry.Registrar registrar){
        super(name,registrar);
    }
    @Override
    public void start() {

    }

    @Override
    public void stop() {

    }
    @Override
    public boolean isStarted() {
        return false;
    }
}
