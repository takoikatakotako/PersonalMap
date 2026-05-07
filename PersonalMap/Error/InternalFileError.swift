import Foundation

import Foundation

protocol InternalError: LocalizedError {}

enum InternalFileError: InternalError {
    case documentDirectoryNotFound
    case decodeFailed
    var errorDescription: String? {
        switch self {
        case .documentDirectoryNotFound: return "ディレクトリーフォルダが見つかりませんでした"
        case .decodeFailed: return "データの読み込みに失敗しました"
        }
    }
}
