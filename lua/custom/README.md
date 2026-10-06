# 我的 Kickstart 自訂設定

依據 Git 提交 `fdf382f` 與其前一版 `16dd8f5` 的差異整理。
整理時工作目錄沒有未提交的改動；`lua/custom/plugins/init.lua` 原本是空的。

## 設定放在哪裡

| 設定 | 檔案 |
| --- | --- |
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

自訂設定、`ftplugin/` 與 `lazy-lock.json` 都納入此儲存庫。
`backups/bash/.bashrc` 是 `~/.bashrc` 的備份副本，不會自動同步。
修改 Bash 設定後，在此儲存庫目錄執行：

```sh
cp ~/.bashrc backups/bash/.bashrc
git add -A
git commit -m "Back up personal configuration"
git push origin master
```

還原 Bash 設定前，先另外保存當時的 `~/.bashrc`，再將
`backups/bash/.bashrc` 複製到 `~/.bashrc`。
