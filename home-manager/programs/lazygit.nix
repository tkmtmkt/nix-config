{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    enableBashIntegration = true;

    # 共通設定 (config.yml に反映される内容)
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        # customArgs 等ではなく外部ディフレンダラーを設定する場合
        diffRenderers = [
          {
            type = "stdinFilter";
            command = "delta --color-only"; # command の明示が必須
          }
        ];
        # コミットメッセージの表示などに使用する設定
        useConfig = true;
      };
      gui = {
        # Nerd Font前提の表示を有効化
        nerdFontsVersion = "3"; # 最近のNerd Fontsはv3系
        showIcons = true;
        showFileTree = true;
        theme = {
          activeBorderColor = [ "cyan" "bold" ];
          inactiveBorderColor = [ "white" ];
        };
      };
    };
  };
}
