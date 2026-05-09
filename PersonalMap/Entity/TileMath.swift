import CoreGraphics

enum TileMath {
    struct ParentTile: Equatable {
        let z: Int
        let x: Int
        let y: Int
        let scale: Int
    }

    /// Given a child tile path at z > maxNativeZ, returns the parent tile at maxNativeZ
    /// that contains it. Returns nil if z <= maxNativeZ.
    static func parentTile(z: Int, x: Int, y: Int, maxNativeZ: Int) -> ParentTile? {
        guard z > maxNativeZ else { return nil }
        let scale = 1 << (z - maxNativeZ)
        return ParentTile(z: maxNativeZ, x: x / scale, y: y / scale, scale: scale)
    }

    /// Returns the rect at which to draw the parent tile so the child's 1/scale region
    /// fills the unit tile. Origins are negative for non-top-left children.
    static func parentDrawRect(childX: Int, childY: Int, scale: Int, tileSize: CGSize) -> CGRect {
        CGRect(
            x: -CGFloat(childX % scale) * tileSize.width,
            y: -CGFloat(childY % scale) * tileSize.height,
            width: tileSize.width * CGFloat(scale),
            height: tileSize.height * CGFloat(scale)
        )
    }
}
