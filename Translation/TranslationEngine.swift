import SwiftUI
internal import Combine
import Foundation
import NaturalLanguage
// 翻译行模型


// 独立的悬浮窗 UI 组件
struct ScrollingOverlayView: View {
    @StateObject private var manager = TranslationManager.shared
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(manager.messages) { line in
                        Text(line.content)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .id(line.id)
                    }
                }
                .padding()
            }
            .onChange(of: manager.messages.last?.content) { _ in
                // 自动滚动到最新的 ID
                if let lastId = manager.messages.last?.id {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                }
            }
        }
        .frame(height: 120)
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .withinWindow)
                .cornerRadius(15)
        )
        .shadow(radius: 5)
        .padding()
    }
}


struct TransLine: Identifiable, Equatable {
    let id = UUID()
    var content: String
}


class TranslationManager: ObservableObject {
    static let shared = TranslationManager()
    
    @Published var messages: [TransLine] = [TransLine(content: "等待音频输入...")]
    
    private var lastTimestamp = Date()
    private var lastText = ""
    private let pauseThreshold: TimeInterval = 0.7 // 停顿超过0.5秒视为一句话结束
    
    private init() {}
    
    func appendText(_ newText: String) {
        let now = Date()
        let timeSinceLastUpdate = now.timeIntervalSince(lastTimestamp)
        lastTimestamp = now
        
        DispatchQueue.main.async {
            // 1. 如果距离上次更新时间过长，认为上一句结束，加句号并换行
            if timeSinceLastUpdate > self.pauseThreshold && !self.lastText.isEmpty {
                self.finalizeCurrentLine()
            }
            
            // 2. 更新当前显示的文本
            if self.messages.isEmpty {
                self.messages.append(TransLine(content: newText))
            } else {
                // 简单的语义补偿：如果是以疑问词开头，尝试加问号（可选）
                let processedText = self.applyBasicPunctuation(newText)
                self.messages[self.messages.count - 1].content = processedText
            }
            
            self.lastText = newText
        }
    }
    
    private func finalizeCurrentLine() {
        guard let lastLine = self.messages.last?.content, !lastLine.isEmpty else { return }
        
        // 如果末尾没有标点，补上句号
        let lastChar = lastLine.last
        if lastChar != "." && lastChar != "?" && lastChar != "。" && lastChar != "？" {
            self.messages[self.messages.count - 1].content += "。"
        }
        
        // 开启新行
        self.messages.append(TransLine(content: ""))
    }
    
    private func applyBasicPunctuation(_ text: String) -> String {
        // 这里可以扩展更复杂的逻辑，目前保持流式显示的自然感
        // 比如：判断是否包含 "who, what, why" 等词汇
        return text
    }
}

extension TranslationManager {
    
    /// 使用 Apple NLP 框架处理文本并尝试添加标点
    func processTextWithNLP(_ rawText: String) -> String {
        guard !rawText.isEmpty else { return "" }
        
        // 1. 创建分句器 (.sentence 表示按句子切分)
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = rawText
        
        var processed = ""
        let range = rawText.startIndex..<rawText.endIndex
        
        // 2. 遍历识别到的所有“句子”单元
        tokenizer.enumerateTokens(in: range) { tokenRange, _ in
            var sentence = String(rawText[tokenRange])
            
            // 3. 简单的智能标点逻辑
            // 如果这一段话已经结束（由系统 NLP 判断为完整句子），但末尾没标点
            if let lastChar = sentence.last, !lastChar.isPunctuation {
                // 判断是否是疑问句（简单关键词过滤）
                let questionWords = ["who", "what", "where", "why", "how", "is", "can", "什么", "吗", "呢", "如何"]
                let isQuestion = questionWords.contains { sentence.lowercased().contains($0) }
                
                sentence += isQuestion ? "？" : "。"
            }
            
            processed += sentence
            return true
        }
        
        return processed.isEmpty ? rawText : processed
    }
}
