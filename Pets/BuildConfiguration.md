# iOS Build Configuration

## Xcode Project Settings

### General Tab
- **Display Name**: Pets - Wellness & Care
- **Bundle Identifier**: com.yourcompany.pets
- **Version**: 1.0.0
- **Build**: 1
- **Deployment Target**: iOS 15.0
- **Devices**: iPhone, iPad
- **Orientation**: Portrait, Landscape Left, Landscape Right

### Signing & Capabilities
- **Team**: Your Apple Developer Team
- **Bundle Identifier**: com.yourcompany.pets
- **Automatically manage signing**: ✅ Enabled

### Capabilities
- **HealthKit**: ✅ Enabled
- **Push Notifications**: ✅ Enabled
- **Background Modes**: ✅ Remote notifications
- **App Groups**: ❌ Not required
- **Associated Domains**: ❌ Not required

## Build Configurations

### Debug Configuration
```swift
// Debug.xcconfig
SWIFT_OPTIMIZATION_LEVEL = -Onone
DEBUG_INFORMATION_FORMAT = dwarf
ENABLE_TESTABILITY = YES
GCC_OPTIMIZATION_LEVEL = 0
```

### Release Configuration
```swift
// Release.xcconfig
SWIFT_OPTIMIZATION_LEVEL = -O
DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
ENABLE_TESTABILITY = NO
GCC_OPTIMIZATION_LEVEL = s
```

## Target Dependencies

### Main App Target
- **Target Name**: Pets
- **Type**: Application
- **Platform**: iOS
- **Language**: Swift
- **Framework**: SwiftUI

### Widget Extension Target
- **Target Name**: PetsWidget
- **Type**: Widget Extension
- **Platform**: iOS
- **Language**: Swift
- **Framework**: WidgetKit

## Build Phases

### Main App Target
1. **Headers**: No custom headers
2. **Compile Sources**: All Swift files
3. **Link Binary With Libraries**:
   - SwiftUI.framework
   - HealthKit.framework
   - UserNotifications.framework
   - WidgetKit.framework
4. **Copy Bundle Resources**: Assets, Info.plist
5. **Embed Frameworks**: None required

### Widget Extension Target
1. **Headers**: No custom headers
2. **Compile Sources**: Widget Swift files
3. **Link Binary With Libraries**:
   - SwiftUI.framework
   - WidgetKit.framework
4. **Copy Bundle Resources**: Widget assets
5. **Embed Frameworks**: None required

## Build Settings

### Swift Compiler - General
- **Swift Language Version**: Swift 5
- **Objective-C Bridging Header**: Not set
- **Install Objective-C Compatibility Header**: No

### Swift Compiler - Code Generation
- **Compilation Mode**: Incremental
- **Optimization Level**: Fast [-O] for Release
- **Compilation Mode**: Single File for Debug

### Linking
- **Other Linker Flags**: None
- **Mach-O Type**: Executable
- **Dead Code Stripping**: Yes

### Packaging
- **Info.plist File**: Pets/Info.plist
- **Product Bundle Identifier**: com.yourcompany.pets
- **Product Name**: $(TARGET_NAME)

## Scheme Configuration

### Debug Scheme
- **Build Configuration**: Debug
- **Executable**: Pets
- **Arguments**: None
- **Environment Variables**: None

### Release Scheme
- **Build Configuration**: Release
- **Executable**: Pets
- **Arguments**: None
- **Environment Variables**: None

## Archive Configuration

### Archive Settings
- **Build Configuration**: Release
- **Include bitcode**: No
- **Upload your app's symbols**: Yes
- **Manage Version and Build Number**: Yes

### Distribution Options
- **Method**: App Store Connect
- **Team**: Your Apple Developer Team
- **Distribution Certificate**: Automatic
- **Provisioning Profile**: Automatic

## Code Signing

### Development
- **Code Signing Identity**: Apple Development
- **Provisioning Profile**: Automatic
- **Team**: Your Apple Developer Team

### Distribution
- **Code Signing Identity**: Apple Distribution
- **Provisioning Profile**: Automatic
- **Team**: Your Apple Developer Team

## Build Scripts

### Pre-build Script
```bash
#!/bin/bash
# Update build number
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/Pets/Info.plist")
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/Pets/Info.plist"
```

### Post-build Script
```bash
#!/bin/bash
# Copy widget extension to main app bundle
if [ "${CONFIGURATION}" = "Release" ]; then
    echo "Copying widget extension..."
    cp -R "${BUILT_PRODUCTS_DIR}/PetsWidget.appex" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/PlugIns/"
fi
```

## Testing Configuration

### Unit Tests
- **Target**: PetsTests
- **Framework**: XCTest
- **Language**: Swift

### UI Tests
- **Target**: PetsUITests
- **Framework**: XCTest
- **Language**: Swift

## Continuous Integration

### GitHub Actions
```yaml
name: iOS Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Select Xcode
      run: sudo xcode-select -switch /Applications/Xcode_14.0.app
      
    - name: Build and Test
      run: |
        xcodebuild clean test \
          -project Pets.xcodeproj \
          -scheme Pets \
          -destination 'platform=iOS Simulator,name=iPhone 14,OS=latest'
```

## Deployment Checklist

### Pre-Archive
- [ ] Update version number
- [ ] Update build number
- [ ] Test on device
- [ ] Verify all features work
- [ ] Check app icon and launch screen
- [ ] Verify Info.plist settings

### Archive
- [ ] Select Release scheme
- [ ] Archive project
- [ ] Validate archive
- [ ] Upload to App Store Connect

### App Store Connect
- [ ] Add app metadata
- [ ] Upload screenshots
- [ ] Set pricing and availability
- [ ] Submit for review

## Troubleshooting

### Common Build Issues
1. **Code Signing Errors**: Check team and provisioning profiles
2. **HealthKit Entitlements**: Verify HealthKit capability is enabled
3. **Widget Extension**: Ensure widget target is properly configured
4. **SwiftUI Preview**: Clean build folder and restart Xcode

### Performance Optimization
- Enable bitcode for smaller app size
- Use asset catalogs for images
- Optimize image compression
- Minimize bundle size 