//
//  ContentView.swift
import SwiftUI
import ScreenCaptureKit
import Speech
import AVFoundation
import AppKit



struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// MARK: - 1. 音频逻辑类 (逻辑层)
class AudioCaptureManager: NSObject, SCStreamOutput {
    var stream: SCStream?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    func startCapture() async {
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
            // 简单起见，这里直接找 Safari 或 Chrome
            guard let app = content.applications.first(where: {
                $0.bundleIdentifier.contains("Safari") || $0.bundleIdentifier.contains("Chrome")
            }) else { return }

            let filter = SCContentFilter(display: content.displays[0], including: [app], exceptingWindows: [])
            let config = SCStreamConfiguration()
            config.capturesAudio = true
            
            stream = SCStream(filter: filter, configuration: config, delegate: nil)
            try stream?.addStreamOutput(self, type: .audio, sampleHandlerQueue: .main)
            try await stream?.startCapture()
        } catch {
            print("捕获初始化失败: \(error)")
        }
    }
    
    // 收到内录音频后的回调
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        if type == .audio {
            recognitionRequest?.appendAudioSampleBuffer(sampleBuffer)
            print("🎵 正在接收音频流...")
            recognitionRequest?.appendAudioSampleBuffer(sampleBuffer)

        }
    }
  
}

// MARK: - 2. 界面显示 (UI层)
struct ContentView: View {
    @State private var transcription: String = "正在等待浏览器音频..."
    private let captureManager = AudioCaptureManager()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    var body: some View {
        ZStack {
            // 在 ZStack 内部使用这个代替纯色
            VisualEffectView(material: .underWindowBackground, blendingMode: .withinWindow)
                .clipShape(RoundedRectangle(cornerRadius: 80))
                .frame(height: 50) // 固定高度，放在底部

        }
        .onAppear {
            startLiveSubtitles()
        }
        VStack {
                Spacer() // 推到屏幕底部
                ScrollingOverlayView()
            }
    }



    private func startLiveSubtitles() {
        // 请求语音识别权限
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else { return }
            
            let request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            captureManager.recognitionRequest = request
            
            speechRecognizer?.recognitionTask(with: request) { result, _ in
                if let text = result?.bestTranscription.formattedString {
                    self.transcription = text
                }
                if let text = result?.bestTranscription.formattedString {
                    self.transcription = text
                    // 📢只需加这一行：把数据传给新管理器
                    TranslationManager.shared.appendText(text)
                }
            }
            
            // 异步启动内录
            Task {
                await captureManager.startCapture()
            }
        }
    }
} 
