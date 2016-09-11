# uecda-server-alpine

## 概要
UECコンピュータ大貧民大会のサーバープログラムをAlpine Linux上に配備したものです.
本大会に興味を持った方が, とりあえずローカル環境で対戦プログラムを動かしてみることを,
気軽に試せる環境を提供することを目的としています.

## イメージの入手方法
### Docker Hubからビルド済みイメージを取得する場合
```
docker pull akimateras/uecda-server-alpine
```

### GitHubからソースを取得して自分でビルドする場合
Gitがインストールされている必要があります.
```
git clone https://github.com/akimateras/uecda-server-alpine.git
docker build -t akimateras/uecda-server-alpine uecda-server-alpine
```

Windowsの場合, ビルドしたイメージの実行時に, 下記のエラーが出る場合があります.
```
standard_init_linux.go:175: exec user process caused "no such file or directory"
```
これは, Gitが自動的に改行コードをWindows形式に変換しているために発生します.
```
git config --global core.autoCRLF false
```
を実行するなどして自動変換を無効化し, `git clone`からやり直してください.

## 起動方法
```
docker run -it --rm --name uecda-server -p 42485:42485 akimateras/uecda-server-alpine
```

コンソールに下記のような出力が現れれば起動は成功です.
```
WINDOW_TYPE     =       CONSOLE
GRAPH_WINDOW    =       NO
RAND_TYPE       =       1
RULE_KAKUMEI    =       YES
RULE_SHIBARI    =       YES
RULE_KINSOKU    =       NO
RULE_KAIDAN     =       YES
RULE_CHANGE     =       YES
RULE_5TOBI      =       NO
RULE_6REVERS    =       NO
RULE_8GIRI      =       YES
RULE_11BACK     =       NO
RULE_SEKIGAE    =       YES
RULE_SEKIGAE_NUM        =       3
GAME_NUMBER     =       1000
FLASH_MIBUN_NUMBER      =       100
GAME_PORT       =       42485
now waiting 0
```
この状態は, ポート42485でクライアントプログラムを待ち受けており,
5つのクライアントと接続を確立した時点で対戦が始まります.

## 停止方法
サーバープログラムのコンテナは, 対戦開始後, すべての対戦が終了すると自動的に停止します.
対戦開始前または対戦進行中に強制的に停止させる場合は, 下記コマンドを実行してください.
```
docker stop uecda-server
```

## サーバー設定の変更
ゲームサーバーの設定をデフォルト値から変更したい場合は,
`docker run`の`-e`オプションで上書きしたい設定値を与えてください.

例えば, 試合数を示す`GAME_NUMBER`の設定を変更したい場合は,
`docker run`のオプションに`-e GAME_NUMBER=100`を追加し,
```
docker run -it --rm --name uecda-server -p 42485:42485 -e GAME_NUMBER=100 akimateras/uecda-server-alpine
```
のようにして起動します.

起動時のログでは
```
WINDOW_TYPE     =       CONSOLE
GRAPH_WINDOW    =       NO
RAND_TYPE       =       1
RULE_KAKUMEI    =       YES
RULE_SHIBARI    =       YES
RULE_KINSOKU    =       NO
RULE_KAIDAN     =       YES
RULE_CHANGE     =       YES
RULE_5TOBI      =       NO
RULE_6REVERS    =       NO
RULE_8GIRI      =       YES
RULE_11BACK     =       NO
RULE_SEKIGAE    =       YES
RULE_SEKIGAE_NUM        =       3
GAME_NUMBER     =       100
FLASH_MIBUN_NUMBER      =       100
GAME_PORT       =       42485
now waiting 0
```
と表示され, `GAME_NUMBER`がデフォルトの`1000`から`100`へと変更されたことが確認できます.
設定に関する詳細は, UECコンピュータ大貧民大会のWEBページを参照してください.

## ディスプレイの設定
UECdaサーバープログラムは, デフォルトではコンソールモードとして起動しますが,
お手持ちの環境にX11サーバーがある場合, グラフィカルウィンドウモードが使用可能です.

例えば, `192.168.11.2:0.0`でX11が起動しているとき,
`docker run`のオプションに`-e DISPLAY=192.168.11.2:0.0`を追加し,
```
docker run -it --rm --name uecda-server -p 42485:42485 -e DISPLAY=192.168.11.2:0.0 akimateras/uecda-server-alpine
```
のようにして起動すると, X11サーバーにGUIの画面を転送しながらUECdaサーバープログラムが実行されます.
