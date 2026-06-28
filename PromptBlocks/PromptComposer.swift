import Foundation

enum PromptComposer {
    static func compose(blocks: [PromptBlock], userInput: String) -> String {
        var sections: [String] = []

        if !blocks.isEmpty {
            let lines = blocks.enumerated().map { index, block in
                "\(index + 1). \(block.instruction)"
            }
            sections.append("""
            # 指示
            \(lines.joined(separator: "\n"))
            """)
        }

        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedInput.isEmpty {
            sections.append("""
            # 入力
            ここに材料を貼り付けます。
            """)
        } else {
            sections.append("""
            # 入力
            \(trimmedInput)
            """)
        }

        sections.append("""
        # 出力前の確認
        条件同士が矛盾する場合は、最も自然な解釈を1つ選び、必要なら短く理由を添えてください。
        """)

        return sections.joined(separator: "\n\n")
    }

    static func readinessScore(blocks: [PromptBlock], userInput: String) -> Int {
        var score = 20
        let kinds = Set(blocks.map(\.kind))
        if kinds.contains(.goal) { score += 20 }
        if kinds.contains(.source) || !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { score += 20 }
        if kinds.contains(.output) { score += 20 }
        if kinds.contains(.constraint) || kinds.contains(.tone) { score += 10 }
        if kinds.contains(.guardrail) { score += 10 }
        return min(score, 100)
    }

    static func hints(blocks: [PromptBlock], userInput: String) -> [String] {
        let kinds = Set(blocks.map(\.kind))
        var hints: [String] = []

        if !kinds.contains(.goal) {
            hints.append("目的ブロックを足すと、AIが何をすべきか判断しやすくなります。")
        }
        if userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !kinds.contains(.source) {
            hints.append("入力文か入力ブロックがあると、出力のぶれが減ります。")
        }
        if !kinds.contains(.output) {
            hints.append("形式ブロックを足すと、コピーしやすい結果になります。")
        }
        if !kinds.contains(.guardrail) {
            hints.append("確認ブロックを足すと、AIの思い込みを減らせます。")
        }

        return Array(hints.prefix(3))
    }
}
