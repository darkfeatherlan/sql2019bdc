# PIXNET 中文教學主線：天翼之鍊 4.04 單機版架設

本文件以 PIXNET 中文教學「天翼之鍊 4.04 版單機板架設」為主線整理。TWPrivate Wiki 與 RaGEZONE 僅作為補充參考與交叉驗證。

## 定位

PIXNET 該篇的價值在於：

- 中文說明，較容易照著排查。
- 聚焦 4.04 單機／私人環境。
- 提到 `tw404j.tar.gz`。
- 提到 Solaris 11 / OpenIndiana / OpenSolaris 類環境。
- 提供較接近可操作的腳本流程，例如：
  - `change-ip`
  - `change-hosts`
  - `twsrv-init`
  - `create-accounts`
  - `start-twsrv`
- 提到需調整 `~/tw404/jtales*/table/Patches.jtales`，讓 4.04 client 可以登入。

## 本機目標架構

```text
Mac mini M1
  -> UTM
  -> x86 Solaris-like guest OS
     可研究方向：Solaris 11 / OpenIndiana / OpenSolaris
  -> tw404j server files, supplied separately by user
  -> Windows PC running 4.04J client
```

## 注意事項

本 repo 不保存：

- `tw404j.tar.gz`
- client 安裝檔
- server binaries
- 遊戲素材
- database dump
- 原文未授權轉載全文

本文件僅整理流程、檢查點與自寫輔助腳本。

## PIXNET 主線流程整理

### 1. 準備 VM

優先研究 Solaris-like x86 系統：

- OpenIndiana
- OpenSolaris
- Solaris 11

在 Mac mini M1 + UTM 上，需確認：

- UTM 是否能穩定跑 x86 虛擬機或模擬。
- 網路是否可 Bridge 至區網。
- guest OS 是否能取得固定 IP。
- Windows client 是否能 ping 到 guest IP。

### 2. 放置 server files

PIXNET 線索提到 `tw404j.tar.gz`。

建議放置位置：

```text
~/tw404
```

或依原始腳本預設路徑放置。

不要提交該檔或解壓內容到 GitHub。

### 3. 修改 IP 與 hosts

該教學提到：

```bash
./change-ip
./change-hosts
```

推測用途：

- `change-ip`：批次替換 server 設定檔內 IP。
- `change-hosts`：調整 guest OS 的 hosts 對應。

需檢查的設定位置可能包含：

```text
~/tw404/db/DB.cfg
~/tw404/jtales0/table/DBs.jtales
~/tw404/jtales0/table/Servers.jtales
~/tw404/jtales1/table/DBs.jtales
~/tw404/jtales1/table/Servers.jtales
~/tw404/jtales2/table/DBs.jtales
~/tw404/jtales2/table/Servers.jtales
~/tw404/jtales*/table/Patches.jtales
```

### 4. 初始化

該教學提到：

```bash
./twsrv-init
```

推測用途：

- 初始化 MySQL 或相關資料庫。
- 設定必要權限。
- 建立啟動環境。
- 檢查路徑與檔案權限。

### 5. 建立帳號

該教學提到：

```bash
./create-accounts
```

待確認事項：

- 是否互動式輸入帳號密碼。
- 是否會寫入 MySQL。
- 是否會同步寫入 `/tw404/db/master` 類目錄。
- 是否需手動搬移 hash 檔。

### 6. 啟動伺服器

該教學提到：

```bash
./start-twsrv
```

需要觀察是否啟動：

```text
db
jtales0
jtales1
jtales2
```

建議啟動後用：

```bash
ps -ef | grep jtales
ps -ef | grep db
netstat -an | grep 40000
```

確認服務是否存在。

### 7. Client 登入

Windows 端通常不是透過官方 launcher，而是用 client 參數指定 server。

需確認：

- 4.04J client 版本一致。
- `/ADDR` 是否需將 IP 轉換為整數。
- `/PORT` 是否為 40000。
- 防火牆是否允許連線。

## 與 TWPrivate / RaGEZONE 交叉驗證點

TWPrivate 與 RaGEZONE 可用來驗證：

- 4.04J server 與 client 版本相容性。
- `/tw404/db`、`jtales0`、`jtales1`、`jtales2` 架構。
- `DB.cfg`、`DBs.jtales`、`Servers.jtales` 需替換 IP。
- MySQL 與 Berkeley DB 可能同時存在。
- server 日期過新可能導致登入後被踢。

## 待辦事項

- [ ] 確認 PIXNET 原文中的 OS 建議版本。
- [ ] 確認 UTM 是否可跑 OpenIndiana / OpenSolaris。
- [ ] 整理 `change-ip` 可能替換的檔案清單。
- [ ] 寫一個安全版 `replace_server_ip.sh`，支援 Solaris sed 不支援 `-i` 的情況。
- [ ] 寫一個 `/ADDR` 換算工具。
- [ ] 建立 troubleshooting 筆記。
