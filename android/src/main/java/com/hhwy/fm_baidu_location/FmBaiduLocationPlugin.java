package com.hhwy.fm_baidu_location;

import org.json.JSONObject;

import java.lang.reflect.Method;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FmBaiduLocationPlugin */
public class FmBaiduLocationPlugin implements MethodCallHandler {
  /** Plugin registration. */
  private  static  FmBaiduLocationImp _imp;

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "fm_baidu_location");
    channel.setMethodCallHandler(new FmBaiduLocationPlugin());
    _imp= new FmBaiduLocationImp(registrar);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    FmToolsBase.onMethodCall(_imp,call,result);
  }
}
