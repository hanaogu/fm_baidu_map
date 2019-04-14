package com.hhwy.fm_baidu_map.location;

import io.flutter.plugin.common.PluginRegistry;

public class FmBaiduLocationImpClientGPS extends FmBaiduLocationImpClient {
    public FmBaiduLocationImpClientGPS(String name, PluginRegistry.Registrar registrar){
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
