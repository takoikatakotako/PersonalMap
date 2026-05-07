# ファイル保存形式

アプリのデータは iOS の Documents ディレクトリ以下に保存されます。

## ディレクトリ構成

```
Documents/
├── layer/
│   ├── layers.json          # レイヤーIDの一覧
│   └── {UUID}.json          # 各レイヤーの定義
├── object/
│   └── {UUID}.json          # 各マップオブジェクト（ポイント・ライン・エリア）
├── image/
│   └── {ファイル名}          # 添付画像
└── pdf/
    └── {ファイル名}          # 添付PDF
```

---

## layers.json

レイヤーの表示順を保持した UUID の配列です。

```json
[
  "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
]
```

---

## layer/{UUID}.json（MapLayer）

レイヤー1件の定義です。

| フィールド | 型 | 説明 |
|---|---|---|
| `id` | UUID (String) | レイヤーの識別子 |
| `layerName` | String | レイヤー名 |
| `mapObjectType` | String | オブジェクト種別（後述） |
| `objectIds` | [UUID] | 所属するオブジェクトIDの配列（順序保持） |

`mapObjectType` の値:

| 値 | 説明 |
|---|---|
| `"point"` | ポイント |
| `"polyLine"` | ライン |
| `"polygon"` | エリア |

```json
{
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "layerName": "観光スポット",
  "mapObjectType": "point",
  "objectIds": [
    "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
    "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
  ]
}
```

---

## object/{UUID}.json（MapObject）

マップオブジェクト1件の定義です。`mapObjectType` によって構造が異なります。

### 共通フィールド

| フィールド | 型 | 説明 |
|---|---|---|
| `id` | UUID (String) | オブジェクトの識別子 |
| `mapObjectType` | String | `"point"` / `"polyLine"` / `"polygon"` |
| `imageName` | String | SF Symbols のアイコン名 |
| `isHidden` | Bool | 非表示フラグ |
| `objectName` | String | オブジェクト名 |
| `items` | [Item] | 添付情報の配列（後述） |

### ポイント（mapObjectType: "point"）

```json
{
  "id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "mapObjectType": "point",
  "imageName": "star.circle",
  "isHidden": false,
  "objectName": "東京タワー",
  "coordinate": {
    "latitude": 35.658581,
    "longitude": 139.745433
  },
  "items": []
}
```

| フィールド | 型 | 説明 |
|---|---|---|
| `coordinate` | Coordinate | 緯度・経度（後述） |

### ライン（mapObjectType: "polyLine"）

```json
{
  "id": "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb",
  "mapObjectType": "polyLine",
  "imageName": "arrow.triangle.swap",
  "isHidden": false,
  "objectName": "散歩ルート",
  "coordinates": [
    { "latitude": 35.658581, "longitude": 139.745433 },
    { "latitude": 35.659000, "longitude": 139.746000 }
  ],
  "items": []
}
```

| フィールド | 型 | 説明 |
|---|---|---|
| `coordinates` | [Coordinate] | 頂点座標の配列 |

### エリア（mapObjectType: "polygon"）

```json
{
  "id": "cccccccc-cccc-cccc-cccc-cccccccccccc",
  "mapObjectType": "polygon",
  "imageName": "square",
  "isHidden": false,
  "objectName": "公園",
  "coordinates": [
    { "latitude": 35.658000, "longitude": 139.745000 },
    { "latitude": 35.659000, "longitude": 139.745000 },
    { "latitude": 35.659000, "longitude": 139.746000 },
    { "latitude": 35.658000, "longitude": 139.746000 }
  ],
  "items": []
}
```

| フィールド | 型 | 説明 |
|---|---|---|
| `coordinates` | [Coordinate] | 頂点座標の配列 |

---

## Coordinate

| フィールド | 型 | 説明 |
|---|---|---|
| `latitude` | Double | 緯度 |
| `longitude` | Double | 経度 |

---

## Item（添付情報）

各オブジェクトに複数の情報を添付できます。

| フィールド | 型 | 説明 |
|---|---|---|
| `id` | UUID (String) | 識別子 |
| `itemType` | String | 種別（後述） |
| `key` | String | ラベル名 |
| `value` | String | 値 |

`itemType` の値:

| 値 | `value` の内容 |
|---|---|
| `"text"` | テキスト本文 |
| `"url"` | URL 文字列 |
| `"image"` | `image/` ディレクトリ内のファイル名 |
| `"pdf"` | `pdf/` ディレクトリ内のファイル名 |

```json
{
  "id": "dddddddd-dddd-dddd-dddd-dddddddddddd",
  "itemType": "text",
  "key": "メモ",
  "value": "営業時間 9:00-18:00"
}
```
