import SwiftUI
import StoreKit

class ConfigViewState: ObservableObject {
    @Published var showingAlert: Bool = false
    @Published var showingActivityIndicator: Bool = false

    let fileRepository = FileRepository()
    
    var versionAndBuild: String? {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
           let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return "\(version)(\(build))"
        }
        return nil
    }
    
    func review() {
        if let windowScene = UIApplication.shared.windows.first?.windowScene {
             SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    func share() {
        showingActivityIndicator = true
    }
    
    func showResetAlert() {
        showingAlert = true
    }
    
    func reset() {
        try! fileRepository.reset()
        NotificationCenter.default.post(name: .reset, object: nil)
    }
}
