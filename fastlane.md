# Fastlane

Fastlane is the easiest way to automate beta deployments and releases for your iOS and Android apps. 🚀 It handles all tedious tasks, like generating screenshots, dealing with code signing, and releasing your application.

## Getting Started

You can start by creating a `Fastfile` file in your repository. Here's one that defines your beta or App Store release process:

```ruby
lane :beta do
  increment_build_number
  build_app
  upload_to_testflight
end

lane :release do
  capture_screenshots
  build_app
  upload_to_app_store       # Upload the screenshots and the binary to iTunes
  slack                     # Let your team-mates know the new version is live
end
```

You just defined 2 different lanes, one for beta deployment, one for App Store. To release your app in the App Store, all you have to do is:

```bash
fastlane release
```

## Why Fastlane?

- 🚀 **Save hours** every time you push a new release to the store or beta testing service
- ✨ **Integrates** with all your existing tools and services (more than 400 integrations)
- 📖 **100% open source** under the MIT license
- 🎩 **Easy setup assistant** to get started in a few minutes
- ⚒ **Runs on your machine**, it's your app and your data
- 👻 **Integrates** with all major CI systems
- 🖥 **Supports** iOS, Mac, and Android apps
- 🔧 **Extend and customise** fastlane to fit your needs, you're not dependent on anyone
- 💭 **Never remember** any commands anymore, just fastlane
- 🚢 **Deploy** from any computer, including a CI server

## Fastlane Actions

Fastlane provides over 200 built-in actions to automate various tasks in your mobile development workflow. You can view all available actions by running:

```bash
fastlane actions                    # List all available actions
fastlane action [action_name]       # Get details about a specific action
```

### Key Action Categories

#### Building & Testing
- **`build_app`** (alias: `gym`) - Build and sign your iOS/Mac app
- **`build_android_app`** (alias: `gradle`) - Build your Android app
- **`run_tests`** (alias: `scan`) - Run your iOS/Mac tests
- **`gradle`** - Execute gradle tasks for Android projects

#### Code Signing
- **`match`** - Sync certificates and provisioning profiles across your team
- **`cert`** - Create and maintain iOS code signing certificates
- **`sigh`** - Generate and renew provisioning profiles

#### Deployment
- **`upload_to_testflight`** (alias: `pilot`) - Upload builds to TestFlight for beta testing
- **`upload_to_app_store`** (alias: `deliver`) - Upload metadata and binaries to App Store Connect
- **`upload_to_play_store`** (alias: `supply`) - Upload to Google Play Store

#### Screenshots
- **`capture_ios_screenshots`** (alias: `snapshot`) - Automatically generate localized screenshots for iOS
- **`capture_android_screenshots`** (alias: `screengrab`) - Generate screenshots for Android
- **`frame_screenshots`** (alias: `frameit`) - Add device frames around screenshots

#### Version Management
- **`increment_build_number`** - Bump the build number in your project
- **`increment_version_number`** - Bump the version number
- **`get_version_number`** - Retrieve the current version number

#### Notifications
- **`slack`** - Send messages to Slack channels
- **`notification`** - Display macOS notifications

### Example: Complete Release Lane

```ruby
lane :production_release do
  # Ensure git is clean
  ensure_git_status_clean
  
  # Run tests
  run_tests(scheme: "MyApp")
  
  # Increment version
  increment_build_number
  
  # Build the app
  build_app(scheme: "MyApp")
  
  # Upload to App Store
  upload_to_app_store(
    skip_metadata: false,
    skip_screenshots: false
  )
  
  # Notify team
  slack(
    message: "Successfully released new version to App Store! 🚀",
    channel: "#releases"
  )
  
  # Tag the release
  add_git_tag(tag: "v#{get_version_number}")
  push_git_tags
end
```

For more details, visit the [Fastlane Actions documentation](https://docs.fastlane.tools/actions/#fastlane-actions).
