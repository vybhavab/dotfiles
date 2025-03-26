return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      -- provider = "openai",
      -- auto_suggestions_provider = "openai", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
      -- openai = {
      --   endpoint = "https://api.groq.com/openai/v1",
      --   model = "deepseek-r1-distill-llama-70b",
      --   timeout = 30000, -- Timeout in milliseconds
      --   temperature = 0,
      --   max_tokens = 128000,
      --   api_key_name = "GROQ_API_KEY",
      -- },
      -- dual_boost = {
      --   enabled = true,
      --   first_provider = "claude",
      --   second_provider = "ollama",
      --   prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
      --   timeout = 60000, -- Timeout in milliseconds
      -- },
      -- provider = "openai",
      -- openai = {
      --   endpoint = "https://api.openai.com/v1",
      --   model = "gpt-4o",
      --   timeout = 30000,
      --   temperature = 0,
      --   max_tokens = 4096,
      --   reasoning_effort = "high" -- only supported for "o" models
      -- },
      claude = {
        endpoint = "https://api.anthropic.com",
        -- model = "claude-3-5-sonnet-latest",
        temperature = 0,
        max_tokens = 8000,
      },
      cursor_applying_provider = 'groq',
      -- behaviour = {
        -- enable_cursor_planning_mode = true
      -- },
      vendors = {
        ollama = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:11434/v1",
          model = "deepseek-r1",
        },
        groq = {
            __inherited_from = 'openai',
            api_key_name = 'GROQ_API_KEY',
            endpoint = 'https://api.groq.com/openai/v1/',
            model = 'qwen-2.5-coder-32b',
            max_tokens = 8192, -- remember to increase this value, otherwise it will stop generating halfway
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}
