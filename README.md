# 概要

Sinatraを使った簡単なメモアプリです。「メモ一覧の表示」「新規登録」「編集」「削除」の機能が用意されています。

# 使い方

### 1.任意のディレクトリにリポジトリのクローンを保存する

```
$ git clone https://github.com/hirano-vm4/Sinatra_memo
```

### 2.リポジトリに移動します

```
$ cd Sinatra_memo
```

### 3.必要なGemをインストールします

```
$ bundle install
```
# ローカル環境にメモ保存用のデータベースを作成する

### 1.PostgreSQLの任意のユーザーにログインする
```
$ psql -U ユーザー名
```

### 2.`simple_memo`という名前のデータベースを作成する
```
ユーザー名=# CREATE DATABASE simple_memo;
```

### 3.`simple_memo`データベースにアクセスし、テーブルを作成する
```
CREATE TABLE memos
(id  serial NOT NULL,
title text NOT NULL,
content text NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id)); 
```

# アプリを実行する

### 1.アプリを起動します

```
$ ruby memo_app.rb
```
### 2.ブラウザで表示する

ブラウザで`http://localhost:4567`にアクセスして表示を確認する
