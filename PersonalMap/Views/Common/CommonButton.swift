import SwiftUI

struct CommonButton: View {
    let systemName: String
    let active: Bool
    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(Color("button-blue"))
            .frame(width: 32, height: 32)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color("button-blue"), lineWidth: 2)
            )
            .background(active ? Color("button-light-blue-active") : Color("button-light-blue"))
            .cornerRadius(4)
    }
}

struct CommonButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CommonButton(systemName: "airplane", active: true)
                .previewLayout(.sizeThatFits)
            
            CommonButton(systemName: "car", active: false)
                .previewLayout(.sizeThatFits)
            
            CommonButton(systemName: "lightbulb", active: true)
                .previewLayout(.sizeThatFits)
            
            CommonButton(systemName: "lightbulb.fill", active: false)
                .previewLayout(.sizeThatFits)
            
        }
    }
}
