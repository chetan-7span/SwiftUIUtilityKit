import SwiftUI
import Combine
#if os(iOS)
import UIKit
#else
import AppKit
#endif

public enum BorderType {
    case rounded
    case square
    case custom(CGFloat)
    case below
    
    public var cornerRadius: CGFloat {
        switch self {
        case .rounded:
            return 12
        case .square:
            return 0
        case .custom(let radius):
            return radius
        case .below:
            return 0
        }
    }
}

@MainActor
public struct OTPInputView: View {
    // Configuration options
    let numberOfDigits: Int
    let spacing: CGFloat
    let digitSize: CGSize
    let borderColor: Color
    let focusedBorderColor: Color
    let filledBorderColor: Color
    let backgroundColor: Color
    let textColor: Color
    let font: Font
    let borderType: BorderType
    let borderWidth: CGFloat
    let showPasteButton: Bool
    let showClearButton: Bool
    
    // State variables
    @State private var otpValues: [String]
    @State private var currentIndex: Int = 0
    @State private var isKeyboardVisible = false
    @FocusState private var isTextFieldFocused: Bool
    
    // OTP completion callback
    var onComplete: (String) -> Void
    
    public init(
        numberOfDigits: Int = 4,
        spacing: CGFloat = 12,
        digitSize: CGSize = CGSize(width: 60, height: 60),
        borderColor: Color = Color.gray.opacity(0.3),
        focusedBorderColor: Color = Color.blue,
        filledBorderColor: Color = Color.green,
        backgroundColor: Color = Color.clear,
        textColor: Color = Color.black,
        font: Font = .system(size: 22, weight: .bold),
        borderType: BorderType = .rounded,
        borderWidth: CGFloat = 2,
        showPasteButton: Bool = false,
        showClearButton: Bool = false,
        onComplete: @escaping (String) -> Void
    ) {
        self.numberOfDigits = numberOfDigits
        self.spacing = spacing
        self.digitSize = digitSize
        self.borderColor = borderColor
        self.focusedBorderColor = focusedBorderColor
        self.filledBorderColor = filledBorderColor
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.borderType = borderType
        self.borderWidth = borderWidth
        self.showPasteButton = showPasteButton
        self.showClearButton = showClearButton
        self.onComplete = onComplete
        
        // Initialize OTP values array
        _otpValues = State(initialValue: Array(repeating: "", count: numberOfDigits))
    }
    
    public var body: some View {
        VStack {
            Text("Enter Verification Code")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom)
            
            HStack(spacing: spacing) {
                ForEach(0..<numberOfDigits, id: \.self) { index in
                    digitView(for: index)
                }
            }
            .overlay {
                // Hidden text field to capture input
                if #available(iOS 17.0, *) {
                    TextField("", text: Binding(
                        get: {
                            otpValues.joined()
                        },
                        set: { newValue in
                            let digits = Array(newValue)
                            let oldLength = otpValues.joined().count
                            let newLength = digits.count
                            
                            // Handle backspace
                            if newLength < oldLength {
                                // Find the last non-empty position
                                var lastNonEmpty = -1
                                for i in (0..<numberOfDigits).reversed() {
                                    if !otpValues[i].isEmpty {
                                        lastNonEmpty = i
                                        break
                                    }
                                }
                                
                                if lastNonEmpty >= 0 {
                                    otpValues[lastNonEmpty] = ""
                                    currentIndex = lastNonEmpty
                                }
                            } else {
                                // Handle normal input
                                for i in 0..<min(numberOfDigits, digits.count) {
                                    otpValues[i] = String(digits[i])
                                }
                                currentIndex = min(digits.count, numberOfDigits)
                            }
                            
                            // Check if OTP entry is complete
                            if digits.count == numberOfDigits {
                                onComplete(newValue)
                            }
                        }
                    ))
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                    .focused($isTextFieldFocused)
                    .opacity(0.001) // Nearly invisible but still functional
                    .frame(width: 1, height: 1) // Tiny size to hide it
                    .onAppear {
                        isTextFieldFocused = true
                    }
                    .onReceive(Just(otpValues.joined())) { _ in
                        // Limit the number of characters
                        if otpValues.joined().count > numberOfDigits {
                            otpValues = Array(otpValues.joined().prefix(numberOfDigits)).map { String($0) }
                            currentIndex = numberOfDigits
                        }
                    }
                    .onKeyPress(keys: [.delete]) { press in
                        handleBackspace()
                        return .handled
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            
            if showPasteButton || showClearButton {
                HStack(spacing: 20) {
                    if showClearButton {
                        Button("Clear") {
                            resetOTP()
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.red)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    if showPasteButton {
                        Button("Paste") {
                            #if os(iOS)
                            UIPasteboard.general.string.map { pasteOTP(from: $0) }
                            #else
                            NSPasteboard.general.string(forType: .string).map { pasteOTP(from: $0) }
                            #endif
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(20)
            }
        }
        .onAppear {
            #if os(iOS)
            // Add keyboard observers
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main
            ) { @Sendable _ in
                Task { @MainActor in
                    isKeyboardVisible = true
                }
            }
            
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main
            ) { @Sendable _ in
                Task { @MainActor in
                    isKeyboardVisible = false
                }
            }
            #endif
        }
        .onTapGesture {
            isTextFieldFocused = true
        }
    }
    
    private func digitView(for index: Int) -> some View {
        let isFilled = !otpValues[index].isEmpty
        let isFocused = index == currentIndex && isKeyboardVisible
        
        return ZStack {
            // Empty or filled digit
            Text(otpValues[index])
                .font(font)
                .foregroundColor(textColor)
                .frame(width: digitSize.width, height: digitSize.height)
                .background(backgroundColor)
                .overlay(
                    Group {
                        switch borderType {
                        case .below:
                            // Bottom border only
                            Rectangle()
                                .fill(isFilled ? filledBorderColor :
                                    (isFocused ? focusedBorderColor : borderColor))
                                .frame(height: borderWidth)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                        default:
                            // Regular border
                            RoundedRectangle(cornerRadius: borderType.cornerRadius)
                                .stroke(
                                    isFilled ? filledBorderColor :
                                        (isFocused ? focusedBorderColor : borderColor),
                                    lineWidth: borderWidth
                                )
                        }
                    }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    currentIndex = index
                    isTextFieldFocused = true
                }
        }
    }
    
    private func resetOTP() {
        otpValues = Array(repeating: "", count: numberOfDigits)
        currentIndex = 0
        isTextFieldFocused = true
    }
    
    private func pasteOTP(from string: String) {
        let filtered = string.filter { $0.isNumber }
        let digits = Array(filtered.prefix(numberOfDigits))
        
        for i in 0..<numberOfDigits {
            otpValues[i] = i < digits.count ? String(digits[i]) : ""
        }
        
        currentIndex = min(digits.count, numberOfDigits)
        
        if digits.count >= numberOfDigits {
            onComplete(digits.prefix(numberOfDigits).map { String($0) }.joined())
        }
        
        isTextFieldFocused = true
    }
    
    private func handleBackspace() {
        // Find the last non-empty position
        var lastNonEmpty = -1
        for i in (0..<numberOfDigits).reversed() {
            if !otpValues[i].isEmpty {
                lastNonEmpty = i
                break
            }
        }
        
        if lastNonEmpty >= 0 {
            otpValues[lastNonEmpty] = ""
            currentIndex = lastNonEmpty
        }
    }
}

#if DEBUG
struct OTPInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Rounded border (default)
            VStack(alignment: .leading) {
                Text("Rounded Border")
                    .font(.caption)
                    .foregroundColor(.gray)
                OTPInputView { code in
                    print("Rounded OTP entered: \(code)")
                }
            }
            
            // Square border
            VStack(alignment: .leading) {
                Text("Square Border")
                    .font(.caption)
                    .foregroundColor(.gray)
                OTPInputView(digitSize:CGSizeMake(40, 40),borderType: .square) { code in
                    print("Square OTP entered: \(code)")
                }
            }
            
            // Custom border radius
            VStack(alignment: .leading) {
                Text("Custom Border (16pt radius)")
                    .font(.caption)
                    .foregroundColor(.gray)
                OTPInputView(digitSize:CGSizeMake(40, 40),borderType: .custom(20)) { code in
                    print("Custom OTP entered: \(code)")
                }
            }
            
            // Below border
            VStack(alignment: .leading) {
                Text("Below Border")
                    .font(.caption)
                    .foregroundColor(.gray)
                OTPInputView(digitSize:CGSizeMake(40, 40),borderType: .below) { code in
                    print("Below OTP entered: \(code)")
                }
            }
            
            // With buttons
            VStack(alignment: .leading) {
                Text("With Buttons")
                    .font(.caption)
                    .foregroundColor(.gray)
                OTPInputView(showPasteButton: true, showClearButton: true) { code in
                    print("OTP entered: \(code)")
                }
            }
        }
        .padding()
    }
}
#endif
