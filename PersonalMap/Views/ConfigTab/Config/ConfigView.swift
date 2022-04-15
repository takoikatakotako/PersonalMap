import SwiftUI

struct ConfigView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        Text("ここでアプリの使い方を表示します。")
                    } label: {
                        Text("アプリの使い方")
                    }

                    NavigationLink {
                        Text("よくある質問・ヘルプセンターを表示します。")
                    } label: {
                        Text("よくある質問・ヘルプセンター")
                    }
                
                    NavigationLink {
                        Text("アプリのフィードバックを送る")
                    } label: {
                        Text("アプリのフィードバックを送る")
                    }
                    
                    NavigationLink {
                        Text("よくある質問・ヘルプセンターを表示します。")
                    } label: {
                        Text("お問い合わせ・不具合のご報告")
                    }
                } header: {
                    Text("アプリの使い方・お問い合わせ")
                }
                
                Section {
                    NavigationLink {
                        Text("レビューで応援する")
                    } label: {
                        Text("レビューで応援する")
                    }
                    
                    NavigationLink {
                        Text("アプリをシェアする")
                    } label: {
                        Text("アプリをシェアする")
                    }
                    
                    NavigationLink {
                        Text("プライバシーポリシー")
                    } label: {
                        Text("プライバシーポリシー")
                    }
                    
                    NavigationLink {
                        Text("利用規約")
                    } label: {
                        Text("利用規約")
                    }
                    
                    HStack {
                        Text("バージョン")
                        Spacer()
                        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
                           let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
                            Text("\(version)(\(build))")
                        }
                    }
                } header: {
                    Text("アプリについて")
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("初期設定に戻す")
                            .foregroundColor(Color.red)
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("設定")
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
