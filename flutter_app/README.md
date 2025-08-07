這是一個基於 Flutter 開發的零售庫存應用程式，整合了 Firebase Authentication、SharedPreferences 本地儲存、主題與語言偏好設定、記住密碼、登入驗證，以及基本的 UI 介面切換功能，目前為練習用的開發模板，Firebase尚待實作進行整合。

功能特色

使用者登入
支援 Firebase Email/Password 登入驗證

預設測試帳號（離線可用）：
帳號：test@example.com
密碼：123456

🌐 多語系支援
英文（English）
中文（繁體）

使用者可即時切換語言，透過本地化 .json 檔管理翻譯。

🎨 主題模式
明亮 / 深色 主題切換

使用者偏好會被儲存並套用

🔐 記住密碼功能
使用 SharedPreferences 記錄使用者輸入的帳號與密碼（可選擇記住）

🔌 Firebase 功能尚待開發整合
Firebase Core 初始化
Firebase Auth 登入驗證