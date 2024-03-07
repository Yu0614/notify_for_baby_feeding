
# notify_for_baby_feeding

* 赤ちゃんのミルクあげ通知 & 管理アプリ
  * 1日の授乳を手軽に記録・次の授乳タイミングを通知でお知らせ！
    * 産後の授乳管理・スケジュール管理に困っていた妻のために作成したアプリです。
      * ストア公開予定はありません。 

## 機能一覧
* 授乳の記録機能
  * 作成・更新
  * 一定時間後にpush通知する機能
* 授乳記録の一覧参照機能（1日単位）
* 設定機能
  * 通知の許可
  * 通知のon/off設定
  * アプリバージョン表示
  * 通知間隔の表示

## 画面一覧

| 1日の授乳記録画面 | 設定画面 |
| :-: | :-: |
| <img src='https://i.imgur.com/FjYBQWl.png' height='300'> | <img src='https://i.imgur.com/xmeM0AP.png' height='300'> |
| 1日単位で当日の授乳を記録・確認できる画面です。<br>記録を登録することで、記録した時間から一定時間経過したタイミングで push通知を配信します。 | push通知周りの設定やアプリのバージョンを確認できる画面です。 |


### 1日の授乳記録画面

* ① 灰色背景の帯部分
  *  生後から経過日数と、当日の合算授乳量を表示しています。

* ② 記録入力ボタン
  * 記録を入力する画面が開きます。
    * モーダルボトムシートで提供。
 
* ③ 当日の授乳記録 
  * 当日の授乳記録を表示します。
    * 回数、授乳量、時刻を表示しています
      
* 記録編集
  * 既に入力されている記録を編集します。  

#### 入力・編集周り

* iOSのカレンダーアプリから着想を得て、モーダルボトムシートでモダンな入力要素を提供しています。

| 記録入力 モーダルボトムシート | 記録編集 モーダルボトムシート |
| :-: | :-: | 
| <img src='https://i.imgur.com/7J5T5eN.png' height='300'> | <img src='https://i.imgur.com/UqwLgXo.png' height='300'> |


## アプリアイコン & スプラッシュスクリーン
| アプリアイコン | スプラッシュスクリーン |
| :-: | :-: | 
| <img src='https://i.imgur.com/GzYNDST.jpg' height='300'> | <img src='https://i.imgur.com/2VYSPzx.png' height='300'> |



## 使用技術・ライブラリ

* フレームワーク
  * Flutter
* データベース
  * sqflite
* 設定周り
  * settings_ui
  * shared_preferences
  * flutter_local_notifications
  * package_info_plus
* 記録周り
  * flutter_datetime_picker
  * flutter_week_view
  * freezed 

## ER図


<img src='https://imgur.com/zQrB2A3.png' height='300'>



## 残課題

* 記録の削除機能
* 週間での授乳記録の表示
* ウィジェットでのアプリ導線
* Siriで起動できるように
* DBアクセス周りのコードリファクタ

