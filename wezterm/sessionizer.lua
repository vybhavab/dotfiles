-- from https://github.com/wez/wezterm/discussions/4796

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local fd = "/opt/homebrew/bin/fd"
local dev = os.getenv("HOME") .. "/projects"
local dotfiles = os.getenv("HOME") .. "/.dotfiles"

M.open = function(window, pane)
	local projects = {}
	local home = os.getenv("HOME") .. "/"


	local success, stdout, stderr = wezterm.run_child_process({
		fd,
		"-HI",
		".git$",
		"--max-depth=4",
		"--prune",
		dev,
    dotfiles
		-- add more paths here
	})

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	-- define variables from from file paths extractions and
	-- fill table with results
	for line in stdout:gmatch("([^\n]*)\n?") do
		-- create label from file path
		local project = line:gsub("/.git.*", "")
		project = project:gsub("/$", "")
		local label = project:gsub(home, "")

		-- extract id. Used for workspace name
		local _, _, id = string.find(project, ".*/(.+)")
		id = id:gsub(".git", "") -- bare repo dirs typically end in .git, remove if so.

		table.insert(projects, { label = tostring(label), id = tostring(id) })
	end

	-- update previous_workspace before changing to new workspace.
	wezterm.GLOBAL.previous_workspace = window:active_workspace()
	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)

				if not id and not label then
          return
        end

        wezterm.log_info("Selected " .. label)

        win:perform_action(
          act.SwitchToWorkspace({
            name = id,
            spawn = { cwd = home .. label },
          }),
          pane
        )
			end),
			fuzzy = true,
			title = "Select project",
			choices = projects,
		}),
		pane
	)
end

return M
