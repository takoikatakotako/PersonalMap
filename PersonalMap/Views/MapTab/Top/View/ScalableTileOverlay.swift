import MapKit
import UIKit

/// MKTileOverlay subclass that keeps tiles visible past the source's max zoom
/// by fetching the parent tile and cropping it to the requested sub-region.
final class ScalableTileOverlay: MKTileOverlay {
    private let maxNativeZ: Int

    init(urlTemplate: String?, maxNativeZ: Int) {
        self.maxNativeZ = maxNativeZ
        super.init(urlTemplate: urlTemplate)
    }

    override func loadTile(at path: MKTileOverlayPath,
                           result: @escaping (Data?, Error?) -> Void) {
        guard let parent = TileMath.parentTile(z: path.z, x: path.x, y: path.y, maxNativeZ: maxNativeZ) else {
            super.loadTile(at: path, result: result)
            return
        }

        let parentPath = MKTileOverlayPath(
            x: parent.x,
            y: parent.y,
            z: parent.z,
            contentScaleFactor: path.contentScaleFactor
        )

        super.loadTile(at: parentPath) { data, error in
            guard let data, let parentImage = UIImage(data: data) else {
                result(data, error)
                return
            }

            // Re-render at full tile size so the renderer always receives a
            // standard-sized image, even when the cropped region is tiny.
            let tileSize = parentImage.size
            let format = UIGraphicsImageRendererFormat.default()
            format.scale = parentImage.scale
            format.opaque = true
            let renderer = UIGraphicsImageRenderer(size: tileSize, format: format)
            let drawRect = TileMath.parentDrawRect(
                childX: path.x,
                childY: path.y,
                scale: parent.scale,
                tileSize: tileSize
            )
            let scaled = renderer.image { ctx in
                ctx.cgContext.interpolationQuality = .high
                parentImage.draw(in: drawRect)
            }
            result(scaled.pngData(), nil)
        }
    }
}
