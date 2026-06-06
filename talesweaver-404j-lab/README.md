# TalesWeaver 4.04J Lab

> 私人研究筆記：整理 TalesWeaver 4.04J 舊版伺服器環境的架設線索、UTM / Solaris 筆記、設定檔位置與測試流程。

## 重要聲明

本資料夾僅保存研究筆記、設定位置、腳本範本與 troubleshooting。請勿提交或散布下列內容：

- TalesWeaver server binaries
- TalesWeaver client files
- 原始遊戲圖像、音樂、地圖、資料庫 dump
- `tw404j.tar.gz`、`tw.part*.rar`、client 壓縮檔或 ISO
- 任何可能屬於 Nexon / Softmax / 相關權利人的專有檔案

本筆記的定位是「本機、區網、研究與懷舊用環境整理」，不是公開營運私服或檔案鏡像。

## 目標架構

```text
Mac mini M1
  -> UTM
  -> Solaris 10 x86 / OpenSolaris / OpenIndiana 類環境
  -> TalesWeaver 4.04J server environment
  -> Windows PC running 4.04J client
```

建議優先採用區網連線，不做 WAN 公開。

## 目前整理範圍

- TWPrivate Wiki 的 Server Installation 筆記
- RaGEZONE Japan TalesWeaver / 4.04 server 線索
- Solaris / MySQL / Berkeley DB 相關需求
- `/tw404` 目錄結構
- IP 設定檔位置
- client `/ADDR` 換算工具
- start / stop 腳本範本

## 主要參考來源

詳見：[`references/sources.md`](references/sources.md)

## 建議資料夾用途

```text
talesweaver-404j-lab/
├─ README.md
├─ docs/
│  ├─ 01-overview.md
│  ├─ 02-utm-network.md
│  ├─ 03-server-layout.md
│  ├─ 04-ip-config.md
│  ├─ 05-client-launch.md
│  ├─ 06-account-creation.md
│  └─ 99-troubleshooting.md
├─ scripts/
│  ├─ ip_to_tw_addr.py
│  ├─ replace_server_ip.sh
│  └─ start-tw404-example.sh
├─ templates/
│  └─ .gitkeep
└─ references/
   └─ sources.md
```

## 不提交檔案原則

本資料夾的 `.gitignore` 已加入常見專有檔案與映像檔排除規則。即使 repo 是 private，也建議不要提交遊戲端、伺服器端或資料庫檔案。
