// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyPickerPopover",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftyPickerPopover",
            targets: ["SwiftyPickerPopover"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftyPickerPopover",
            dependencies: [],
            path: "SwiftyPickerPopover",
            exclude: ["Info.plist"],
            resources: [
                .process("Base.lproj"),
                .process("en.lproj"),
                .process("ja.lproj"),
                .process("AbstractPopover.storyboard"),
                .process("ColumnStringPickerPopover.storyboard"),
                .process("CountdownPickerPopover.storyboard"),
                .process("DatePickerPopover.storyboard"),
                .process("StringPickerPopover.storyboard"),
            ]),
    ],
    swiftLanguageVersions: [.v5]
)
