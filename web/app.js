const kindColors = {
  goal: "#d95c55",
  role: "#5f62c8",
  audience: "#178978",
  source: "#b86b2d",
  constraint: "#246bfe",
  output: "#2b815d",
  tone: "#bf5a88",
  guardrail: "#8059c7"
};

const kindLabels = {
  goal: "目的",
  role: "役割",
  audience: "相手",
  source: "入力",
  constraint: "条件",
  output: "形式",
  tone: "トーン",
  guardrail: "確認"
};

const kindSymbols = {
  goal: "◎",
  role: "人",
  audience: "宛",
  source: "文",
  constraint: "条",
  output: "形",
  tone: "色",
  guardrail: "確"
};

const blockLibrary = {
  goal: [
    ["文章を整える", "読みやすく自然な文章に改善してください。"],
    ["要約する", "重要な論点だけを残して要約してください。"],
    ["アイデアを出す", "実行しやすいアイデアを複数提案してください。"],
    ["比較する", "選択肢を比較し、判断材料を整理してください。"],
    ["学習する", "理解を深めるために、順番に説明してください。"]
  ],
  role: [
    ["編集者", "あなたは経験豊富な編集者です。"],
    ["先生", "あなたは初学者に教えるのが得意な先生です。"],
    ["面接官", "あなたは採用面接官です。"],
    ["企画担当", "あなたは事業企画の担当者です。"],
    ["厳しめのレビュアー", "あなたは論理の甘さを見逃さないレビュアーです。"]
  ],
  audience: [
    ["初心者向け", "専門知識がない人にも伝わるようにしてください。"],
    ["上司向け", "忙しい上司が短時間で判断できる内容にしてください。"],
    ["顧客向け", "顧客に失礼がなく、信頼感が伝わる表現にしてください。"],
    ["学生向け", "学生が自分で考えられる余白を残してください。"]
  ],
  source: [
    ["貼り付け文を使う", "下の入力文を材料にしてください。"],
    ["箇条書きを使う", "箇条書きのメモを整理して使ってください。"],
    ["不足は質問", "情報が不足している場合は、作業前に確認質問をしてください。"],
    ["推測を分ける", "事実と推測を分けて扱ってください。"]
  ],
  constraint: [
    ["短く", "できるだけ短く、要点を優先してください。"],
    ["具体例つき", "抽象論だけでなく、具体例を入れてください。"],
    ["次の行動まで", "最後に次に取るべき行動を提案してください。"],
    ["メリデメ", "メリットとデメリットを両方示してください。"],
    ["3案に絞る", "候補は3つに絞り、それぞれの使いどころを説明してください。"]
  ],
  output: [
    ["箇条書き", "出力は箇条書きにしてください。"],
    ["表", "比較しやすい表で出力してください。"],
    ["メール文", "そのまま送れるメール文として出力してください。"],
    ["チェックリスト", "確認しやすいチェックリストで出力してください。"],
    ["手順", "手順を番号付きで出力してください。"]
  ],
  tone: [
    ["丁寧", "丁寧で落ち着いた表現にしてください。"],
    ["やさしい", "やさしく、圧のない表現にしてください。"],
    ["ビジネス", "ビジネスで使いやすい簡潔な表現にしてください。"],
    ["カジュアル", "親しみやすくカジュアルな表現にしてください。"]
  ],
  guardrail: [
    ["確認質問", "曖昧な点があれば、先に最大3つまで質問してください。"],
    ["根拠を分ける", "根拠がある内容と推測を分けて書いてください。"],
    ["改善案", "最後に、より良い結果にするための改善案を示してください。"],
    ["禁止事項", "不明な情報を断定しないでください。"]
  ]
};

const materialTypes = [
  {
    id: "free",
    label: "自由文",
    placeholder: "対象の文章やメモを貼り付けてください。",
    instruction: "元の文章がある場合は文脈を読み取り、ない場合は選択された条件だけで作成してください。"
  },
  {
    id: "memo",
    label: "雑メモ",
    placeholder: "思いついたことを順不同で貼り付けてください。",
    instruction: "入力は未整理のメモです。重複や順序の乱れを整理してから使ってください。"
  },
  {
    id: "bullets",
    label: "箇条書き",
    placeholder: "箇条書きのメモを貼り付けてください。",
    instruction: "入力は箇条書きです。各項目の関係を補いながら使ってください。"
  },
  {
    id: "draft",
    label: "下書き",
    placeholder: "送られてきたメール、返信したい内容、下書きなどを貼り付けてください。",
    instruction: "入力は下書きです。元の意図を保ちながら、必要に応じて構成と表現を整えてください。"
  },
  {
    id: "notes",
    label: "会議メモ",
    placeholder: "決定事項、発言、宿題、日付などを貼り付けてください。",
    instruction: "入力は会議メモです。決定事項、未決事項、担当、次の行動を区別して使ってください。"
  }
];

const materialHandlings = [
  {
    id: "use-as-is",
    label: "そのまま使う",
    instruction: "元の文章がある場合は主材料として扱い、ない場合は選択された条件を優先してください。"
  },
  {
    id: "organize-first",
    label: "整理してから",
    instruction: "元の文章がある場合はまず整理し、目的に必要な情報だけを使ってください。"
  },
  {
    id: "ask-if-missing",
    label: "不足は質問",
    instruction: "重要な情報が不足している場合は、作業前に確認質問を最大3つまで出してください。"
  },
  {
    id: "separate-facts",
    label: "事実と推測",
    instruction: "元の文章がある場合は、事実、推測、希望を分けて扱ってください。"
  }
];

const templates = [
  {
    id: "email",
    title: "メールを整える",
    subtitle: "短く、失礼なく",
    icon: "✉",
    placeholder: "相手、目的、伝えたい内容を貼り付けてください。",
    materialType: "draft",
    materialHandling: "organize-first",
    blocks: [
      makeBlock("role", "編集者", "あなたは経験豊富な編集者です。"),
      makeBlock("goal", "文章を整える", "読みやすく自然な文章に改善してください。"),
      makeBlock("audience", "顧客向け", "顧客に失礼がなく、信頼感が伝わる表現にしてください。"),
      makeBlock("output", "メール文", "そのまま送れるメール文として出力してください。"),
      makeBlock("tone", "丁寧", "丁寧で落ち着いた表現にしてください。")
    ]
  },
  {
    id: "summary",
    title: "長文を要約",
    subtitle: "読むべき点だけに圧縮",
    icon: "文",
    placeholder: "要約したい文章を貼り付けてください。",
    materialType: "free",
    materialHandling: "use-as-is",
    blocks: [
      makeBlock("goal", "要約する", "重要な論点だけを残して要約してください。"),
      makeBlock("source", "貼り付け文を使う", "下の入力文を材料にしてください。"),
      makeBlock("constraint", "短く", "できるだけ短く、要点を優先してください。"),
      makeBlock("output", "箇条書き", "出力は箇条書きにしてください。"),
      makeBlock("guardrail", "根拠を分ける", "根拠がある内容と推測を分けて書いてください。")
    ]
  },
  {
    id: "planning",
    title: "企画のたたき台",
    subtitle: "雑メモから提案へ",
    icon: "案",
    placeholder: "作りたいもの、対象ユーザー、悩み、制約を書いてください。",
    materialType: "memo",
    materialHandling: "organize-first",
    blocks: [
      makeBlock("role", "企画担当", "あなたは事業企画の担当者です。"),
      makeBlock("goal", "アイデアを出す", "実行しやすいアイデアを複数提案してください。"),
      makeBlock("constraint", "3案に絞る", "候補は3つに絞り、それぞれの使いどころを説明してください。"),
      makeBlock("constraint", "メリデメ", "メリットとデメリットを両方示してください。"),
      makeBlock("output", "表", "比較しやすい表で出力してください。")
    ]
  },
  {
    id: "study",
    title: "学習サポート",
    subtitle: "わからない所を順に",
    icon: "学",
    placeholder: "学びたいテーマ、今わからない点、目標を書いてください。",
    materialType: "free",
    materialHandling: "ask-if-missing",
    blocks: [
      makeBlock("role", "先生", "あなたは初学者に教えるのが得意な先生です。"),
      makeBlock("goal", "学習する", "理解を深めるために、順番に説明してください。"),
      makeBlock("audience", "初心者向け", "専門知識がない人にも伝わるようにしてください。"),
      makeBlock("constraint", "具体例つき", "抽象論だけでなく、具体例を入れてください。"),
      makeBlock("output", "手順", "手順を番号付きで出力してください。")
    ]
  }
];

const state = {
  selectedTemplateId: templates[0].id,
  selectedKind: "goal",
  materialType: templates[0].materialType,
  materialHandling: templates[0].materialHandling,
  blocks: templates[0].blocks.map(cloneBlock),
  sourceText: "",
  input: ""
};

const elements = {
  templateList: document.querySelector("#templateList"),
  materialTypeList: document.querySelector("#materialTypeList"),
  materialHandlingList: document.querySelector("#materialHandlingList"),
  sourceMaterial: document.querySelector("#sourceMaterial"),
  sourceMaterialSummary: document.querySelector("#sourceMaterialSummary"),
  sourceText: document.querySelector("#sourceText"),
  optionalInput: document.querySelector("#optionalInput"),
  noteInput: document.querySelector("#noteInput"),
  kindTabs: document.querySelector("#kindTabs"),
  blockPalette: document.querySelector("#blockPalette"),
  selectedBlocks: document.querySelector("#selectedBlocks"),
  clearBlocks: document.querySelector("#clearBlocks"),
  promptOutput: document.querySelector("#promptOutput"),
  copyPrompt: document.querySelector("#copyPrompt"),
  scoreValue: document.querySelector("#scoreValue"),
  scoreRing: document.querySelector(".score-value"),
  hints: document.querySelector("#hints")
};

function makeBlock(kind, title, instruction) {
  return {
    id: crypto.randomUUID ? crypto.randomUUID() : `${Date.now()}-${Math.random()}`,
    kind,
    title,
    instruction
  };
}

function cloneBlock(block) {
  return makeBlock(block.kind, block.title, block.instruction);
}

function render() {
  renderTemplates();
  renderMaterialControls();
  renderKinds();
  renderPalette();
  renderSelectedBlocks();
  renderPrompt();
  persistState();
}

function renderTemplates() {
  elements.templateList.innerHTML = "";
  templates.forEach((template) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = `template-card ${template.id === state.selectedTemplateId ? "active" : ""}`;
    button.setAttribute("role", "listitem");
    button.innerHTML = `
      <span class="template-icon">${template.icon}</span>
      <span class="template-title">${template.title}</span>
      <span class="template-subtitle">${template.subtitle}</span>
    `;
    button.addEventListener("click", () => {
      state.selectedTemplateId = template.id;
      state.selectedKind = "goal";
      state.materialType = template.materialType;
      state.materialHandling = template.materialHandling;
      state.blocks = template.blocks.map(cloneBlock);
      updateInputLabels();
      render();
    });
    elements.templateList.append(button);
  });
}

function renderMaterialControls() {
  renderChoiceList(elements.materialTypeList, materialTypes, state.materialType, (id) => {
    state.materialType = id;
    updateInputLabels();
    render();
  });

  renderChoiceList(elements.materialHandlingList, materialHandlings, state.materialHandling, (id) => {
    state.materialHandling = id;
    render();
  });
}

function renderChoiceList(container, choices, selectedId, onSelect) {
  container.innerHTML = "";
  choices.forEach((choice) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = `choice-button ${choice.id === selectedId ? "active" : ""}`;
    button.textContent = choice.label;
    button.addEventListener("click", () => onSelect(choice.id));
    container.append(button);
  });
}

function updateInputLabels() {
  const type = getMaterialType();
  const template = templates.find((item) => item.id === state.selectedTemplateId) || templates[0];
  elements.sourceMaterialSummary.textContent = template.id === "email" ? "受信メールを貼る" : "元の文章を貼る";
  elements.sourceText.placeholder = type.placeholder || template.placeholder;
}

function renderKinds() {
  elements.kindTabs.innerHTML = "";
  Object.keys(kindLabels).forEach((kind) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = `kind-tab ${kind === state.selectedKind ? "active" : ""}`;
    button.style.setProperty("--kind", kindColors[kind]);
    button.setAttribute("role", "tab");
    button.setAttribute("aria-selected", String(kind === state.selectedKind));
    button.textContent = `${kindSymbols[kind]} ${kindLabels[kind]}`;
    button.addEventListener("click", () => {
      state.selectedKind = kind;
      render();
    });
    elements.kindTabs.append(button);
  });
}

function renderPalette() {
  elements.blockPalette.innerHTML = "";
  blockLibrary[state.selectedKind].forEach(([title, instruction]) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "block-card";
    button.style.setProperty("--kind", kindColors[state.selectedKind]);
    button.innerHTML = `
      <span class="plus-dot">+</span>
      <span>
        <span class="block-title">${title}</span>
        <span class="block-kind">${kindLabels[state.selectedKind]}</span>
      </span>
    `;
    button.addEventListener("click", () => {
      state.blocks.push(makeBlock(state.selectedKind, title, instruction));
      render();
    });
    elements.blockPalette.append(button);
  });
}

function renderSelectedBlocks() {
  elements.selectedBlocks.innerHTML = "";
  elements.clearBlocks.hidden = state.blocks.length === 0;

  if (state.blocks.length === 0) {
    const empty = document.createElement("div");
    empty.className = "empty-stack";
    empty.textContent = "上のブロックをタップして追加します。";
    elements.selectedBlocks.append(empty);
    return;
  }

  state.blocks.forEach((block, index) => {
    const row = document.createElement("div");
    row.className = "selected-row";
    row.style.setProperty("--kind", kindColors[block.kind]);
    row.innerHTML = `
      <span class="order-badge">${index + 1}</span>
      <span class="selected-copy">
        <strong>${block.title}</strong>
        <span>${block.instruction}</span>
      </span>
      <span class="row-actions">
        <button type="button" data-action="up" aria-label="${block.title}を上へ">↑</button>
        <button type="button" data-action="down" aria-label="${block.title}を下へ">↓</button>
        <button type="button" data-action="remove" aria-label="${block.title}を削除">×</button>
      </span>
    `;
    const [up, down, remove] = row.querySelectorAll("button");
    up.disabled = index === 0;
    down.disabled = index === state.blocks.length - 1;
    up.addEventListener("click", () => moveBlock(index, -1));
    down.addEventListener("click", () => moveBlock(index, 1));
    remove.addEventListener("click", () => {
      state.blocks = state.blocks.filter((item) => item.id !== block.id);
      render();
    });
    elements.selectedBlocks.append(row);
  });
}

function renderPrompt() {
  const prompt = composePrompt();
  const score = readinessScore();
  const dash = 113 - (113 * score) / 100;
  elements.promptOutput.textContent = prompt;
  elements.scoreValue.textContent = String(score);
  elements.scoreRing.style.strokeDashoffset = String(dash);
  elements.scoreRing.style.stroke = score >= 80 ? kindColors.output : score >= 60 ? kindColors.source : kindColors.goal;
  renderHints();
}

function renderHints() {
  elements.hints.innerHTML = "";
  hints().forEach((hint) => {
    const item = document.createElement("div");
    item.className = "hint";
    item.innerHTML = `<span>◇</span><span>${hint}</span>`;
    elements.hints.append(item);
  });
}

function moveBlock(index, offset) {
  const target = index + offset;
  if (target < 0 || target >= state.blocks.length) return;
  const next = [...state.blocks];
  const [item] = next.splice(index, 1);
  next.splice(target, 0, item);
  state.blocks = next;
  render();
}

function composePrompt() {
  const sections = [];
  const materialInstructions = [getMaterialType().instruction, getMaterialHandling().instruction].filter(Boolean);
  if (state.blocks.length > 0) {
    const lines = state.blocks.map((block, index) => `${index + 1}. ${block.instruction}`).join("\n");
    sections.push(`# 指示\n${lines}`);
  }

  if (materialInstructions.length > 0) {
    sections.push(`# 材料の扱い\n${materialInstructions.map((instruction, index) => `${index + 1}. ${instruction}`).join("\n")}`);
  }

  const sourceText = state.sourceText.trim();
  if (sourceText) {
    sections.push(`# 元の文章\n${sourceText}`);
  }

  const input = state.input.trim();
  if (input) {
    sections.push(`# 追加メモ\n${input}`);
  }
  sections.push("# 出力前の確認\n条件同士が矛盾する場合は、最も自然な解釈を1つ選び、必要なら短く理由を添えてください。");
  return sections.join("\n\n");
}

function readinessScore() {
  const kinds = new Set(state.blocks.map((block) => block.kind));
  let score = 20;
  if (kinds.has("goal")) score += 20;
  if (state.materialType && state.materialHandling) score += 20;
  if (kinds.has("source") || state.sourceText.trim()) score += 5;
  if (kinds.has("output")) score += 20;
  if (kinds.has("constraint") || kinds.has("tone")) score += 10;
  if (kinds.has("guardrail")) score += 10;
  return Math.min(score, 100);
}

function hints() {
  const kinds = new Set(state.blocks.map((block) => block.kind));
  const items = [];
  if (!kinds.has("goal")) items.push("目的ブロックを足すと、AIが何をすべきか判断しやすくなります。");
  if (!state.materialType || !state.materialHandling) items.push("材料タイプと扱い方を選ぶと、文章を書かなくても依頼がまとまります。");
  if (!kinds.has("output")) items.push("形式ブロックを足すと、コピーしやすい結果になります。");
  if (!kinds.has("guardrail")) items.push("確認ブロックを足すと、AIの思い込みを減らせます。");
  return items.slice(0, 3);
}

function persistState() {
  const payload = {
    selectedTemplateId: state.selectedTemplateId,
    selectedKind: state.selectedKind,
    materialType: state.materialType,
    materialHandling: state.materialHandling,
    blocks: state.blocks,
    sourceText: state.sourceText,
    input: state.input
  };
  localStorage.setItem("promptblocks-state", JSON.stringify(payload));
}

function restoreState() {
  const raw = localStorage.getItem("promptblocks-state");
  if (!raw) return;
  try {
    const saved = JSON.parse(raw);
    if (saved.selectedTemplateId) state.selectedTemplateId = saved.selectedTemplateId;
    if (saved.selectedKind && kindLabels[saved.selectedKind]) state.selectedKind = saved.selectedKind;
    if (saved.materialType && materialTypes.some((choice) => choice.id === saved.materialType)) state.materialType = saved.materialType;
    if (saved.materialHandling && materialHandlings.some((choice) => choice.id === saved.materialHandling)) state.materialHandling = saved.materialHandling;
    if (Array.isArray(saved.blocks)) state.blocks = saved.blocks.map(cloneBlock);
    if (typeof saved.sourceText === "string") {
      state.sourceText = saved.sourceText;
      elements.sourceText.value = saved.sourceText;
      elements.sourceMaterial.open = saved.sourceText.trim().length > 0;
    }
    if (typeof saved.input === "string") {
      state.input = saved.input;
      elements.noteInput.value = saved.input;
      elements.optionalInput.open = saved.input.trim().length > 0;
    }
  } catch {
    localStorage.removeItem("promptblocks-state");
  }
}

function getMaterialType() {
  return materialTypes.find((choice) => choice.id === state.materialType) || materialTypes[0];
}

function getMaterialHandling() {
  return materialHandlings.find((choice) => choice.id === state.materialHandling) || materialHandlings[0];
}

async function copyText(text) {
  if (navigator.clipboard?.writeText) {
    try {
      await navigator.clipboard.writeText(text);
      return true;
    } catch {
      // Some embedded browsers deny clipboard writes even after a user click.
    }
  }

  const field = document.createElement("textarea");
  field.value = text;
  field.setAttribute("readonly", "");
  field.style.position = "fixed";
  field.style.top = "-999px";
  field.style.opacity = "0";
  document.body.append(field);
  field.select();
  const copied = document.execCommand("copy");
  field.remove();
  if (!copied) throw new Error("Copy failed");
  return true;
}

function selectPromptOutput() {
  const selection = window.getSelection();
  const range = document.createRange();
  range.selectNodeContents(elements.promptOutput);
  selection.removeAllRanges();
  selection.addRange(range);
}

function showCopyState(label, copied) {
  elements.copyPrompt.classList.toggle("copied", copied);
  elements.copyPrompt.querySelector("span").textContent = label;
  window.setTimeout(() => {
    elements.copyPrompt.classList.remove("copied");
    elements.copyPrompt.querySelector("span").textContent = "コピー";
  }, 1400);
}

elements.sourceText.addEventListener("input", (event) => {
  state.sourceText = event.target.value;
  renderPrompt();
  persistState();
});

elements.noteInput.addEventListener("input", (event) => {
  state.input = event.target.value;
  renderPrompt();
  persistState();
});

elements.clearBlocks.addEventListener("click", () => {
  state.blocks = [];
  render();
});

elements.copyPrompt.addEventListener("click", async () => {
  try {
    await copyText(composePrompt());
    showCopyState("コピー済み", true);
  } catch {
    selectPromptOutput();
    showCopyState("選択済み", false);
  }
});

if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("./sw.js").catch(() => {});
  });
}

restoreState();
updateInputLabels();
render();
