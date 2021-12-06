-- curl https://nim-lang.org/choosenim/init.sh -sSf | sh
-- add ~/.nimble/bin to $PATH
-- nimble install nimlsp

require'lspconfig'.nimls.setup{}
