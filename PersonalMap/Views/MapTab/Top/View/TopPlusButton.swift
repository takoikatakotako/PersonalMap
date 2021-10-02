import SwiftUI

struct TopPlusButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "plus")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.white)
                .frame(width: 30, height: 30)
                .padding(12)
                .background(Color.gray)
                .cornerRadius(30)
        })
        .padding(8)
    }
}

struct TopPlusButton_Previews: PreviewProvider {
    static var previews: some View {
        TopPlusButton(action: {
            print("print")
        })
    }
}
