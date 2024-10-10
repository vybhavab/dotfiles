local wezterm = require 'wezterm';
local sessionizer = require("sessionizer")
local act = wezterm.action

local config = wezterm.config_builder();

config.color_scheme = 'Tokyo Night (Gogh)';

-- config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  {
    key = 'a',
    mods = 'CTRL',
    action = wezterm.action.ActivateKeyTable {
      name = 'mux',
      one_shot = false,
      timeout_milliseconds = 1000,
    },
  },
  { key = "d", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
  { key = "f", mods = "CTRL", action = wezterm.action_callback(sessionizer.open) },
  { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action_callback(function(win, pane)
      win:perform_action(act.ActivatePaneDirection("Left"), pane)
    end)
  },
  { key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action_callback(function(win, pane)
      win:perform_action(act.ActivatePaneDirection("Down"), pane)
    end)
  },
  { key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action_callback(function(win, pane)
      win:perform_action(act.ActivatePaneDirection("Up"), pane)
    end)
  },
  { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action_callback(function(win, pane)
      win:perform_action(act.ActivatePaneDirection("Right"), pane)
    end)
  },
}

config.key_tables = {
  mux = {
    { key = 'd', mods = 'CTRL', action = wezterm.action.ScrollByPage(0.5) },
    { key = 'u', mods = 'CTRL', action = wezterm.action.ScrollByPage(-0.5) },
    { key = 'h', mods = 'CTRL', action = wezterm.action_callback(function(win, pane)
        win:perform_action(act.ActivateTabRelative(-1), pane)
        win:perform_action(act.PopKeyTable, pane)
      end)
    },
    { key = 'l', mods = 'CTRL', action = wezterm.action_callback(function(win, pane)
        win:perform_action(act.ActivateTabRelative(1), pane)
        win:perform_action(act.PopKeyTable, pane)
      end)
    },
    {
      key = 'a',
      mods = 'LEADER|CTRL',
      action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
    },
    { key = "-", mods = '', action = wezterm.action_callback(function(win, pane)
        win:perform_action(act.SplitVertical({ domain = 'CurrentPaneDomain' }), pane)
        win:perform_action(act.PopKeyTable, pane)
      end)
    },
    { key = "'", mods = '', action = wezterm.action_callback(function(win, pane)
        win:perform_action(act.SplitHorizontal({ domain = 'CurrentPaneDomain' }), pane)
        win:perform_action(act.PopKeyTable, pane)
      end)
    },
    { key = 'w', mods = '', action = wezterm.action_callback(function(win, pane)
        win:perform_action(act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }), pane)
        win:perform_action(act.PopKeyTable, pane)
      end)
    },
    { key = 'Escape', action = 'PopKeyTable' },
  }
}

return config;
