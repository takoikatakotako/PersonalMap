import UIKit

public protocol UIMapObjectViewDelegate: AnyObject {
    func anotationTapped(mapObjectId: UUID)
}
