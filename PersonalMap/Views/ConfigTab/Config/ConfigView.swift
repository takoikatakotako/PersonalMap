import SwiftUI

struct ConfigView: View {
    @ObservedObject var viewState: ConfigViewState = ConfigViewState()

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
                    Button {
                        viewState.review()
                    } label: {
                        Text("レビューで応援する")
                            .foregroundColor(Color.black)
                    }

                    Button {
                        viewState.share()
                    } label: {
                        Text("アプリをシェアする")
                            .foregroundColor(Color.black)
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
                        if let versionAndBuild = viewState.versionAndBuild {
                            Text(versionAndBuild)
                        }
                    }
                } header: {
                    Text("アプリについて")
                }
                
                Button {
                    viewState.showResetAlert()
                } label: {
                    HStack {
                        Spacer()
                        Text("初期設定に戻す")
                            .foregroundColor(Color.red)
                        Spacer()
                    }
                }
            }
            .alert(isPresented: $viewState.showingAlert){
                Alert(
                    title: Text("リセット"),
                    message: Text("データを削除し、初期設定に戻しますがよろしいですか？"),
                    primaryButton: .cancel(Text("キャンセル")),
                    secondaryButton: .destructive(Text("削除"))
                )
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
