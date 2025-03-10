;;; workspace.el -*- lexical-binding: t; -*-

(when (modulep! :ui workspaces)
  (after! persp-mode
    ;; this call is to make +workspace--tabline available
    (+workspace/display)

    ;; but we don't want +workspace/display to show up when hydra is activated
    (defun +workspace/display ()
      "Overriden +workspace/display"
      t)

    (defhydra hydra-workspace (:hint nil :color blue)
      "
 ^^--------------------------------  ^^--------------------------------  ^^-------------------------------- ^^--------------------------------
 _<tab>_: Switch to last workspace   _._: Switch workspace               _n_: New workspace                 _{_: Move to the left
 _l_:     Load workspace from file   _s_: Save workspace to file         _r_: Rename workspace              _}_: Move to the right
 _d_:     Delete this workspace      _x_: Delete session                 _R_: Restore last session
 _0_:     Switch to final workspace  _[_: Previous workspace             _]_: Next workspace

%s(+workspace--tabline)
"
      ("<tab>" +workspace/other)
      ("." +workspace/switch-to)
      ("n" +workspace/new)
      ("l" +workspace/load)
      ("s" +workspace/save)
      ("x" +workspace/kill-session)
      ("d" +workspace/delete)
      ("r" +workspace/rename)
      ("R" +workspace/restore-last-session)
      ("0" +workspace/switch-to-final)
      ("1" +workspace/switch-to-0)
      ("2" +workspace/switch-to-1)
      ("3" +workspace/switch-to-2)
      ("4" +workspace/switch-to-3)
      ("5" +workspace/switch-to-4)
      ("6" +workspace/switch-to-5)
      ("7" +workspace/switch-to-6)
      ("8" +workspace/switch-to-7)
      ("9" +workspace/switch-to-8)
      ("[" +workspace/switch-left :color pink)
      ("]" +workspace/switch-right :color pink)
      ("{" +workspace/swap-left :color pink)
      ("}" +workspace/swap-right :color pink))

    (map! :leader
          :desc "workspace" "TAB" #'hydra-workspace/body)))
