//
//  SettingsView.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct SettingsView: View {
    @State private var darkModeEnabled = false
    @State private var notificationsEnabled = true
    @State private var autoSaveEnabled = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("表示設定")) {
                    Toggle("ダークモード", isOn: $darkModeEnabled)
                    
                    Picker("テキストサイズ", selection: .constant(1)) {
                        Text("小").tag(0)
                        Text("中").tag(1)
                        Text("大").tag(2)
                    }
                }
                
                Section(header: Text("通知設定")) {
                    Toggle("通知を有効にする", isOn: $notificationsEnabled)
                    
                    if notificationsEnabled {
                        Toggle("学習リマインダー", isOn: .constant(true))
                        Toggle("新問題の通知", isOn: .constant(false))
                    }
                }
                
                Section(header: Text("データ設定")) {
                    Toggle("自動保存", isOn: $autoSaveEnabled)
                    
                    Button(action: {
                        // データのリセット処理
                    }) {
                        Text("学習データをリセット")
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("アプリ情報")) {
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        // プライバシーポリシーを表示
                    }) {
                        Text("プライバシーポリシー")
                    }
                    
                    Button(action: {
                        // 利用規約を表示
                    }) {
                        Text("利用規約")
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
