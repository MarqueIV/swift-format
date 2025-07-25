//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import Foundation
import SwiftFormat

/// Generates the markdown file with extended documenation on the available rules.
@_spi(Internal) public final class RuleDocumentationGenerator: FileGenerator {

  /// The rules collected by scanning the formatter source code.
  let ruleCollector: RuleCollector

  /// Creates a new rule registry generator.
  public init(ruleCollector: RuleCollector) {
    self.ruleCollector = ruleCollector
  }

  public func generateContent() -> String {
    var result = ""
    result += """
      <!-- This file is automatically generated with generate-swift-format. Do not edit! -->

      # `swift-format` Lint and Format Rules

      Use the rules below in the `rules` block of your `.swift-format`
      configuration file, as described in
      [Configuration](Documentation/Configuration.md). All of these rules can be
      applied in the linter, but only some of them can format your source code
      automatically.

      Here's the list of available rules:


      """
    for detectedRule in ruleCollector.allLinters.sorted(by: { $0.typeName < $1.typeName }) {
      result += "- [\(detectedRule.typeName)](#\(detectedRule.typeName))\n"
    }
    for detectedRule in ruleCollector.allLinters.sorted(by: { $0.typeName < $1.typeName }) {
      result += """

        ### \(detectedRule.typeName)

        \(detectedRule.description ?? "")
        \(ruleFormatSupportDescription(for: detectedRule))

        """
    }
    return result
  }

  private func ruleFormatSupportDescription(for rule: RuleCollector.DetectedRule) -> String {
    return rule.canFormat
      ? "`\(rule.typeName)` rule can format your code automatically." : "`\(rule.typeName)` is a linter-only rule."
  }
}
