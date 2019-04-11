package com.hhwy.fm_baidu_location;

import org.json.JSONObject;

import java.lang.reflect.Method;
import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * 工具类，用于通信
 */
public class FmToolsBase {
    /**
     * 插件对象
     */
    protected final PluginRegistry.Registrar _registrar;

    // 与flutter通信
    private MethodChannel _channel;
    // flutter通道名称
    final String _name;

    /**
     * 构造函数
     * @param name 名称
     * @param registrar flutter初始类
     */
    FmToolsBase(String name,PluginRegistry.Registrar registrar){
        _name = name;
        _registrar = registrar;
        _channel = new MethodChannel(_registrar.messenger(),_name);
        _channel.setMethodCallHandler(new MethodChannel.MethodCallHandler(){
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                FmToolsBase.onMethodCall(FmToolsBase.this,methodCall,result);
            }
        });
    }

    /**
     * 给flutter发送消息
     * @param method 方法名称
     * @param arguments 参数
     */
    public  void invokeMethod(String method, Object arguments){
        _channel.invokeMethod(method, arguments);
    }

    /**
     * 销毁
     */
    public void dispose(){
        _channel.setMethodCallHandler(null);
        _channel = null;
    }

    /**
     * 通过反射调用实例方法
     * @param imp
     * @param call
     * @param result
     */
    static public void onMethodCall(Object imp, MethodCall call, MethodChannel.Result result) {
        Class<?> clazz = imp.getClass();
        try {
            if (call.arguments != null) {
                Method method = clazz.getDeclaredMethod(call.method, JSONObject.class);
                method.setAccessible(true);
                Object r = method.invoke(imp, new JSONObject(call.arguments.toString()));
                result.success(r);
            } else {
                Method method = clazz.getDeclaredMethod(call.method);
                method.setAccessible(true);
                Object r = method.invoke(imp);
                result.success(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.notImplemented();
        }
    }
}
