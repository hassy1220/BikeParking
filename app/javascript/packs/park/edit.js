$(function(){
  function initMap() {
    // /43行目が初期マップ位置の拡大状況・44行目が緯度経度で福岡市を表示させる様にしている/
   var opts = {
     zoom: 15,
     center: new google.maps.LatLng(33.589815,130.412306),
     restriction: {
		　　latLngBounds: {
		　　	north: 33.600947,
		　　	south: 33.577563,
		　　	west: 130.386021,
		　　	east: 130.440347
	　 },
	　　	strictBounds: true
　　 }
   };

   var map = new google.maps.Map(document.getElementById("map"), opts);

   var idoInput = document.getElementById("serve_park_lat").value;
   var keidoInput = document.getElementById("serve_park_lng").value;

   var m_latlng = new google.maps.LatLng(idoInput,keidoInput);
      var marker = new google.maps.Marker({
       　  position: m_latlng,
          map: map,
      });
   map.addListener( "click", function ( event ) {
      marker.setMap(null);
   });


    map.addListener( "click", function ( event ) {
      // 地図をクリックしたらf.hidden_field :lat,value:"lat"f.hidden_field :lng,value:"lng"のValue値変更
    　document.getElementById("park_lat").value = event.latLng.lat();
    　document.getElementById("park_lng").value = event.latLng.lng();

      // 入力した緯度・経度を取得
      var idoInput = document.getElementById("park_lat").value;
      var keidoInput = document.getElementById("park_lng").value;
      // 緯度・経度をLatLngクラスに変換
      var latLngInput = new google.maps.LatLng(idoInput, keidoInput);

      var m_latlng = new google.maps.LatLng(idoInput,keidoInput);
      var marke = new google.maps.Marker({
       　  position: m_latlng,
          map: map,
      });

      //GoogleMapsAPIジオコーダ
      var geocoder = new google.maps.Geocoder();

      geocoder.geocode(
        {
          latLng: latLngInput
        },
        function(results, status) {
          var address = "";

          if (status == google.maps.GeocoderStatus.OK) {
          //取得が成功した場合

            //住所を取得します。
            address = results[0].formatted_address;

          } else if (status == google.maps.GeocoderStatus.ZERO_RESULTS) {
            alert("住所が見つかりませんでした。");
          } else if (status == google.maps.GeocoderStatus.ERROR) {
            alert("サーバ接続に失敗しました。");
          } else if (status == google.maps.GeocoderStatus.INVALID_REQUEST) {
            alert("リクエストが無効でした。");
          } else if (status == google.maps.GeocoderStatus.OVER_QUERY_LIMIT) {
            alert("リクエストの制限回数を超えました。");
          } else if (status == google.maps.GeocoderStatus.REQUEST_DENIED) {
            alert("サービスが使えない状態でした。");
          } else if (status == google.maps.GeocoderStatus.UNKNOWN_ERROR) {
            alert("原因不明のエラーが発生しました。");
          }

          //住所の結果表示をします。
          document.getElementById('park_addressOutput').value = address;
        　 // 　新しいところをクリックしたら、古いマーカーは消す
        　map.addListener( "click", function ( event ) {
            marke.setMap(null);
          });
        });


        service=new google.maps.places.PlacesService(map);
          var request={
             location: new google.maps.LatLng(idoInput,keidoInput),
             radius:250, /* 指定した座標から半径1000m(1km)以内 */
             types:['shopping_mall'],
          };

        service.search(request, callback);
        function callback(results, status) {
        document.getElementById("vicinity_vicinity_name").value = "";
          if (status==google.maps.places.PlacesServiceStatus.OK && results.length>0){
             for (var i=0; i<results.length; i++) {
                var places=results[i];
                console.log(results[i].name)
                document.getElementById("vicinity_vicinity_name").value += `${results[i].name},`;
             }
          }else{
            alert("このエリアでのスポット情報はありません。");
          }
        };



　  　});
  };
 initMap();
});