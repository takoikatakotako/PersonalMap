import SwiftUI

struct AddMapObjectItems: View {
    let items: [Item]
    @Binding var sheet: AddMapObjectSheet?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("項目の作成")
                .font(Font.system(size: 20).bold())
                .padding(.top, 12)
            
            HStack {
                VStack(alignment: .leading) {
                    ForEach(items) { item in
                        if item.itemType == .text {
                            Text("\(item.key): \(item.value)")
                        } else if item.itemType == .url {
                            Button {
                                if let url = URL(string: item.value) {
                                    UIApplication.shared.open(url, completionHandler: nil)
                                }
                            } label: {
                                Text("\(item.key): \(item.value)")
                            }
                        } else if item.itemType == .image {
                            Button {
                                
                            } label: {
                                Text("\(item.key): \(item.value)")
                            }
                        }
                    }
                }
                Spacer()
                Button {
                    sheet = .item
                } label: {
                    Text("項目を設定")
                }
            }
        }
    }
}

//struct AddMapObjectItems_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMapObjectItems()
//    }
//}
