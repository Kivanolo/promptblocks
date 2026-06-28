import Foundation
import SwiftUI

enum BlockKind: String, CaseIterable, Identifiable {
    case goal
    case role
    case audience
    case source
    case constraint
    case output
    case tone
    case guardrail

    var id: String { rawValue }

    var title: String {
        switch self {
        case .goal: return "目的"
        case .role: return "役割"
        case .audience: return "相手"
        case .source: return "入力"
        case .constraint: return "条件"
        case .output: return "形式"
        case .tone: return "トーン"
        case .guardrail: return "確認"
        }
    }

    var symbol: String {
        switch self {
        case .goal: return "target"
        case .role: return "person.crop.circle"
        case .audience: return "person.2"
        case .source: return "doc.text"
        case .constraint: return "slider.horizontal.3"
        case .output: return "rectangle.and.text.magnifyingglass"
        case .tone: return "paintpalette"
        case .guardrail: return "checkmark.shield"
        }
    }

    var tint: Color {
        switch self {
        case .goal: return .red
        case .role: return .indigo
        case .audience: return .teal
        case .source: return .orange
        case .constraint: return .blue
        case .output: return .green
        case .tone: return .pink
        case .guardrail: return .purple
        }
    }
}

struct PromptBlock: Identifiable, Hashable {
    let id: UUID
    let kind: BlockKind
    let title: String
    let instruction: String

    init(id: UUID = UUID(), kind: BlockKind, title: String, instruction: String) {
        self.id = id
        self.kind = kind
        self.title = title
        self.instruction = instruction
    }
}

struct PromptTemplate: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
    let suggestedInput: String
    let blocks: [PromptBlock]
}

enum PromptLibrary {
    static let blocks: [BlockKind: [PromptBlock]] = [
        .goal: [
            PromptBlock(kind: .goal, title: "文章を整える", instruction: "読みやすく自然な文章に改善してください。"),
            PromptBlock(kind: .goal, title: "要約する", instruction: "重要な論点だけを残して要約してください。"),
            PromptBlock(kind: .goal, title: "アイデアを出す", instruction: "実行しやすいアイデアを複数提案してください。"),
            PromptBlock(kind: .goal, title: "比較する", instruction: "選択肢を比較し、判断材料を整理してください。"),
            PromptBlock(kind: .goal, title: "学習する", instruction: "理解を深めるために、順番に説明してください。")
        ],
        .role: [
            PromptBlock(kind: .role, title: "編集者", instruction: "あなたは経験豊富な編集者です。"),
            PromptBlock(kind: .role, title: "先生", instruction: "あなたは初学者に教えるのが得意な先生です。"),
            PromptBlock(kind: .role, title: "面接官", instruction: "あなたは採用面接官です。"),
            PromptBlock(kind: .role, title: "企画担当", instruction: "あなたは事業企画の担当者です。"),
            PromptBlock(kind: .role, title: "厳しめのレビュアー", instruction: "あなたは論理の甘さを見逃さないレビュアーです。")
        ],
        .audience: [
            PromptBlock(kind: .audience, title: "初心者向け", instruction: "専門知識がない人にも伝わるようにしてください。"),
            PromptBlock(kind: .audience, title: "上司向け", instruction: "忙しい上司が短時間で判断できる内容にしてください。"),
            PromptBlock(kind: .audience, title: "顧客向け", instruction: "顧客に失礼がなく、信頼感が伝わる表現にしてください。"),
            PromptBlock(kind: .audience, title: "学生向け", instruction: "学生が自分で考えられる余白を残してください。")
        ],
        .source: [
            PromptBlock(kind: .source, title: "貼り付け文を使う", instruction: "下の入力文を材料にしてください。"),
            PromptBlock(kind: .source, title: "箇条書きを使う", instruction: "箇条書きのメモを整理して使ってください。"),
            PromptBlock(kind: .source, title: "不足は質問", instruction: "情報が不足している場合は、作業前に確認質問をしてください。"),
            PromptBlock(kind: .source, title: "推測を分ける", instruction: "事実と推測を分けて扱ってください。")
        ],
        .constraint: [
            PromptBlock(kind: .constraint, title: "短く", instruction: "できるだけ短く、要点を優先してください。"),
            PromptBlock(kind: .constraint, title: "具体例つき", instruction: "抽象論だけでなく、具体例を入れてください。"),
            PromptBlock(kind: .constraint, title: "次の行動まで", instruction: "最後に次に取るべき行動を提案してください。"),
            PromptBlock(kind: .constraint, title: "メリデメ", instruction: "メリットとデメリットを両方示してください。"),
            PromptBlock(kind: .constraint, title: "3案に絞る", instruction: "候補は3つに絞り、それぞれの使いどころを説明してください。")
        ],
        .output: [
            PromptBlock(kind: .output, title: "箇条書き", instruction: "出力は箇条書きにしてください。"),
            PromptBlock(kind: .output, title: "表", instruction: "比較しやすい表で出力してください。"),
            PromptBlock(kind: .output, title: "メール文", instruction: "そのまま送れるメール文として出力してください。"),
            PromptBlock(kind: .output, title: "チェックリスト", instruction: "確認しやすいチェックリストで出力してください。"),
            PromptBlock(kind: .output, title: "手順", instruction: "手順を番号付きで出力してください。")
        ],
        .tone: [
            PromptBlock(kind: .tone, title: "丁寧", instruction: "丁寧で落ち着いた表現にしてください。"),
            PromptBlock(kind: .tone, title: "やさしい", instruction: "やさしく、圧のない表現にしてください。"),
            PromptBlock(kind: .tone, title: "ビジネス", instruction: "ビジネスで使いやすい簡潔な表現にしてください。"),
            PromptBlock(kind: .tone, title: "カジュアル", instruction: "親しみやすくカジュアルな表現にしてください。")
        ],
        .guardrail: [
            PromptBlock(kind: .guardrail, title: "確認質問", instruction: "曖昧な点があれば、先に最大3つまで質問してください。"),
            PromptBlock(kind: .guardrail, title: "根拠を分ける", instruction: "根拠がある内容と推測を分けて書いてください。"),
            PromptBlock(kind: .guardrail, title: "改善案", instruction: "最後に、より良い結果にするための改善案を示してください。"),
            PromptBlock(kind: .guardrail, title: "禁止事項", instruction: "不明な情報を断定しないでください。")
        ]
    ]

    static let templates: [PromptTemplate] = [
        PromptTemplate(
            id: "email",
            title: "メールを整える",
            subtitle: "失礼なく、短く、送れる文に",
            symbol: "envelope",
            suggestedInput: "相手、目的、伝えたい内容を貼り付けてください。",
            blocks: [
                PromptBlock(kind: .role, title: "編集者", instruction: "あなたは経験豊富な編集者です。"),
                PromptBlock(kind: .goal, title: "文章を整える", instruction: "読みやすく自然な文章に改善してください。"),
                PromptBlock(kind: .audience, title: "顧客向け", instruction: "顧客に失礼がなく、信頼感が伝わる表現にしてください。"),
                PromptBlock(kind: .output, title: "メール文", instruction: "そのまま送れるメール文として出力してください。"),
                PromptBlock(kind: .tone, title: "丁寧", instruction: "丁寧で落ち着いた表現にしてください。")
            ]
        ),
        PromptTemplate(
            id: "summary",
            title: "長文を要約",
            subtitle: "読むべき点だけに圧縮",
            symbol: "text.alignleft",
            suggestedInput: "要約したい文章を貼り付けてください。",
            blocks: [
                PromptBlock(kind: .goal, title: "要約する", instruction: "重要な論点だけを残して要約してください。"),
                PromptBlock(kind: .source, title: "貼り付け文を使う", instruction: "下の入力文を材料にしてください。"),
                PromptBlock(kind: .constraint, title: "短く", instruction: "できるだけ短く、要点を優先してください。"),
                PromptBlock(kind: .output, title: "箇条書き", instruction: "出力は箇条書きにしてください。"),
                PromptBlock(kind: .guardrail, title: "根拠を分ける", instruction: "根拠がある内容と推測を分けて書いてください。")
            ]
        ),
        PromptTemplate(
            id: "planning",
            title: "企画のたたき台",
            subtitle: "雑なメモを提案に変える",
            symbol: "lightbulb",
            suggestedInput: "作りたいもの、対象ユーザー、悩み、制約を書いてください。",
            blocks: [
                PromptBlock(kind: .role, title: "企画担当", instruction: "あなたは事業企画の担当者です。"),
                PromptBlock(kind: .goal, title: "アイデアを出す", instruction: "実行しやすいアイデアを複数提案してください。"),
                PromptBlock(kind: .constraint, title: "3案に絞る", instruction: "候補は3つに絞り、それぞれの使いどころを説明してください。"),
                PromptBlock(kind: .constraint, title: "メリデメ", instruction: "メリットとデメリットを両方示してください。"),
                PromptBlock(kind: .output, title: "表", instruction: "比較しやすい表で出力してください。")
            ]
        ),
        PromptTemplate(
            id: "study",
            title: "学習サポート",
            subtitle: "わからない所を順にほどく",
            symbol: "graduationcap",
            suggestedInput: "学びたいテーマ、今わからない点、目標を書いてください。",
            blocks: [
                PromptBlock(kind: .role, title: "先生", instruction: "あなたは初学者に教えるのが得意な先生です。"),
                PromptBlock(kind: .goal, title: "学習する", instruction: "理解を深めるために、順番に説明してください。"),
                PromptBlock(kind: .audience, title: "初心者向け", instruction: "専門知識がない人にも伝わるようにしてください。"),
                PromptBlock(kind: .constraint, title: "具体例つき", instruction: "抽象論だけでなく、具体例を入れてください。"),
                PromptBlock(kind: .output, title: "手順", instruction: "手順を番号付きで出力してください。")
            ]
        )
    ]
}
