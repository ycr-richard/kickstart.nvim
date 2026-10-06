# 我的 Kickstart 自訂設定

依據 Git 提交 `fdf382f` 與其前一版 `16dd8f5` 的差異整理。
整理時工作目錄沒有未提交的改動；`lua/custom/plugins/init.lua` 原本是空的。

## 設定放在哪裡

| 設定 | 檔案 |
| --- | --- |
| 搜尋預設忽略大小寫，包含大寫字母時區分大小寫 | `lua/custom/options.lua` |
| 安裝並啟用 C/C++ 的 `clangd`、Python 的 `pyright` | `lua/custom/plugins/languages.lua` |
| Python 格式化依序使用 `isort`、`black` | `lua/custom/plugins/languages.lua` |
| 插入模式自動補括號、引號 | `lua/custom/plugins/autopairs.lua` |
| C 使用 8 格 Tab、保留 Tab 字元、啟用 `cindent` | `ftplugin/c.vim` |
| LLVM 基底、8 格 Tab、Linux 大括號、80 字元行寬 | `ftplugin/.clang-format` |

`languages.lua` 透過 Lazy 合併外掛設定，保留 Kickstart 原本的 LSP 設定與快捷鍵。
語言伺服器改由 mason-lspconfig 安裝；Python 格式化工具仍需自行安裝，
例如在 `:Mason` 中安裝 `isort` 與 `black`。原本設定並沒有自動安裝這兩個工具。

## 更新 Kickstart 後

保留 `lua/custom/` 和 `ftplugin/`，並確認 `init.lua` 的
`require('lazy').setup({ ... })` 外掛清單末尾有這一行：

```lua
{ import = 'custom.plugins' },
```

這就是目前唯一需要保留的 `init.lua` 自訂改動。不要把這行放在
外掛清單之外，也不需要另外 `require` `languages.lua` 或 `autopairs.lua`。
新增外掛可放在 `lua/custom/plugins/`；檔案需回傳 Lazy 的外掛規格。
`ftplugin/c.vim` 會由 Neovim 自動載入，不需要額外引用。
一般編輯器選項可放在 `lua/custom/options.lua`；目前由
`lua/custom/plugins/init.lua` 載入，因此仍只需要上述一行匯入。

使用 Git 合併 upstream 更新可以保留自己的新增檔案；若要重新下載或整份取代
設定目錄，請先備份上述目錄，再還原並補上匯入行。
此拆分以現有 Kickstart 的 API 為基礎；上游若改用不同的 LSP 或外掛管理方式，
仍需檢查相容性。

## C 格式化檔案的位置

保留原本的 `ftplugin/.clang-format`，但一般 clang-format / clangd
會從被編輯的原始碼所在目錄往上尋找 `.clang-format`，並不會自動讀取
Neovim 的 `ftplugin/` 目錄。要讓其他專案使用此樣式，請將這份檔案複製到
該專案根目錄。原本也沒有啟用 C/C++ 的儲存時自動格式化。

`ftplugin/c.vim` 只設定 C；沒有新增 C++ 的縮排規則。

## Git 備份

Neovim 設定直接由目前的 Kickstart fork 管理，不需要複製到另一份儲存庫。
修改設定後，在 `~/.config/nvim` 目錄確認變動並提交：

```sh
git diff
git add -A
git commit -m "Update personal Neovim configuration"
git push origin master
```

更新 Kickstart 前先提交自己的改動，再執行：

```sh
git fetch upstream
git merge upstream/lazy
```

目前使用上游保留 Lazy 的 `lazy` 分支；`upstream/master` 已改用
`vim.pack`，若要切換需一併遷移自訂外掛設定。

若有衝突，整理衝突檔案後用 `git add` 和 `git commit` 完成合併；
也可用 `git merge --abort` 取消此次合併。確認 Neovim 正常後，
執行 `git push origin master`。Bash 設定另行管理。
