//
//  TextProcessor.swift
//  Translation
//
//  Created by 刘明浩 on 2026/3/24.
//
import Foundation
import NaturalLanguage

struct TextProcessor {
    
    // 静态工具方法：处理文本并添加智能标点
    static func format(_ rawText: String) -> String {
        guard !rawText.isEmpty else { return "" }
        
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = rawText
        
        var results: [String] = []
        let range = rawText.startIndex..<rawText.endIndex
        
        // 1. 使用 NLP 框架寻找句子边界
        tokenizer.enumerateTokens(in: range) { tokenRange, _ in
            var sentence = String(rawText[tokenRange])
            
            // 2. 移除末尾多余空格
            sentence = sentence.trimmingCharacters(in: .whitespaces)
            
            // 3. 补全标点逻辑
            if let lastChar = sentence.last, !lastChar.isPunctuation {
                // 判断语种（简单判定）
                let isChinese = sentence.contains(where: { $0.isChineseCharacter })
                
                // 判断疑问词
                let isQuestion = self.checkIfQuestion(sentence)
                
                if isChinese {
                    sentence += isQuestion ? "？" : "。"
                } else {
                    sentence += isQuestion ? "?" : "."
                }
            }
            
            results.append(sentence)
            return true
        }
        
        // 如果 NLP 没分出句子，返回原样；否则返回处理后的组合
        return results.isEmpty ? rawText : results.joined(separator: " ")
    }
    
    // 简单的疑问句启发式判断
    private static func checkIfQuestion(_ text: String) -> Bool {
        let questionWords = ["who", "what", "where", "why", "how", "is", "can", "does", "什么", "吗", "呢", "如何", "是谁"]
        let lowercased = text.lowercased()
        return questionWords.contains { lowercased.contains($0) }
    }
}

// 辅助扩展：判断中文字符
extension Character {
    var isChineseCharacter: Bool {
        return unicodeScalars.first?.value ?? 0 >= 0x4E00 && unicodeScalars.first?.value ?? 0 <= 0x9FFF
    }
}
