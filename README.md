# SwiftUIUtilityKit

🛠 Installation
Via Swift Package Manager
1. Open your Xcode project.
2. Go to File > Add Packages.
3. Paste the repository URL: https://github.com/chetan-7span/SwiftUIUtilityKit.git
4. Select the latest version and add it to your target.



A Swift package that includes various useful components for iOS development, such as:

- **DeviceManager**: Provides functionality to fetch detailed device information in SwiftUI.

      let deviceModel = DeviceManager.shared.model
      let systemVersion = DeviceManager.shared.systemVersion
      let screenSize = DeviceManager.shared.screenResolution
  
- **ArrayExtension**:  Add various useful operations to arrays, making them more flexible.

      let numbers = [1, 2, 3, 4, 5, 6]
      let chunks = numbers.chunked(into: 2) // [[1, 2], [3, 4], [5, 6]]

      let safeItem = numbers[safe: 10] // nil

      let sum = numbers.sum // 21
      let avg = numbers.average // 3.5

      let onlyTwos = [2, 2, 2].containsOnly(2) // true

- **Bundle Extensions**: Provide easier access to app metadata like version and build number, also provide basic details of the device.

      print(Bundle.main.appVersion) // e.g., "1.2.3"
      print(Bundle.main.isTestFlight) // true if running via TestFlight
      print(Bundle.main.decode(MyModel.self, from: "data.json"))


- **FontManager**: Allows easy register and usage of custom fonts in SwiftUI.
  
      FontManager.registerFont(fontName: "Respective_2.0", fontExtension: "ttf")
      Text("Hello, How are you?")
      .font(FontManager.customFont(name: "Michaelmas", size: 24))

- **ForceUpdateManager**: This module helps you prompt users to update the app when a new version is available.
  
       ForceUpdateView(
        config: ForceUpdateConfig(
            title: "🚀 Update Available",
            message: "We've improved performance and squashed some bugs. Please update for the best experience.",
            updateButtonTitle: "Update Now",
            skipButtonTitle: "Later",
            isSkippable: true,
            appStoreURL: URL(string: "your appstore url")!,
            titleColor: .indigo,
            messageColor: .gray,
            backgroundColor: Color(.systemBackground),
            buttonColor: .orange,
            cornerRadius: 24,
            titleFont: .custom("AvenirNext-Bold", size: 24),
            messageFont: .custom("AvenirNext-Regular", size: 16),
            updateButtonFont: .custom("AvenirNext-Medium", size: 18),
            skipButtonFont: .custom("AvenirNext-Regular", size: 14)
        ),
        onSkip: {
            print("User chose to skip update")
        }
      )
  
- **MediaPicker**: This module allows users to select media (images/videos) from their photo library.
  
       MediaPicker.init(mediaType: .both) { pickedMedia in }

- **OTPInputView**: A customizable OTP input view for entering verification codes.
  
      OTPInputView { otpString in
                print("OTP entered: \(otpString)")
            }
            
      OTPInputView(digitSize:CGSizeMake(40, 40),borderType: .square) { code in
                print("Square OTP entered: \(code)")
            }
            
      OTPInputView(digitSize:CGSizeMake(40, 40),borderType: .below) { code in
                print("Below OTP entered: \(code)")
            }


- **ShadowModifier**: A custom view modifier for adding shadows to views.
  
      Image("imageName")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .cornerRadius(20)
                .applyShadow(color: .black.opacity(0.9), radius: 10, x: 0, y: 5)
  
- **Shimmer**: A shimmer effect for loading indicators.

       @State private var isLoading = true
      VStack(alignment: .leading, spacing: 8) {
                    Text("About Us")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
       Text("We are committed to delivering the best experience. Our app is designed to help you achieve your goals with ease and efficiency.")
                        .font(.body)
                        .foregroundColor(.black)
                }
                .shimmer(isLoading: isLoading)

  
- **UserDefaults Manager**: A simplified and enhanced approach to managing UserDefaults.
  
      UserDefaultsManager.shared.register(key: "userId", defaultValue: 0)
      UserDefaultsManager.shared.set(123, forKey: "userId")
      print(UserDefaultsManager.shared.get(forKey: "userId",defaultValue: 0))
  or

      if let userId = UserDefaultsManager.shared.get(forKey: "userId") as Int? {
                print(userId)
        }
