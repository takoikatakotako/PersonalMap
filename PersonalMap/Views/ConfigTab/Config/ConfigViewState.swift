import SwiftUI

class ConfigViewState: ObservableObject {
    @Published var showingAlert: Bool = false
    
    var versionAndBuild: String? {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
           let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return "\(version)(\(build))"
        }
        return nil
    }
    
    func review() {
        
    }
    
    func share() {
        
    }
    
    func showResetAlert() {
        showingAlert = true
    }
    
    func reset() {
        
    }
}
