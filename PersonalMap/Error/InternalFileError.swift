import Foundation

import Foundation

protocol InternalError: LocalizedError {}

enum InternalFileError: InternalError {
    case documentDirectoryNotFound
    var errorDescription: String? {
        switch self {
        case .documentDirectoryNotFound: return "ディレクトリーフォルダが見つかりませんでした"
        }
    }
}
