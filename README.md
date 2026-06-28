# PromptBlocks

PromptBlocks is a PWA and SwiftUI iOS MVP for light LLM users who want good prompts without writing prompt engineering patterns from scratch.

The app turns prompt composition into a tap-based block flow. The default path is selection-first: users should be able to create a useful prompt without writing prose. Free text is optional for users who want more control.

- Choose a common use case template.
- Choose source material type and handling.
- Add blocks for goal, role, audience, constraints, output format, tone, and safety checks.
- Optionally add rough source material when more control is needed.
- Copy the generated prompt.

## Product Direction

The target user is not an AI builder. They are a casual ChatGPT, Claude, or Gemini user who knows what they want but does not know how to phrase it reliably.

The product deliberately avoids a developer-style node canvas in the MVP. On iPhone, a compact stack of selected blocks is faster and less intimidating than free-form drag-and-drop.

## Web/PWA

The zero-cost distribution path is the static PWA in `web/`.

Run it locally with:

```sh
cd web
python3 -m http.server 8080
```

Then open `http://localhost:8080`.

For GitHub Pages, push this repository to GitHub and use the included GitHub Actions workflow. It deploys the `web/` folder to Pages on every push to `main`.

GitHub Pages does not provide detailed product analytics. GitHub repository traffic can show limited visits/referrers, but prompt-building actions inside the app are not tracked. The MVP intentionally ships with no third-party analytics.

## Launch Copy

X announcement drafts are in `marketing/x-launch-posts.md`.

## iOS Project

Open `PromptBlocks.xcodeproj` in Xcode and run the `PromptBlocks` scheme on an iPhone simulator or device.

Current bundle identifier:

```text
jp.dev.promptblocks
```

## MVP Scope

- Native SwiftUI iOS app.
- Static PWA for GitHub Pages or other free hosting.
- Four starter templates: email rewrite, summary, planning, and study support.
- Block palette by intent category.
- Selectable material type and handling mode.
- Live prompt preview.
- Readiness score and improvement hints.
- Copy to pasteboard.
- Reorder or remove selected blocks.

## Next Build Candidates

- Save favorite block recipes.
- Share sheet support.
- Persist favorite block recipes.
- One-tap send to ChatGPT/Claude/Gemini via URL scheme or share extension.
- On-device examples showing before/after prompt quality.
