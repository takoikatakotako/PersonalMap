import Testing
import CoreGraphics
@testable import PersonalMap

@Suite("TileMath.parentTile")
struct TileMathParentTileTests {
    @Test
    func returnsNilAtOrBelowMaxNative() {
        #expect(TileMath.parentTile(z: 18, x: 100, y: 200, maxNativeZ: 18) == nil)
        #expect(TileMath.parentTile(z: 17, x: 100, y: 200, maxNativeZ: 18) == nil)
        #expect(TileMath.parentTile(z: 0, x: 0, y: 0, maxNativeZ: 18) == nil)
    }

    @Test
    func oneLevelAbove() {
        let parent = TileMath.parentTile(z: 19, x: 200, y: 401, maxNativeZ: 18)
        #expect(parent == TileMath.ParentTile(z: 18, x: 100, y: 200, scale: 2))
    }

    @Test
    func fourLevelsAbove() {
        let parent = TileMath.parentTile(z: 22, x: 1601, y: 3215, maxNativeZ: 18)
        // floor(1601/16)=100, floor(3215/16)=200, scale=16
        #expect(parent == TileMath.ParentTile(z: 18, x: 100, y: 200, scale: 16))
    }

    @Test
    func siblingsShareSameParent() {
        // The four z=19 children of z=18 (100, 200) all map to the same parent.
        let topLeft = TileMath.parentTile(z: 19, x: 200, y: 400, maxNativeZ: 18)
        let topRight = TileMath.parentTile(z: 19, x: 201, y: 400, maxNativeZ: 18)
        let bottomLeft = TileMath.parentTile(z: 19, x: 200, y: 401, maxNativeZ: 18)
        let bottomRight = TileMath.parentTile(z: 19, x: 201, y: 401, maxNativeZ: 18)
        #expect(topLeft == topRight)
        #expect(topLeft == bottomLeft)
        #expect(topLeft == bottomRight)
    }
}

@Suite("TileMath.parentDrawRect")
struct TileMathParentDrawRectTests {
    private let tileSize = CGSize(width: 256, height: 256)

    @Test
    func topLeftChildHasZeroOriginAndScaledSize() {
        // childX=200, childY=400 -> (200%2, 400%2) = (0, 0) -> top-left
        let rect = TileMath.parentDrawRect(childX: 200, childY: 400, scale: 2, tileSize: tileSize)
        #expect(rect == CGRect(x: 0, y: 0, width: 512, height: 512))
    }

    @Test
    func bottomRightChildShiftsOriginNegative() {
        // (201%2, 401%2) = (1, 1) -> bottom-right
        let rect = TileMath.parentDrawRect(childX: 201, childY: 401, scale: 2, tileSize: tileSize)
        #expect(rect == CGRect(x: -256, y: -256, width: 512, height: 512))
    }

    @Test
    func deepZoomScale16() {
        // (1601%16, 3215%16) = (1, 15)
        let rect = TileMath.parentDrawRect(childX: 1601, childY: 3215, scale: 16, tileSize: tileSize)
        #expect(rect == CGRect(x: -256, y: -3840, width: 4096, height: 4096))
    }
}
