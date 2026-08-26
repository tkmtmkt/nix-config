{ pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;

    # 必要に応じて使用するパッケージを指定（デフォルトは pkgs.jujutsu）
    package = pkgs.jujutsu;

    # jujutsuの各種設定（TOMLと同等の構造をNix属性セットで記述）
    settings = {
      # エイリアスの設定例
      aliases = {
        l = [ "log" "--no-pager" "--limit" "10" ];
      };

      # デフォルトのエディタやUI設定
      ui = {
        editor = "vim";
      };
    };
  };
}
