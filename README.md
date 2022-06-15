# サイト名：BIKE駐輪場探求

## サイト概要
　*福岡県の駐輪場の場所を共有し合うサイト*
### サイトテーマ
　*駐輪場の場所の共有・情報交換*

#### テーマを選んだ理由
  *福岡市内はバイクを止めれる場所が限られており、GoogleMapで検索すると表示はされるが、いざ行ってみると自転車のみ*
  *原動機付自転車のみな事が多くイラつく事がよくあるため(市外は駐車場が基本的にある為、全国規模でなく福岡市内限定とする)*
  *互いに駐車場の情報を共有するサイトがあれば良いなと思い、実装することとした。*

##### ターゲットユーザ
　*福岡県在住者のバイク乗り。福岡県に観光に来たバイク乗り*

### 主な利用シーン
　*福岡市内にバイクで遊びに行く時*

## 設計書
  https://docs.google.com/spreadsheets/d/17fY6545kklbhIeg9sZU-BxXLAWzvwOg0rjWJNl5iRB4/edit?usp=sharing

## テーブル定義書
　![テーブル定義書](https://user-images.githubusercontent.com/99014620/173570568-8394a07a-3475-4cbb-b214-55e74309d000.jpg)

## UI_FLOW
  　*エンドユーザー*
  　![UI_FLOW](https://user-images.githubusercontent.com/99014620/173735763-ef79b451-f0a4-4007-9c2a-e37c2ee689f6.jpg)

  　*管理者*
　　![UI_FLOW2](https://user-images.githubusercontent.com/99014620/173735846-1add7dc0-d944-443d-ac50-0ef650d2c9b9.jpg)

## ER図
　![BikeParking ER図](https://user-images.githubusercontent.com/99014620/170477455-fdcc4a0c-fb19-45b5-9a58-8359ed3a234f.png)

## アプリケーション詳細設計
　　*会員*
　　![アプリケーション詳細設計１](https://user-images.githubusercontent.com/99014620/173555513-c26cdaf7-1156-4477-9b85-9179eb7aba1f.jpg)

　　*管理者*
　　![アプリケーション詳細設計２](https://user-images.githubusercontent.com/99014620/173556567-afd46584-2258-461b-86c9-270c0a1ba16f.jpg)

## 動作デモ
https://user-images.githubusercontent.com/99014620/173487862-34d561e7-f9b2-434e-9bbd-1b506ac68611.mp4



https://user-images.githubusercontent.com/99014620/173489077-31ddfe28-8148-49d4-b28f-01b1162ee936.mp4


## 開発環境
- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JSライブラリ：jQuery
- IDE：Cloud9
- 外部API :Google Maps JavaScript API,Google Place API,Geocoding API

## 使用素材
- 外部サービス：2.600万点以上の高品質なフリー画像素材(url: https://pixabay.com/ja/)

