import Foundation

struct MapTileConfig: Equatable {
    let urlTemplate: String
    let minimumZ: Int
    let maximumZ: Int
    let maxNativeZ: Int
}

extension MapTileConfig {
    static let standard = MapTileConfig(
        urlTemplate: "https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png",
        minimumZ: 2,
        maximumZ: 25,
        maxNativeZ: 18
    )

    static let pale = MapTileConfig(
        urlTemplate: "https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png",
        minimumZ: 5,
        maximumZ: 25,
        maxNativeZ: 18
    )
}

extension MapTileType {
    var config: MapTileConfig? {
        switch self {
        case .none: return nil
        case .standard: return .standard
        case .pale: return .pale
        }
    }
}
