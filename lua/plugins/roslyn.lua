return {
  -- ============================================================================
  -- ROSLYN.NVIM: LSP oficial de Microsoft para C# (reemplaza OmniSharp)
  -- Descarga automáticamente Microsoft.CodeAnalysis.LanguageServer via dotnet
  -- Primera vez: puede tardar 30s descargando el binario (~200MB)
  -- Requiere: dotnet SDK instalado (confirmado en /opt/homebrew/bin/dotnet)
  -- ============================================================================
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("roslyn").setup({
        config = {
          -- on_attach y capabilities vienen del vim.lsp.config('*') global en lsp.lua
          settings = {
            ["csharp|inlay_hints"] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ["csharp|code_lens"] = {
              dotnet_enable_references_code_lens = true,
            },
          },
        },
      })
    end,
  },
}
