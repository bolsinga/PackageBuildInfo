/////
////  plugin.swift
///   Copyright © 2024 Dmitriy Borovikov. All rights reserved.
//

import Foundation
import PackagePlugin

extension URL {
  fileprivate var shellPath: String {
    path(percentEncoded: false)
  }
}

@main
struct PackageBuildInfoPlugin: BuildToolPlugin {
  func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
    guard let target = target as? SourceModuleTarget else { return [] }
    let outputFile = context.pluginWorkDirectoryURL.appending(path: "PackageBuild.swift")

    let command: Command = .prebuildCommand(
      displayName:
        "Generating \(outputFile.lastPathComponent) for \(target.directoryURL)",
      executable:
        try context.tool(named: "PackageBuildInfo").url,
      arguments: [
        "\(target.directoryURL.shellPath)", "\(outputFile.shellPath)", context.package.displayName,
        target.moduleName,
      ],
      outputFilesDirectory: context.pluginWorkDirectoryURL
    )
    return [command]
  }
}

#if canImport(XcodeProjectPlugin)
  import XcodeProjectPlugin
  extension PackageBuildInfoPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
      context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget
    ) throws -> [PackagePlugin.Command] {
      let outputFile = context.pluginWorkDirectoryURL.appending(path: "PackageBuild.swift")
      let command: Command = .prebuildCommand(
        displayName:
          "Generating \(outputFile.lastPathComponent) for \(context.xcodeProject.directoryURL)",
        executable:
          try context.tool(named: "PackageBuildInfo").url,
        arguments: [
          "\(context.xcodeProject.directoryURL.shellPath)", "\(outputFile.shellPath)",
          context.xcodeProject.displayName, target.displayName,
        ],
        outputFilesDirectory: context.pluginWorkDirectoryURL
      )
      return [command]
    }
  }
#endif
