$(function(){
  var marker = [];
   function initMap() {
     var opts = {
        zoom: 15,
       center: new google.maps.LatLng(33.589815,130.412306),
       restriction: {
  		　　latLngBounds: {
  		　　	north: 33.600747,
  		　　	south: 33.578963,
  		　　	west: 130.386021,
  		　　	east: 130.434000
  	 },
  	　　	strictBounds: true
  　　 }
     };
　　var map = new google.maps.Map(document.getElementById("map"), opts);

    if(document.getElementById('vicinity_place').value != ""){
       key = document.getElementById('vicinity_place').value;
       var service = new google.maps.places.PlacesService(map);
       var request={
          query: key
       };
       service.textSearch(request,callback);

       function callback(results, status){
         if (status == google.maps.places.PlacesServiceStatus.OK) {
            for (var i = 0; i < results.length; i++) {
                var place = results[i];
                  var marke = new google.maps.Marker({
               　    position: place.geometry.location,
                    map: map,
                  });
            }
         }else if (status == google.maps.GeocoderStatus.ZERO_RESULTS) {
              alert("サーバ接続に失敗しました。");
         };
       }
    };

     // 21行目のid=park_areaのValue値を取得
     var date =document.getElementById("park_area").value
     // 文字列っぽい配列を配列にする方法'[[aaa,aaa],[sss,sss],[sss,fff]]'→[aaa,aaa],[sss,sss],[sss,fff]に変換する
     var date = JSON.parse(date)


     for(var i = 0; i < date.length; i ++ ){
      　var latlng = new google.maps.LatLng(date[i][1],date[i][0]);

        var contentStr =
        // バッククォーテーション``で囲む中で${}を使えば式展開できる
        `<a href="/public/parks/${date[i][3]}">${date[i][2]}'</a>`


        // 情報ウインドウを表示させ、駐車場名を表示
          var infowindow = new google.maps.InfoWindow({
            content: contentStr,
            position: latlng
          });
          infowindow.open(map);
      };
    };
  initMap();
});

$(function(){
  
});