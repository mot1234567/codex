//
//  ContentView.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }
            
            PracticeView()
                .tabItem {
                    Label("練習", systemImage: "list.bullet")
                }
            
            ExamView()
                .tabItem {
                    Label("模擬試験", systemImage: "clock")
                }
            
            PDFLibraryView()
                .tabItem {
                    Label("教材", systemImage: "doc.text")
                }
            
            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
