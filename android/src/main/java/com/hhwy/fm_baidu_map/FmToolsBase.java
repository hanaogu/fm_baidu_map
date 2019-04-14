package com.hhwy.fm_baidu_map;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Rect;

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
    public FmToolsBase(String name, PluginRegistry.Registrar registrar){
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
        if ( _channel ==null ){return;}
        _channel.invokeMethod(method, arguments);
    }

    /**
     * 销毁
     */
    public void dispose(){
        if ( _channel != null ) {
            _channel.setMethodCallHandler(null);
            _channel = null;
        }
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
    /**
     * 调整图片大小
     *
     * @param bitmap
     *            源
     * @param scale_w
     *            输出宽度
     * @param scale_h
     *            输出高度
     * @return
     */
    public static Bitmap imageScale(Bitmap bitmap, float scale_w, float scale_h) {
        int src_w = bitmap.getWidth();
        int src_h = bitmap.getHeight();
        Matrix matrix = new Matrix();
        matrix.postScale(scale_w, scale_h);
        Bitmap dstbmp = Bitmap.createBitmap(bitmap, 0, 0, src_w, src_h, matrix,
                true);
        return dstbmp;
    }
    public static Bitmap textBitmap(Bitmap bitmap, String text, float textSize, int textColor) {
        if (bitmap != null && !text.isEmpty()) {
            Bitmap temp = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(),
                    Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(temp);
            canvas.drawBitmap(bitmap, 0, 0, null);
            Paint paint = new Paint();
            if ( textSize > 0 ) {
                paint.setTextSize(textSize);
            }
            paint.setTextAlign(Paint.Align.CENTER);
            paint.setColor(textColor);
            Rect rect = new Rect();
            paint.getTextBounds(text, 0, text.length(), rect);
//            float x = (bitmap.getWidth() - rect.width()) / 2f-1.0f;
            float y = (bitmap.getHeight() + rect.height()) / 2f-1.0f;
//            canvas.drawText(text, x, y, paint);
            canvas.drawText(text, bitmap.getWidth()/2.0f-1.0f, y, paint);
            bitmap.recycle();
            return temp;
        }
        return bitmap;
    }
}
