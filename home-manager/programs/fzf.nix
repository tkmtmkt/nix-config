{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;

    # fzfのデフォルトオプション
    defaultOptions = [
      "--height 20%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    ];

    # コマンドのエイリアス設定
    changeDirWidget.command = "fd --type d";
    fileWidget.command = "fd --type f";
  };
}
