
import AppKit
import SwiftUI
//
//class FloatingWindowController: NSWindowController {
//    
//    static let shared = FloatingWindowController()
//    
//    convenience init() {
//        // 定义窗口初始位置和大小（屏幕底部）
//        let screenRect = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 800, height: 200)
//        let contentRect = NSRect(x: (screenRect.width - 800) / 2, y: 100, width: 800, height: 150)
//        
//        // 使用 NSPanel 实现高级置顶
//        let panel = NSPanel(
//            contentRect: contentRect,
//            styleMask: [.borderless, .nonactivatingPanel], // 无边框，点击不抢占焦点
//            backing: .buffered,
//            defer: false
//        )
//        
//        // --- 核心置顶设置 ---
//        panel.level = .mainMenu + 1 // 等级高于普通窗口和菜单栏
//        panel.isFloatingPanel = true
//        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // 跨桌面显示，支持全屏上方显示
//        
//        // 透明与交互设置
//        panel.backgroundColor = .clear
//        panel.isOpaque = false
//        panel.hasShadow = false
//        panel.ignoresMouseEvents = true // 【重要】设置为 true 则鼠标可以穿透点击后方的浏览器
//        
//        self.init(window: panel)
//        
//        // 绑定 SwiftUI 视图
//        let contentView = ScrollingOverlayView()
//            .edgesIgnoringSafeArea(.all)
//        
//        panel.contentView = NSHostingView(rootView: contentView)
//    }
//    
//    func show() {
//        window?.makeKeyAndOrderFront(nil)
//        window?.orderFrontRegardless() // 强制显示在最前
//    }
//}

// 1. 定义窗口类
class SubtitlePanel: NSPanel {
    init() {
        super.init(
            contentRect: NSRect(x: 100, y: 100, width: 600, height: 80),
            styleMask: [.nonactivatingPanel, .resizable],
            backing: .buffered,
            defer: false
        )
        self.level = .mainMenu + 1 // 修正后的写法
        self.isFloatingPanel = true
        self.backgroundColor = NSColor.white.withAlphaComponent(0.7) // 半透明黑
        self.isOpaque = false
        self.hasShadow = true
        self.ignoresMouseEvents = true // 先设为 false，方便你拖动测试，跑通后再改 true
        
        // 载入视图
        self.contentView = NSHostingView(rootView: Text("Hello Subtitle")
            .foregroundColor(.white)
            .font(.title))
    }
}
