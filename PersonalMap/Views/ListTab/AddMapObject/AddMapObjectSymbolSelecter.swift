import SwiftUI

struct AddMapObjectSymbolSelecter: View {
    let symbolName: String
    @Binding var sheet: AddMapObjectSheet?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("シンボルの選択")
                .font(Font.system(size: 20).bold())
                .padding(.top, 12)
            
            HStack {
                Image(systemName: symbolName)
                    .resizable()
                    .foregroundColor(Color.blue)
                    .frame(width: 52, height: 52)
                    .padding(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Spacer()
                Button {
                    sheet = .symbol
                } label: {
                    Text("シンボルを設定")
                }
            }
        }
    }
}
