# PersonalMap

自分だけの地図を作れる iOS アプリです。地点・ライン・エリアをレイヤーで管理し、各オブジェクトにテキスト・URL・画像・PDF などの情報を紐付けることができます。

## 機能

- **マップ表示**: 標準・衛星・ハイブリッド・淡色の4種類のマップタイプに切り替え可能
- **マップタイル**: 国土地理院の標準地図・淡色地図オーバーレイに対応
- **レイヤー管理**: 複数のレイヤーを作成し、ポイント・ライン・エリアをそれぞれ管理
- **ルート表示**: マップ上の長押しで現在地からのルートを表示
- **情報添付**: 各オブジェクトにテキスト・URL・画像・PDF を添付可能

## 動作環境

- iOS 17.0 以上

## アーキテクチャ

```
PersonalMap/
├── Entity/          # データモデル
├── Repository/      # ファイル読み書き（FileRepository）
├── Singleton/       # LocationManager
├── Extension/       # CLLocationCoordinate2D, Notification 拡張
├── Error/           # エラー定義
└── Views/
    ├── Root/        # タブビュー
    ├── MapTab/      # マップ画面
    ├── ListTab/     # レイヤー・オブジェクト管理画面
    └── ConfigTab/   # 設定画面
```

## ドキュメント

- [ファイル保存形式](docs/file-format.md)
