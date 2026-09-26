// swift-tools-version: 6.4
import PackageDescription

let package = Package(
  name: "PackageBuildInfo",
  products: [
    .plugin(name: "PackageBuildInfoPlugin", targets: ["PackageBuildInfoPlugin"])
  ],
  targets: [
    .plugin(
      name: "PackageBuildInfoPlugin",
      capability: .buildTool(),
      dependencies: ["PackageBuildInfo"]
    ),
    .binaryTarget(name: "PackageBuildInfo", path: "Binaries/PackageBuildInfo.artifactbundle"),
  ]
)
