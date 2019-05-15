package com.hhwy.fm_baidu_map;

import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.CircleOptions;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.MyLocationData;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.map.Polyline;
import com.baidu.mapapi.map.PolylineOptions;
import com.baidu.mapapi.map.Stroke;
import com.baidu.mapapi.map.TextOptions;
import com.baidu.mapapi.map.TextureMapView;
import com.baidu.mapapi.model.LatLng;

import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Point;
import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FmBaiduMapView{
    private FmToolsBase _ftb;
    private TextureMapView _view;
    private BaiduMap _bmp;
    private final FmBaiduMapViewFactory _factory;
    private final HashMap<String, FmOverlay>_overlays = new HashMap<>();
    class FmOverlayItem{
        Overlay overlay;
        String id;
        JSONObject config;
    }
    class FmOverlay{
        final private HashMap <String,FmOverlayItem>_list= new HashMap<>();
        void add(String id,Overlay overlay,JSONObject config){
            FmOverlayItem item = new  FmOverlayItem();
            item.id = id;
            item.config = config;
            item.overlay = overlay;
            _list.put(id,item);
        }

        /**
         * 获取一个对象
         * @param id
         * @return
         */
        FmOverlayItem get(String id){
            return _list.get(id);
        }
        /**
         * 移除一个对象
         * @param id
         */
        boolean  remove(String id){
            if ( !_list.containsKey(id) ){
                return false;
            }
            FmOverlayItem item = _list.get(id);
            item.overlay.remove();
            _list.remove(id);
            return  true;
        }

        /**
         * 全部移除
         */
        void  removeAll(){
            for (Map.Entry<String,FmOverlayItem> it:_list.entrySet()) {
                it.getValue().overlay.remove();
            }
            _list.clear();
        }

        /**
         * 设置显示顺序
         * @param id
         * @param index
         * @return
         */
        boolean setIndex(String id, int index){
            if ( !_list.containsKey(id) ){
                return false;
            }
            FmOverlayItem item = _list.get(id);
            item.overlay.setZIndex(index);
            return  true;
        }

        /**
         * 设置所有元素的显示顺序
         * @param index
         */
        void  setIndexAll(int index){
            for (Map.Entry<String,FmOverlayItem> it:_list.entrySet()) {
                it.getValue().overlay.setZIndex(index);
            }
            _list.clear();
        }
        /**
         * 设置显示或隐藏
         * @param id
         * @param visible
         * @return
         */
        boolean setVisible(String id, boolean visible){
            if ( !_list.containsKey(id) ){
                return false;
            }
            FmOverlayItem item = _list.get(id);
            item.overlay.setVisible(visible);
            return  true;
        }

        /**
         * 设置所有元素的显示或隐藏
         * @param visible
         */
        void  setVisibleAll(boolean visible){
            for (Map.Entry<String,FmOverlayItem> it:_list.entrySet()) {
                it.getValue().overlay.setVisible(visible);
            }
            _list.clear();
        }
    }
    void _clickOverlay(Overlay overlay){
        if ( overlay == null ){
            return;
        }
        Bundle bundle  = overlay.getExtraInfo();
        if ( bundle == null ){
            return;
        }
        String id = bundle.getString("id");
        String layer = bundle.getString("layer");
        if ( _overlays.containsKey(layer) ){
            FmOverlayItem it = _overlays.get(layer).get(id);
            if ( it != null ){
                _ftb.invokeMethod("click_overlay",_ftb.JsonObject2HashMap(it.config));
            }
        }
    }
    /**
     * 构造函数
     * @param registrar
     */
    FmBaiduMapView(String name,PluginRegistry.Registrar registrar, FmBaiduMapViewFactory factory){
        _ftb = new FmToolsBase(this, name, registrar);
        _view=new TextureMapView(registrar.activity());
        _bmp = _view.getMap();
        _bmp.setMyLocationEnabled(true);
        _factory = factory;
        _bmp.setOnMapLoadedCallback(new BaiduMap.OnMapLoadedCallback() {
            @Override
            public void onMapLoaded() {
                _ftb.invokeMethod("onMapLoaded",null);
            }
        });
        _bmp.setOnMapRenderCallbadk(new BaiduMap.OnMapRenderCallback() {
            @Override
            public void onMapRenderFinished() {
                _ftb.invokeMethod("onMapRenderFinished",null);
            }
        });
        _bmp.setOnMarkerClickListener(new BaiduMap.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker) {
                _clickOverlay(marker);
                return true;
            }
        });
        _bmp.setOnPolylineClickListener(new BaiduMap.OnPolylineClickListener() {
            @Override
            public boolean onPolylineClick(Polyline polyline) {
                _clickOverlay(polyline);
                return false;
            }
        });
        _bmp.setOnMapStatusChangeListener(new BaiduMap.OnMapStatusChangeListener() {
            @Override
            public void onMapStatusChangeStart(MapStatus mapStatus) {
                _onMapStatus("setOnMapStatusChangeListener",mapStatus);
            }

            @Override
            public void onMapStatusChangeStart(MapStatus mapStatus, int i) {
                _onMapStatus("onMapStatusChangeStart",mapStatus);
            }

            @Override
            public void onMapStatusChange(MapStatus mapStatus) {
                _onMapStatus("onMapStatusChange",mapStatus);
            }

            @Override
            public void onMapStatusChangeFinish(MapStatus mapStatus) {
                _onMapStatus("onMapStatusChangeFinish",mapStatus);
            }
        });
    }
    private  void _onMapStatus(String name,MapStatus mapStatus){
        HashMap<String,Object> m = new HashMap<>();
        m.put("latitude",mapStatus.target.latitude);
        m.put("longitude",mapStatus.target.longitude);
        m.put("zoom",mapStatus.zoom);
        m.put("overlook",mapStatus.overlook);
        m.put("rotate",mapStatus.rotate);
        m.put("screenX",mapStatus.targetScreen.x);
        m.put("screenY",mapStatus.targetScreen.y);
        _ftb.invokeMethod(name,m);
    }

    /**
     * 设置地图定位点
     * @param obj
     * String name, 对象名称
     * double latitude, 经度
     * double longitude, 纬度
     * float direction, 方向
     * float accuracy 圈
     */
    public  void setCurrentPoint(final JSONObject obj){
        try {
            setCurrentPointImp(
                    obj.getDouble("latitude"),
                    obj.getDouble("longitude"),
                    (float) obj.getDouble("direction"),
                    (float)obj.getDouble("accuracy")
            );
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置地图定位到指定点
     * @param obj
     * latitude
     * longitude
     * overlook
     * rotate
     * zoom
     */
    public  void setCenter(final JSONObject obj){
        try {
            setCenterImp(
                    new LatLng(obj.getDouble("latitude"),obj.getDouble("longitude")),
                    (float) obj.getDouble("overlook"),
                    (float)obj.getDouble("rotate"),
                    (float)obj.getDouble("zoom"),
                    null
            );
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
    /**
     * 设置定位点
     * @param latitude 经度
     * @param longitude 纬度
     * @param direction 方向
     * @param accuracy 圈大小
     */
    void setCurrentPointImp(double latitude, double longitude,float direction, float accuracy){
        MyLocationData myLocationData = new MyLocationData.Builder()
                .direction(direction )
                .accuracy(accuracy )
                .latitude(latitude)
                .longitude(longitude)
                .build();
        _bmp.setMyLocationData(myLocationData);
    }

    /**
     * 获取内部view
     * @return MapView
     */
    TextureMapView view(){return _view;}

    /**
     * 设置地图定位到指定点
     * @param latLng
     * @param overlook
     * @param rotate
     * @param zoom
     * @param point
     */
    void setCenterImp(final LatLng latLng,
                   final float overlook,
                   final float rotate,
                   final float zoom,
                   final Point point) {

        if (_view == null) {
            return;
        }
        MapStatus.Builder builder = new MapStatus.Builder();
        if (latLng != null) {
            builder.target(latLng);
        }
        if (overlook >= -45 && overlook <= 0) {
            builder.overlook(overlook);
        }
        if (rotate >= -180 && rotate <= 180) {
            builder.rotate(rotate);
        }
        if (zoom >= 1 && zoom <= 21) {
            builder.zoom(zoom);
        }
        if (point != null) {
            builder.targetScreen(point);
        }
        _bmp.setMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));
    }

    /**
     * 绘制文字覆盖物
     * @param obj
     */
    void addOverlays(final JSONObject obj) {
        try {
            JSONArray arr = obj.getJSONArray("objects");
            for( int i=0; i<arr.length();++i){
                JSONObject item = arr.getJSONObject(i);
                _createOptions(item,true);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
    /**
     * 移除覆盖物
     * @param obj
     */
    void removeOverlays(final JSONObject obj){
        try {
            // 先取图层
            if ( obj.has("layer") ){
                FmOverlay item = _overlays.get(obj.getString("layer"));
                // 无id时，删除所有图层元素
                if ( obj.has("id")){
                    item.remove(obj.getString("id"));
                }else{
                    item.removeAll();
                    _overlays.remove(obj.getString("layer"));
                }
            }else{
                if ( !obj.has("id")) {
                    System.out.println("removeOverlays error:need id or layer");
                    return;
                }
                // 查找id，进行删除
                for (Map.Entry<String,FmOverlay>item:_overlays.entrySet()){
                    if ( item.getValue().remove(obj.getString("id")) ){
                        break;
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
    /**
     * 设置显示顺序
     * @param obj
     */
    void setOverlaysIndex(final JSONObject obj){
        try {
            // 先取图层
            if ( obj.has("layer") ){
                FmOverlay item = _overlays.get(obj.getString("layer"));
                // 无id时，设置所有图层元素
                if ( obj.has("id")){
                    item.setIndex(obj.getString("id"),obj.getInt("zIndex"));
                }else{
                    item.setIndexAll(obj.getInt("zIndex"));
                }
            }else{
                if ( !obj.has("id")) {
                    System.out.println("setOverlaysIndex error:need id or layer");
                    return;
                }
                // 查找id
                for (Map.Entry<String,FmOverlay>item:_overlays.entrySet()){
                    if ( item.getValue().setIndex(obj.getString("id"),obj.getInt("zIndex")) ){
                        break;
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
    /**
     * 设置显示或隐藏
     * @param obj
     */
    void setOverlaysVisible(final JSONObject obj){
        try {
            // 先取图层
            if ( obj.has("layer") ){
                FmOverlay item = _overlays.get(obj.getString("layer"));
                // 无id时，设置所有图层元素
                if ( obj.has("id")){
                    item.setVisible(obj.getString("id"),obj.getBoolean("visible"));
                }else{
                    item.setVisibleAll(obj.getBoolean("visible"));
                }
            }else{
                if ( !obj.has("id")) {
                    System.out.println("setOverlaysVisible error:need id or layer");
                    return;
                }
                // 查找id
                for (Map.Entry<String,FmOverlay>item:_overlays.entrySet()){
                    if ( item.getValue().setVisible(obj.getString("id"),obj.getBoolean("visible")) ){
                        break;
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * 更新已有实体元素
     * @param obj
     */
    void updateOverlays(final JSONObject obj){
        try {
            JSONArray arr = obj.getJSONArray("objects");
            for( int i=0; i<arr.length();++i){
                JSONObject item = arr.getJSONObject(i);
                for (Map.Entry<String,FmOverlay>it:_overlays.entrySet()){
                    // 移除成功后再加一遍
                    if ( it.getValue().remove(item.getString("id")) ){
                        OverlayOptions option = _createOptions(item,false);
                        if ( option != null ) {
                            _addOver(item,_bmp.addOverlay(option));
//                            it.getValue().add(item.getString("id"), _bmp.addOverlay(option), item);
                        }
                        break;
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * 创建一个标记配置
     * @param obj
     * @param addToMap 是否同时加到地图
     * @return
     */
    private OverlayOptions _createOptions(final JSONObject obj, boolean addToMap){
        try {
            OverlayOptions option = null;
            String type = obj.getString("type");
            if ( type.equalsIgnoreCase("circle")) {
                // 圆心位置
                LatLng center = new LatLng(obj.getDouble("latitude"), obj.getDouble("longitude"));
                // 构造CircleOptions对象
                CircleOptions c = new CircleOptions().center(center)
                        .radius(obj.getInt("radius"));
                // 填充颜色
                if (obj.has("fillColor")) {
                    c.fillColor(obj.getInt("fillColor"));
                }
                // 边框宽和边框颜色
                if (obj.has("strokeWidth") && obj.has("strokeColor")) {
                    c.stroke(
                        new Stroke(
                            obj.getInt("strokeWidth"),
                            obj.getInt("strokeColor")
                        )
                    );
                }
                if ( obj.has("zIndex") ){
                    c.zIndex(obj.getInt("zIndex"));
                }
                if ( obj.has("visible") ){
                    c.visible(obj.getBoolean("visible"));
                }
                option = c;
            }else if(type.equalsIgnoreCase("line")){
                JSONArray points = obj.getJSONArray("points");
                List<LatLng> pts = new ArrayList<LatLng>();
                for( int i=0; i<points.length();++i){
                    JSONObject item = points.getJSONObject(i);
                    pts.add(new LatLng(item.getDouble("latitude"),item.getDouble("longitude")));
                }
                PolylineOptions lin = new PolylineOptions().points(pts);
                if ( obj.has("color")){
                    lin.color(obj.getInt("color"));
                }
                if ( obj.has("width")){
                    lin.width(obj.getInt("width"));
                }
                if ( obj.has("dottedLine")){
                    lin.dottedLine(obj.getBoolean("dottedLine"));
                }
                if ( obj.has("zIndex") ){
                    lin.zIndex(obj.getInt("zIndex"));
                }
                if ( obj.has("visible") ){
                    lin.visible(obj.getBoolean("visible"));
                }
                option = lin;
            }else if( type.equalsIgnoreCase("mark")){
                LatLng center = new LatLng(obj.getDouble("latitude"), obj.getDouble("longitude"));
                MarkerOptions mk = new MarkerOptions().position(center);
//                Bitmap bitmap = BitmapDescriptorFactory.fromAsset(obj.getString("icon")).getBitmap();
                AssetManager assetManager = _ftb._registrar.context().getAssets();
                String key = _ftb._registrar.lookupKeyForAsset(obj.getString("icon"));

                Bitmap bitmap = null;
                try {
                    bitmap = BitmapFactory.decodeStream(assetManager.open(key));
                } catch (IOException e) {
                    e.printStackTrace();
                }
                if ( obj.has("scale") && obj.getDouble("scale")!=1.0 ){
                    bitmap = _ftb.imageScale(bitmap,(float)obj.getDouble("scale"),(float)obj.getDouble("scale"));
                }
                if (obj.has("text")) {
                    // 在图片上绘制文字
                    float textSize =-1;
                    if ( obj.has("textSize")){
                        textSize = (float)obj.getInt("textSize");
                    }
                    int textColor = Color.BLACK;
                    if ( obj.has("textColor")){
                        textColor = obj.getInt("textColor");
                    }
                    bitmap = _ftb.textBitmap(bitmap,obj.getString("text"),textSize, textColor);
                }
                mk.icon(BitmapDescriptorFactory.fromBitmap(bitmap));
                if ( obj.has("draggable") ){
                    mk.draggable(obj.getBoolean("draggable"));
                }
                if ( obj.has("perspective")){
                    mk.perspective(obj.getBoolean("perspective"));
                }
                if ( obj.has("flat")){
                    mk.flat(obj.getBoolean("flat"));
                }
                if ( obj.has("alpha")){
                    mk.alpha((float)obj.getDouble("alpha"));
                }
                if ( obj.has("title") ){
                    mk.title(obj.getString("title"));
                }
                if ( obj.has("rotate") ){
                    mk.rotate((float)obj.getDouble("rotate"));
                }
                if ( obj.has("zIndex") ){
                    mk.zIndex(obj.getInt("zIndex"));
                }
                if ( obj.has("visible") ){
                    mk.visible(obj.getBoolean("visible"));
                }
                if ( obj.has("anchorX") && obj.has("anchorY")){
                    mk.anchor((float)obj.getDouble("anchorX"),(float)obj.getDouble("anchorY"));
                }else{
                    mk.anchor(0.5f,0.5f);
                }
                option = mk;
                System.out.println(option);
            }else if( type.equalsIgnoreCase("text")){
                LatLng llText = new LatLng(obj.getDouble("latitude"), obj.getDouble("longitude"));
                //构建TextOptions对象
                TextOptions txt = new TextOptions()
                        // 文字内容
                        .text(obj.getString("text"))
                        // 坐标
                        .position(new LatLng(obj.getDouble("latitude"),obj.getDouble("longitude")));

                if ( obj.has("bgColor") ){
                    txt.bgColor(obj.getInt("bgColor"));
                }
                if ( obj.has("rotate") ){
                    txt.rotate(obj.getInt("rotate"));
                }
                if ( obj.has("fontSize") ){
                    txt.fontSize(obj.getInt("fontSize"));
                }
                if ( obj.has("fontColor") ){
                    txt.fontColor(obj.getInt("fontColor"));
                }
                if ( obj.has("zIndex") ){
                    txt.zIndex(obj.getInt("zIndex"));
                }
                if ( obj.has("visible") ){
                    txt.visible(obj.getBoolean("visible"));
                }
                option = txt;
            }
            // 在地图上显示
            if ( option != null && addToMap ) {
                Overlay it = _bmp.addOverlay(option);
                _addOver(obj, it);
            }
            return  option;

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return  null;
    }

    /**
     * 添加覆盖物
     * @param obj 配置
     * @param it 覆盖物
     */
    private void _addOver(final JSONObject obj,Overlay it){
        try {
            FmOverlay item;
            if ( !_overlays.containsKey(obj.getString("layer"))){
                item = new FmOverlay();
                _overlays.put(obj.getString("layer"),item);
            }else{
                item = _overlays.get(obj.getString("layer"));
            }
            Bundle bundle = new Bundle();
            bundle.putString("id",obj.getString("id"));
            bundle.putString("layer",obj.getString("layer"));
            it.setExtraInfo(bundle);
            item.add(obj.getString("id"), it, obj);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * 销毁
     */
    public void dispose(){
        _ftb.dispose();
        _bmp = null;
        _view = null;
    }
}
