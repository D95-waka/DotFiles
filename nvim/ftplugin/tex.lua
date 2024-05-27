---@diagnostic disable-next-line: lowercase-global
function handleOverlineInsert()
	print("overline: ")
	local chr = vim.fn.nr2char(vim.fn.getchar())
	vim.api.nvim_put({"\\overline{" .. chr .. "}"}, "b", false, true)
	print()
end

---@diagnostic disable-next-line: lowercase-global
function handleInsert(cmd)
	print(cmd .. ": ")
	local chr = vim.fn.nr2char(vim.fn.getchar())
	vim.api.nvim_put({"\\" .. cmd .. "{" .. chr .. "}"}, "b", false, true)
	print()
end

vim.keymap.set("i", "<M-1>", "\\section{")
vim.keymap.set("i", "<M-2>", "\\subsection{")
vim.keymap.set("i", "<M-3>", "\\subsubsection{")

vim.keymap.set("i", "<M-lt>", "\\langle ")
vim.keymap.set("i", "<M->>", "\\rangle")
vim.keymap.set("i", "<M-v>", "\\lVert ")

vim.keymap.set("i", "<M-m>", "$")
vim.keymap.set("i", "<M-0>", "\\circ")
vim.keymap.set("i", "<M-.>", "\\cdot")
vim.keymap.set("i", "<C-CR>", "\\\\*<CR>")
vim.keymap.set("i", "<M-f>", "\\varphi")

vim.keymap.set("i", "<M-->", "<Cmd>lua handleInsert(\"overline\")<CR>")
vim.keymap.set("i", "<M-`>", "<Cmd>lua handleInsert(\"tilde\")<CR>")
vim.keymap.set("i", "<M-^>", "<Cmd>lua handleInsert(\"hat\")<CR>")
