import SwiftUI
import StoreKit

class ConfigViewState: ObservableObject {
    @Published var showingAlert: Bool = false
    @Published var showingActivityIndicator: Bool = false
    @Published var errorMessage: String?

    let fileRepository = FileRepository()
    
    var versionAndBuild: String? {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
           let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return "\(version)(\(build))"
        }
        return nil
    }
    
    func review() {
        let activeScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        if let windowScene = activeScene {
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
        do {
            try fileRepository.reset()
            NotificationCenter.default.post(name: .reset, object: nil)
        } catch {
            errorMessage = "リセットに失敗しました"
        }
    }
}
