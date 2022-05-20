$(function(){
   function initMap() {
     //変数lat/lngを宣言し、park_area_lat/lng(ID)のValue値を取得
      var lat =document.getElementById("park_area_lat").value
    　var lng =document.getElementById("park_area_lng").value

      // /18行目が初期マップ位置の拡大状況・19行目が緯度経度で福岡市を表示させる様にしている/
      var opts = {
        zoom: 15,
     center: new google.maps.LatLng(lat,lng),
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

      // LatLng(,)に19/20行目で取得した緯度経度を入れる。
      var m_latlng = new google.maps.LatLng(lat,lng);
      var marker = new google.maps.Marker({
   　   　　 position: m_latlng,
      　    map: map
      });
    }
  initMap();
});
