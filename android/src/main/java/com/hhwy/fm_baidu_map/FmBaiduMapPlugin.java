package com.hhwy.fm_baidu_map;

import org.json.JSONObject;

import java.lang.reflect.Method;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FmBaiduMapPlugin */
public class FmBaiduMapPlugin implements MethodCallHandler {
  private  static  FmBaiduMapPluginImp _imp;
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "fm_baidu_map");
    channel.setMethodCallHandler(new FmBaiduMapPlugin());
    _imp= new FmBaiduMapPluginImp(registrar);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    FmToolsBase.onMethodCall(_imp,call,result);
  }
}
