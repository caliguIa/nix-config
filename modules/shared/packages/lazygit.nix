{ ... }:
{
  enable = true;
  settings = {
    gui = {
      border = "single";
      commitAuthorShortLength = 3;
      showBottomLine = false;
      showRandomTip = false;
      commandLogSize = 6;
      screenMode = "half";
      statusPanelView = "allBranchesLog";
    };
    git = {
      paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never --line-numbers";
      };
    };
    promptToReturnFromSubprocess = false;
    disableStartupPopups = true;
  };
}
