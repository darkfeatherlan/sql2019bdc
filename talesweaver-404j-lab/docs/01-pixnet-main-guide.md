# PIXNET 中文教學主線：天翼之鍊 4.04 單機版架設

本文件以 PIXNET 中文教學「天翼之鍊 4.04 版單機板架設」為主線整理。核心來源改為該文列出的 GitHub raw 檔案：`Mint-Fans/linux-package` 的 `Solaris` 分支。TWPrivate Wiki 與 RaGEZONE 僅作為補充參考與交叉驗證。

## 原文列出的準備工具

### 虛擬機工具

```text
Oracle VM VirtualBox 5.0.8
```

原文提醒 Windows 7 底下新版可能有啟動問題，因此建議舊版 VirtualBox。  
本案實作環境是 Mac mini M1 + UTM，需把 VirtualBox 步驟轉換為 UTM / QEMU 設定。

### Server 檔案來源

原文列出兩個 GitHub raw 來源：

```text
天翼之鍊日版 4.04 Server
https://github.com/Mint-Fans/linux-package/raw/Solaris/tw404j.tar.gz

天翼之鍊中文版 4.04 Server（角色可使用中文名稱，繁化度 95%）
https://github.com/Mint-Fans/linux-package/raw/Solaris/tw404t.tar.gz
```

整理判斷：

- `tw404j.tar.gz`：日版 4.04 server。
- `tw404t.tar.gz`：繁中化 server，重點是角色可使用中文名稱，繁化度約 95%。
- 實作上應優先研究 `tw404t.tar.gz`，因為使用者目標是繁體中文版回味。
- 但本 repo 不保存這兩個 tarball 或解壓內容，只保存筆記與自寫輔助腳本。

### Client 與登入器

原文列出 MEGA 來源：

```text
天翼之鍊日版 4.0.4 客戶端
客戶端中文化
登入器修改版（日版）
登入器修改版（台版）
```

這些屬於外部 client / patch / launcher 資源，本 repo 不保存、不鏡像、不重新散布。

## 本機目標架構

```text
Mac mini M1
  -> UTM
  -> x86 Solaris-like guest OS
     可研究方向：Solaris 11 / OpenIndiana / OpenSolaris
  -> tw404t server files, supplied separately by user
  -> Windows PC running 4.04J client + Chinese patch / TW launcher
```

建議優先採用區網連線，不做 WAN 公開。

## 注意事項

本 repo 不保存：

- `tw404j.tar.gz`
- `tw404t.tar.gz`
- client 安裝檔
- client 中文化 patch
- launcher 修改版
- server binaries
- 遊戲素材
- database dump
- 原文未授權轉載全文

本文件僅整理流程、檢查點與自寫輔助腳本。

## PIXNET 主線流程整理

### 1. 準備 VM

原文以 VirtualBox 為主，但本案要改成 UTM：

```text
Host: Mac mini M1
VM: UTM / QEMU
Guest: Solaris-like x86 environment
Network: Bridge 優先，其次 NAT + port forwarding
```

需確認：

- UTM 是否能穩定跑 x86 guest OS。
- guest OS 是否能取得固定區網 IP。
- Windows client 是否能 ping 到 guest IP。
- guest OS 內是否能解壓 `.tar.gz`、執行 shell scripts、啟動 `jtales` 與 DB。

### 2. 選擇 server 包

優先順序：

```text
1. tw404t.tar.gz  中文版 server，角色可使用中文名稱，繁化度 95%。
2. tw404j.tar.gz  日版 server，作為對照或排錯用。
```

建議不要把 tarball 放進 GitHub。若要在本機保存，放在 repo 外，例如：

```text
~/Downloads/tw-private-files/
```

或 VM 內：

```text
~/tw404
```

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

Windows 端通常不是透過官方 launcher，而是用 client 參數或修改版登入器指定 server。

需確認：

- 4.04J client 版本一致。
- 是否使用日版或台版登入器修改版。
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

- [ ] 研究 `Mint-Fans/linux-package` 的 `Solaris` 分支內容。
- [ ] 比對 `tw404j.tar.gz` 與 `tw404t.tar.gz` 差異。
- [ ] 確認 `change-ip`、`change-hosts`、`twsrv-init`、`create-accounts`、`start-twsrv` 原始腳本內容。
- [ ] 確認 UTM 是否可跑 OpenIndiana / OpenSolaris / Solaris 11。
- [ ] 寫一個安全版 `replace_server_ip.sh`，支援 Solaris sed 不支援 `-i` 的情況。
- [ ] 寫一個 `/ADDR` 換算工具。
- [ ] 建立 troubleshooting 筆記。
