# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveStorage::AnalyzeJob.queue_adapter = :inline
ActiveStorage::PurgeJob.queue_adapter = :inline
Admin.create!(email:"test@test",password:111111
  )

Customer.create!(
  [
    {email: 'yamada@test.com', name: '山田太郎', password: '111111', bike_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")},
    {email: 'reiwa@test.com', name: '令和太郎', password: '111111', bike_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")},
    {email: 'heisei@test.com', name: '平成太郎', password: '111111', bike_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")}
  ]
)

park = Park.create!(
  [
    {lat: 33.589766,lng: 130.402241,name: "天神中央公園駐輪場",description: "天神地下街にも近くアクセス最高です",customer_id: 1,spec: 2,price: 200, parking_time: 2,addressOutput: "福岡県福岡市中央区天神１丁目３",purpose: "天神地下街"},
    {lat: 33.588617,lng: 130.419416,name: "博多駅前駐輪場",description: "博多駅の真前で、すぐにわかると思います！",customer_id: 2,spec: 1,price: 300, parking_time: 1,addressOutput: "福岡県福岡市博多区博多駅中央街９",purpose: "博多駅"},
    {lat: 33.594903,lng: 130.403780,name: "博多駐輪場",description: "アンパンマンミュージアムの近くです！",customer_id: 3,spec: 3,price: 100, parking_time: 1,addressOutput: "福岡県福岡市博多区中洲５丁目６",purpose: "アンパンマンミュージアム"},
  ]
)
park.each do |park|
  if park.id == 1
    park.images.attach(io: File.open("#{Rails.root}/db/fixtures/sample-park1.jpg"), filename:"sample-park1.jpg")
    park.images.attach(io: File.open("#{Rails.root}/db/fixtures/sample-park2.jpg"), filename:"sample-park2.jpg")
    park.images.attach(io: File.open("#{Rails.root}/db/fixtures/sample-park3.jpg"), filename:"sample-park3.jpg")
  elsif park.id == 2
    park.images.attach(io: File.open("#{Rails.root}/db/fixtures/sample-park4.jpg"), filename:"sample-park4.jpg")
    park.images.attach(io: File.open("#{Rails.root}/db/fixtures/sample-park5.jpg"), filename:"sample-park5.jpg")
    park.images.attach(io: File.open("#{Rails.root}/db/fixtures/sample-park6.jpg"), filename:"sample-park6.jpg")
  elsif park.id == 3
    park.images.attach(io: File.open("#{Rails.root}/db/fixtures/sample-park7.jpg"), filename:"sample-park7.jpg")
    park.images.attach(io: File.open("#{Rails.root}/db/fixtures/sample-park8.jpg"), filename:"sample-park8.jpg")
    park.images.attach(io: File.open("#{Rails.root}/db/fixtures/sample-park9.jpg"), filename:"sample-park9.jpg")
  end
end



Vicinity.create!(
  [
   {vicinity_name: "23区（オンワード） 大丸福岡天神店(大きいサイズ)"},
   {vicinity_name: "天神テルラ"},
   {vicinity_name: "博多リバレインモール by TAKASHIMAYA"},
   {vicinity_name: "博多辛子明太子うまか 博多阪急店"},
   {vicinity_name: "アミュプラザ博多"},
   {vicinity_name: "博多マルイ"},
   {vicinity_name: "自由区（オンワード） 博多阪急"},
   {vicinity_name: "アミュエスト博多"},
   {vicinity_name: "23区（オンワード） 博多阪急"},
   {vicinity_name: "KITTE博多"},
   {vicinity_name: "和洋酒"},
   {vicinity_name: "あき乃家"},
   {vicinity_name: "JQ CARD エポスカウンター"},
  ]
)

VicinityPark.create!(
  [
    {vicinity_id: 1,park_id: 1},
    {vicinity_id: 2,park_id: 1},
    {vicinity_id: 3,park_id: 3},
    {vicinity_id: 4,park_id: 2},
    {vicinity_id: 5,park_id: 2},
    {vicinity_id: 6,park_id: 2},
    {vicinity_id: 7,park_id: 2},
    {vicinity_id: 8,park_id: 2},
    {vicinity_id: 9,park_id: 2},
    {vicinity_id: 10,park_id: 2},
    {vicinity_id: 11,park_id: 2},
    {vicinity_id: 12,park_id: 2},
    {vicinity_id: 13,park_id: 2},
  ]
)

Comment.create!(
  [
    {comment: "この駐車場めっちゃ便利ですね！",customer_id: 1,park_id: 2},
    {comment: "場所ちょっとわかりづらいですね",customer_id: 2,park_id: 2},
    {comment: "博多駅行く時重宝してます！",customer_id: 3,park_id: 2},
    {comment: "停めやすい！！",customer_id: 2,park_id: 2},
    {comment: "駐車料金変わってましたよー！",customer_id: 1,park_id: 2},
    {comment: "ここはおすすめですね！！",customer_id: 3,park_id: 2},
    {comment: "５台くらいしか止めれないです。。。",customer_id: 2,park_id: 1},
    {comment: "狭すぎーーーー",customer_id: 3,park_id: 1},
    {comment: "狭いけど利便性は最高！！",customer_id: 1,park_id: 1},
    {comment: "ここって場所わかりやすいですか？",customer_id: 2,park_id: 1},
    {comment: "わかりやすいですよ！横通ればすぐわかると思います",customer_id: 3,park_id: 1},
    {comment: "ありがとうがざいます！",customer_id: 2,park_id: 1},
    {comment: "アンパンマンミュージアム行く時便利ですよ！",customer_id: 1,park_id: 3},
    {comment: "アンパンミュージアム行かない、、、、",customer_id: 2,park_id: 3},
    {comment: "確かに笑",customer_id: 1,park_id: 3},
    {comment: "バイク乗りでアンパンマンミュージアム行く人いる？。。。。笑",customer_id: 3,park_id: 3},
    {comment: "絶対おらん、、、笑",customer_id: 1,park_id: 3},
    {comment: "ここって治安どんなですか？",customer_id: 2,park_id: 3},
  ]
)

Favorite.create!(
  [
    {customer_id: 1,park_id: 2},
    {customer_id: 2,park_id: 3},
    {customer_id: 3,park_id: 1},
  ]
)

Notification.create!(
  [
    {visitor_id: 1,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 3,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 1,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 3,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 3,visited_id: 2,park_id: 2,action: "like"},
    {visitor_id: 1,visited_id: 2,park_id: 2,action: "like"},
    {visitor_id: 1,visited_id: 2,action: "follow"},
    {visitor_id: 3,visited_id: 2,action: "follow"},

    {visitor_id: 1,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 2,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 3,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 2,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 1,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 3,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    
    {visitor_id: 1,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 2,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 3,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 2,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 1,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
    {visitor_id: 3,visited_id: 2,park_id: 1,comment_id: 3,action: "comment"},
  ]
)