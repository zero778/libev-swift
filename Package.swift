// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "libev-swift",
    dependencies: [
    	.Package(url: "https://github.com/zero778/clibev", majorVersion: 1)
    ]
)
