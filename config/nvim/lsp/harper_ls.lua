vim.lsp.config["harper_ls"] = {
    settings = {
        ["harper-ls"] = {
            linters = {
                ToDoHyphen = false,
                Dashes = false,
                LongSentences = false,
                SentenceCapitalization = false,
                ExpandDependencies = false,
            },
        },
    },
}
