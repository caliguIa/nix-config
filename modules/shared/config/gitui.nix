{ ... }: {
  enable = true;
  keyConfig = ''
    (
        open_help: Some(( code: F(1), modifiers: "")),

        move_left: Some(( code: Char('h'), modifiers: "")),
        move_right: Some(( code: Char('l'), modifiers: "")),
        move_up: Some(( code: Char('k'), modifiers: "")),
        move_down: Some(( code: Char('j'), modifiers: "")),

        popup_up: Some(( code: Char('p'), modifiers: "CONTROL")),
        popup_down: Some(( code: Char('n'), modifiers: "CONTROL")),
        page_up: Some(( code: Char('b'), modifiers: "CONTROL")),
        page_down: Some(( code: Char('f'), modifiers: "CONTROL")),
        home: Some(( code: Char('g'), modifiers: "")),
        end: Some(( code: Char('G'), modifiers: "SHIFT")),
        shift_up: Some(( code: Char('K'), modifiers: "SHIFT")),
        shift_down: Some(( code: Char('J'), modifiers: "SHIFT")),

        edit_file: Some(( code: Char('I'), modifiers: "SHIFT")),

        status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),

        diff_reset_lines: Some(( code: Char('u'), modifiers: "")),
        diff_stage_lines: Some(( code: Char('s'), modifiers: "")),

        stashing_save: Some(( code: Char('w'), modifiers: "")),
        stashing_toggle_index: Some(( code: Char('m'), modifiers: "")),

        stash_open: Some(( code: Char('l'), modifiers: "")),

        abort_merge: Some(( code: Char('M'), modifiers: "SHIFT")),
    )
  '';
  theme = ''
    (
      selected_tab: Some(Rgb(187,154,247)), // magenta #bb9af7
      command_fg: Some(Rgb(86,95,137)), // comment #565f89
      selection_bg: Some(Rgb(41,46,66)), // bg_highlight #292e42
      selection_fg: Some(Rgb(125,207,255)), // cyan #7dcfff
      cmdbar_bg: Some(Rgb(26,27,38)), // bg #1a1b26
      cmdbar_extra_lines_bg: Some(Rgb(26,27,38)), // bg #1a1b26
      disabled_fg: Some(Rgb(86,95,137)), // comment #565f89
      diff_line_add: Some(Rgb(158,206,106)), // green #9ece6a
      diff_line_delete: Some(Rgb(247,118,142)), // red #f7768e
      diff_file_added: Some(Rgb(115,218,202)), // green1 #73daca
      diff_file_removed: Some(Rgb(219,75,75)), // red1 #db4b4b
      diff_file_moved: Some(Rgb(255,0,124)), // magenta2 #ff007c
      diff_file_modified: Some(Rgb(224,175,104)), // yellow #e0af68
      commit_hash: Some(Rgb(187,154,247)), // magenta #bb9af7
      commit_time: Some(Rgb(26,188,156)), // teal #1abc9c
      commit_author: Some(Rgb(158,206,106)), // green #9ece6a
      danger_fg: Some(Rgb(247,118,142)), // red #f7768e
      push_gauge_bg: Some(Rgb(26,27,38)), // bg #1a1b26
      push_gauge_fg: Some(Rgb(192,202,245)), // fg #c0caf5
      tag_fg: Some(Rgb(255,0,124)), // magenta2 #ff007c
      branch_fg: Some(Rgb(224,175,104)), // yellow #e0af68
    )
  '';
}
