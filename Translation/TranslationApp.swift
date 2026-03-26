//
//  TranslationApp.swift
//  Translation
//
//  Created by 刘明浩 on 2026/3/24.
//

import SwiftUI

@main
struct TranslationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                        ContentView().onAppear {
                                // 启动永远置顶的悬浮窗
                                // FloatingWindowController.shared.show()
                            }
                    }
                    // 隐藏主窗口的标题栏（可选）
                    .windowStyle(.hiddenTitleBar)
        }
    }



// 2. 在 App 中持有并启动
struct SubtitleApp: App {
    // 使用 State 保持对象引用，否则窗口会闪退（被垃圾回收）
    @State private var panel = SubtitlePanel()

    var body: some Scene {
        WindowGroup {
            VStack(spacing: 20) {
                Button("显示字幕窗口") {
                    panel.makeKeyAndOrderFront(nil)
                    panel.orderFrontRegardless()
                }
                Button("隐藏字幕窗口") {
                    panel.orderOut(nil)
                }
            }
            .frame(width: 200, height: 150)
        }
    }
}

