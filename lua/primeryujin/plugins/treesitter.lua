return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local parsers = {
        "c",
        "cpp",
        "lua",
        "vim",
        "html",
        "vimdoc",
        "query",
        "python",
        "go",
        "rust",
        "javascript",
        "typescript",
        "tsx",
        "css",
        "bash",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
      }

      local install_dir = vim.fn.stdpath("data") .. "/site"

      require("nvim-treesitter").setup({
        install_dir = install_dir,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
          disable = function(lang, buf)
            if not buf or buf == 0 then
              return false
            end
            local name = vim.api.nvim_buf_get_name(buf)
            if name == "" then
              return false
            end
            local ok, stats = pcall(vim.loop.fs_stat, name)
            if ok and stats and stats.size > 100 * 1024 then
              vim.notify(
                "File larger than 100KB — treesitter disabled for performance",
                vim.log.levels.WARN,
                { title = "Treesitter" }
              )
              return true
            end
            return false
          end,
        },
        indent = {
          enable = false,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<leader><C-space>",
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
          },
        },
      })

      local ts = require("nvim-treesitter")
      ts.install(parsers)

      -- Starting parser per FT
      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },

  {
    "Glench/Vim-Jinja2-Syntax",
    ft = { "htmldjango", "jinja", "jinja.html", "html" },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable = true,
      multiwindow = false,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
      on_attach = nil,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      vim.cmd("highlight! link TreesitterContext ColorColumn")
      vim.cmd("highlight! link TreesitterContextLineNumber ColorColumn")
      vim.keymap.set("n", "<leader>tc", function()
        require("treesitter-context").toggle()
      end, { desc = "Toggle Treesitter Context" })
    end,
  },

  -- autotag (unchanged)
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    opts = {},
  },

  -- keep your jinja syntax plugin as-is
  {
    "Glench/Vim-Jinja2-Syntax",
    ft = { "htmldjango", "jinja", "jinja.html", "html" },
  },
}
