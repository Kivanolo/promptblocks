import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ContentView: View {
    @State private var selectedTemplate = PromptLibrary.templates[0]
    @State private var selectedKind: BlockKind = .goal
    @State private var blocks = PromptLibrary.templates[0].blocks
    @State private var userInput = ""
    @State private var copied = false

    private var prompt: String {
        PromptComposer.compose(blocks: blocks, userInput: userInput)
    }

    private var score: Int {
        PromptComposer.readinessScore(blocks: blocks, userInput: userInput)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderView(score: score)
                    TemplateStrip(
                        templates: PromptLibrary.templates,
                        selectedTemplate: selectedTemplate,
                        onSelect: applyTemplate
                    )
                    InputPanel(
                        placeholder: selectedTemplate.suggestedInput,
                        text: $userInput
                    )
                    BuilderPanel(
                        selectedKind: $selectedKind,
                        selectedBlocks: $blocks
                    )
                    PromptPreview(
                        prompt: prompt,
                        copied: copied,
                        hints: PromptComposer.hints(blocks: blocks, userInput: userInput),
                        onCopy: copyPrompt
                    )
                }
                .padding(18)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("PromptBlocks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        blocks.removeAll()
                        userInput = ""
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .accessibilityLabel("リセット")
                }
            }
        }
    }

    private func applyTemplate(_ template: PromptTemplate) {
        selectedTemplate = template
        selectedKind = .goal
        blocks = template.blocks
    }

    private func copyPrompt() {
        #if canImport(UIKit)
        UIPasteboard.general.string = prompt
        #endif
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            copied = false
        }
    }
}

private struct HeaderView: View {
    let score: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("ブロックでAIに伝える")
                        .font(.title2.weight(.bold))
                    Text("目的、条件、形式を選ぶだけで、使えるプロンプトに組み立てます。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 16)
                ReadinessGauge(score: score)
            }
        }
    }
}

private struct ReadinessGauge: View {
    let score: Int

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(Color(.tertiarySystemFill), lineWidth: 7)
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(score)")
                    .font(.caption.weight(.bold))
            }
            .frame(width: 48, height: 48)
            Text("準備度")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("準備度 \(score)")
    }

    private var scoreColor: Color {
        if score >= 80 { return .green }
        if score >= 60 { return .orange }
        return .red
    }
}

private struct TemplateStrip: View {
    let templates: [PromptTemplate]
    let selectedTemplate: PromptTemplate
    let onSelect: (PromptTemplate) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(symbol: "square.grid.2x2", title: "テンプレート")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(templates) { template in
                        Button {
                            onSelect(template)
                        } label: {
                            TemplateTile(template: template, isSelected: template == selectedTemplate)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
}

private struct TemplateTile: View {
    let template: PromptTemplate
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Image(systemName: template.symbol)
                .font(.headline)
                .foregroundStyle(isSelected ? .white : .blue)
                .frame(width: 28, height: 28)
            Text(template.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? .white : .primary)
            Text(template.subtitle)
                .font(.caption)
                .foregroundStyle(isSelected ? .white.opacity(0.86) : .secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(12)
        .frame(width: 148, height: 112, alignment: .topLeading)
        .background(isSelected ? Color.blue : Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(isSelected ? Color.blue : Color(.separator).opacity(0.35), lineWidth: 1)
        }
    }
}

private struct InputPanel: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(symbol: "text.badge.plus", title: "材料")
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(.body)
                    .frame(minHeight: 124)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                if text.isEmpty {
                    Text(placeholder)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

private struct BuilderPanel: View {
    @Binding var selectedKind: BlockKind
    @Binding var selectedBlocks: [PromptBlock]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(symbol: "puzzlepiece.extension", title: "ブロック")
            KindPicker(selectedKind: $selectedKind)
            BlockPalette(kind: selectedKind, onAdd: addBlock)
            SelectedStack(blocks: $selectedBlocks)
        }
    }

    private func addBlock(_ block: PromptBlock) {
        selectedBlocks.append(PromptBlock(kind: block.kind, title: block.title, instruction: block.instruction))
    }
}

private struct KindPicker: View {
    @Binding var selectedKind: BlockKind

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(BlockKind.allCases) { kind in
                    Button {
                        selectedKind = kind
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: kind.symbol)
                                .font(.caption.weight(.semibold))
                            Text(kind.title)
                                .font(.caption.weight(.semibold))
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 34)
                        .foregroundStyle(selectedKind == kind ? .white : kind.tint)
                        .background(selectedKind == kind ? kind.tint : kind.tint.opacity(0.12))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 1)
        }
    }
}

private struct BlockPalette: View {
    let kind: BlockKind
    let onAdd: (PromptBlock) -> Void

    var body: some View {
        let blocks = PromptLibrary.blocks[kind, default: []]
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 8)], spacing: 8) {
            ForEach(blocks) { block in
                Button {
                    onAdd(block)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(kind.tint)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(block.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                            Text(kind.title)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .frame(minHeight: 58)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(.separator).opacity(0.25), lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct SelectedStack: View {
    @Binding var blocks: [PromptBlock]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("組み立て中")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                if !blocks.isEmpty {
                    Button {
                        blocks.removeAll()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("ブロックを空にする")
                }
            }

            if blocks.isEmpty {
                EmptyStackHint()
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(blocks.enumerated()), id: \.element.id) { index, block in
                        SelectedBlockRow(
                            index: index,
                            block: block,
                            canMoveUp: index > 0,
                            canMoveDown: index < blocks.count - 1,
                            onMoveUp: { moveBlock(from: index, offset: -1) },
                            onMoveDown: { moveBlock(from: index, offset: 1) },
                            onRemove: { blocks.removeAll { $0.id == block.id } }
                        )
                    }
                }
            }
        }
    }

    private func moveBlock(from index: Int, offset: Int) {
        let target = index + offset
        guard blocks.indices.contains(index), blocks.indices.contains(target) else { return }
        blocks.swapAt(index, target)
    }
}

private struct EmptyStackHint: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "hand.tap")
                .foregroundStyle(.secondary)
            Text("上のブロックをタップして追加します。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct SelectedBlockRow: View {
    let index: Int
    let block: PromptBlock
    let canMoveUp: Bool
    let canMoveDown: Bool
    let onMoveUp: () -> Void
    let onMoveDown: () -> Void
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(block.kind.tint)
                Text("\(index + 1)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 26, height: 26)

            VStack(alignment: .leading, spacing: 2) {
                Text(block.title)
                    .font(.subheadline.weight(.semibold))
                Text(block.instruction)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 8)
            HStack(spacing: 2) {
                Button(action: onMoveUp) {
                    Image(systemName: "chevron.up")
                }
                .disabled(!canMoveUp)
                .accessibilityLabel("\(block.title)を上へ")

                Button(action: onMoveDown) {
                    Image(systemName: "chevron.down")
                }
                .disabled(!canMoveDown)
                .accessibilityLabel("\(block.title)を下へ")

                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                }
                .accessibilityLabel("\(block.title)を削除")
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.secondary)
        }
        .padding(9)
        .background(block.kind.tint.opacity(0.09))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct PromptPreview: View {
    let prompt: String
    let copied: Bool
    let hints: [String]
    let onCopy: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionTitle(symbol: "doc.on.doc", title: "完成プロンプト")
                Spacer()
                Button(action: onCopy) {
                    Label(copied ? "コピー済み" : "コピー", systemImage: copied ? "checkmark" : "doc.on.doc")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }

            if !hints.isEmpty {
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(hints, id: \.self) { hint in
                        HStack(alignment: .top, spacing: 7) {
                            Image(systemName: "wand.and.stars")
                                .font(.caption)
                                .foregroundStyle(.orange)
                                .frame(width: 16)
                            Text(hint)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(10)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }

            Text(prompt)
                .font(.system(.footnote, design: .monospaced))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

private struct SectionTitle: View {
    let symbol: String
    let title: String

    var body: some View {
        Label(title, systemImage: symbol)
            .font(.headline)
            .foregroundStyle(.primary)
    }
}

#Preview {
    ContentView()
}
