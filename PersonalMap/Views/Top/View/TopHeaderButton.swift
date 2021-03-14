import SwiftUI

struct TopHeaderButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            // viewModel.showChangeMapTypeActionSheet()
            action()
        }) {
            Image(systemName: systemName)
                .padding(8)
                .background(Color.orange)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue, lineWidth: 2))
        }
    }
}

struct TopHeaderButton_Previews: PreviewProvider {
    static var previews: some View {
        TopHeaderButton(systemName: "paperplane", action: {
            print("Hello")
        })
    }
}
