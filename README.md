# dotconfig

## 概要
このリポジトリは、NixエコシステムのツールであるHome Managerを利用して、
ユーザ環境（パッケージおよび各種設定）を宣言的に管理するための構成をまとめたものです。

シェル、エディタ、Gitなどの設定をモジュール単位で分割し、`home.nix`からインポートする
構成を採用しています。
これにより、設定の再利用性と可読性を高めつつ、環境の再現性を確保しています。

## 背景
従来のdotfiles管理では、以下のような課題がありました：

* 環境構築手順が手動になりがちで再現性が低い
* パッケージ管理と設定管理が分離している
* 複数マシン間での同期が煩雑

これらの課題を解決するため、NixおよびHome Managerを採用し、環境構築をコードとして管理する方針に移行しました。

また、設定を機能ごとに分割することで、以下のメリットを得ています：

* 設定の見通しが良くなる
* 必要なモジュールのみを選択して利用できる
* 将来的な構成拡張が容易

## 技術スタック
以下のツールを使用しています。

* nix
* home-manager

## セットアップ
リポジトリをクローンします：

```sh
git clone git@github.com:tkmtmkt/dotconfig.git ~/.config
cd ~/.config/home-manager
```

NixをインストールしてHome Managerを適用します：

```sh
home-manager/bin/setup.sh
```

セットアップをやり直す場合：

```sh
rm -rf ~/.local/state/nix
home-manager/bin/setup.sh
```

## 使い方

### カスタマイズ

* パッケージの追加：`home.nix` または該当モジュール内の `home.packages`
* 各種設定の変更：対応するモジュールファイルを編集

変更後は以下を実行して反映します：

```bash
home-manager/bin/home-manager-switch.sh
```

### アップデート

```sh
# Nixパッケージ更新
home-manager/bin/nix-flake-update.sh
```

## 補足

### リポジトリ内容
```
${HOME}
|-- .config/
|   |-- home-manager/
|   |   |-- bin/
|   |   |   |-- home-manager-switch.sh*
|   |   |   |-- make-archive.sh*
|   |   |   |-- nix-flake-update.sh*
|   |   |   |-- nix-store-gc.sh*
|   |   |   `-- setup.sh*
|   |   |-- dotfiles/
|   |   |   `-- *****           # アプリケーション設定ファイルを配置
|   |   |-- programs/
|   |   |   `-- *****           # アプリケーション毎の設定用Nixファイルを配置
|   |   |-- flake.lock
|   |   |-- flake.nix
|   |   `-- home.nix
|   |-- nix/
|   |   `-- nix.conf            # Nix設定ファイル
|   |-- .gitignore
|   `-- README.md
```

* `home.nix`
  エントリーポイントとなる設定ファイル。各モジュールを`imports`で読み込みます。
* `programs/*.nix`
  アプリケーションや用途ごとの設定ファイルです。パッケージ単位で分割しています。

### 実行環境のファイル構成
```
${HOME}
|-- .config/
|   `-- nix/
|       `-- nix.conf
|-- .local/
|   `-- state/
|       `-- nix/
|           `-- profiles/
|               |-- channels -> channels-1-link/
|               |-- channels-1-link -> /nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-user-environment/
|               |-- profile -> profile-1-link/
|               `-- profile-1-link -> /nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-user-environment/
|-- .nix-defexpr/
|   |-- channels -> ${HOME}/.local/state/nix/profiles/channels/
|   `-- channels_root -> /nix/var/nix/profiles/per-user/root/channels
|-- .nix-profile -> ${HOME}/.local/state/nix/profiles/profile/
|   |-- bin/
|   |-- etc/
|   |-- lib/
|   |-- libexec/
|   |-- sbin/
|   `-- share/
`-- .nix-channels
```

### Nix操作
```sh
# Nixインストール
sudo mkdir -p -m 0755 /nix
sudo chown ${USER}:${USER} /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Nixを更新する
# nix upgrade-nix
# ※これは使えない。以下のエラーで失敗する。成功した場合はバージョンが古いものになる。
# error: directory "xxxx profile" is managed by 'nix profile' and currently cannot be upgraded by 'nix upgrade-nix'
rm -rf ~/.local/state/nix
home-manager/bin/setup.sh

# パッケージ一覧
nix profile list

# パッケージ名を検索する
nix search nixpkgs#パッケージ名 ^

# パッケージを追加する
nix profile add nixpkgs#パッケージ名

# パッケージを更新する
nix profile upgrade パッケージ名

# パッケージを削除する
nix profile remove パッケージ名

# Nixストアのガベージコレクション
nix store gc

# 古い世代や不要なパッケージを削除する
nix-collect-garbage --delete-old
```

## 参考
- [Nix Home Manager のつまづき石をまとめる ||| Apribase](https://apribase.net/2023/08/22/nix-home-manager-qa/)
