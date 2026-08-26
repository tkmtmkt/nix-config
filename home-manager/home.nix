{ config, pkgs, ... }:

let
  # 以下の設定を有効にするためnix実行時に--impureオプションを指定すること。
  # --impureオプションを指定しないとgetEnvはブランクを返す。
  username = builtins.getEnv "USER";
  homeDirectory = "/home/${username}";
in
{
  # ホームマネージャーは、あなたに関する情報と、管理すべきパスに関する情報を
  # 必要とします。
  home.username = "${username}";
  home.homeDirectory = "${homeDirectory}";

  # この値は、お使いの構成が互換性を持つ Home Manager のリリースバージョンを
  # 決定します。これにより、新しい Home Manager リリースで後方互換性のない
  # 変更が導入された場合でも、互換性の問題が発生するのを防ぐことができます。
  #
  # Home Manager をアップデートする場合でも、この値を変更しないでください。
  # もし値を変更したい場合は、必ず Home Manager のリリースノートを確認して
  # ください。
  home.stateVersion = "26.05"; # 変更する前にコメントをお読みください。

  # home.packages オプションを使用すると、Nix パッケージを環境にインストール
  # できます。
  home.packages = with pkgs; [
    # # 環境に「hello」コマンドを追加します。実行すると、親しみやすい
    # # 「Hello, world!」というメッセージが表示されます。
    # pkgs.hello

    # # パッケージを微調整したい場合、例えばオーバーライドを適用すると便利なこと
    # # があります。ここで直接設定できますが、括弧を忘れないようにしてください。
    # # 例えば、Nerd Fontsを限られた数のフォントでインストールしたい場合などです。
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # 設定ファイル内に簡単なシェルスクリプトを直接作成することもできます。
    # # 例えば、以下のコードは「my-hello」というコマンドを環境に追加します。
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # 代替コマンド
    bottom              # 代替コマンド: top
    btop                # 代替コマンド: top
    duf                 # 代替コマンド: df
    dust                # 代替コマンド: du
    fd                  # 代替コマンド: find
    hexyl               # 代替コマンド: od
    hyperfine           # 代替コマンド: time
    procs               # 代替コマンド: ps
    tldr                # 代替コマンド: man
    # 開発用ツール
    devbox              # 開発環境構築ツール
    dvc                 # データバージョン管理ツール
    git                 # バージョン管理ツール
    httpie              # httpクライアント
    uv                  # Pythonパッケージ管理ツール
    # ドキュメント用ツール
    pandoc              # 汎用ドキュメント相互変換ツール
    zensical            # 高速Webドキュメント作成ツール
    # その他ツール
    bc                  # 計算機
    byobu               # ターミナルマルチプレクサ
    fio                 # ディスク性能テストツール
    jq                  # JSONデータ処理ツール
    libxml2             # XMLファイルの解析、整形、検証ツール
    lnav                # ログビューア
    nkf                 # 文字コード変換ツール
    p7zip               # ファイルアーカイバ
    parallel            # 並列実行コマンド
    powershell          # PowerShell
    pwgen               # ランダムなパスワードを生成するコマンド
    tig                 # ターミナル上でgit操作を行うためのCUIツール
    tmux                # ターミナルエミュレータ
    tree                # ディレクトリ構造表示ツール
  ];

  # Home Managerはドットファイルの管理に非常に優れています。
  # プレーンファイルを管理する主な方法は「home.file」を使用することです。
  home.file = {
    # # この設定をビルドすると、Nixストアに「dotfiles/screenrc」のコピーが作成
    # # されます。設定を有効化すると、「~/.screenrc」はNixストアに作成された
    # # コピーへのシンボリックリンクになります。
    # ".screenrc".source = dotfiles/screenrc;

    # # ファイルの内容は即座に設定することもできます。
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

  };

  # ~/.configに配置するファイルを設定する。
  xdg.configFile = {
    "git/config".force = true;
    "git/config".source = dotfiles/_config/git/config;
    "git/exclude".force = true;
    "git/exclude".source = dotfiles/_config/git/exclude;
    "tig/config".force = true;
    "tig/config".source = dotfiles/_config/tig/config;
    "tmux/tmux.conf".force = true;
    "tmux/tmux.conf".source = dotfiles/_config/tmux/tmux.conf;
  };

  # Home Manager は、環境変数を 'home.sessionVariables' を通じて管理することも
  # できます。これらの変数は、Home Manager が提供するシェルを使用する際に
  # 明示的に読み込まれます。Home Manager を介してシェルを管理したくない場合は、
  # 以下の場所にある 'hm-session-vars.sh' を手動で読み込む必要があります。
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/${USER}/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
  };

  # programs.<name>に指定するプログラムの設定については、以下のURLにある
  # Nixソースコードを参照してください。
  # https://github.com/nix-community/home-manager/tree/master/modules/programs

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./programs/bash/bash.nix
    # 代替コマンド
    ./programs/bat.nix                  # 代替コマンド: cat,less
    ./programs/delta.nix                # 代替コマンド: diff
    ./programs/eza.nix                  # 代替コマンド: ls
    ./programs/ripgrep.nix              # 代替コマンド: grep
    # 開発用ツール
    ./programs/direnv.nix               # direnvのシェル統合設定
    ./programs/jujutsu.nix              # バージョン管理ツール
    # その他ツール
    ./programs/fzf.nix                  # 曖昧検索（ファジーファインダー）ツール
    ./programs/gpg.nix                  # 暗号化・電子署名ツール
    ./programs/lazygit.nix              # ターミナル上で動作する高速・軽量なGitクライアント（TUI）
    ./programs/vim/vim.nix              # Vim設定
    ./programs/yazi.nix                 # ファイルマネージャ
    ./programs/zoxide.nix               # zoxideのシェル統合設定
  ];
}
