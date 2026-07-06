# SwiftyPickerPopover アーキテクチャレビュー(2026-07)

レビュー観点: 今後12か月の開発速度・品質・保守性。短期バグ修正ではなく構造。

対象コミット: `2dae3f9`(master, 2019-10-03)/ ライブラリ本体 13ファイル・約1,700行。

## 現状サマリ

- UIKit専用のポップオーバー内ピッカーライブラリ。`AbstractPopover`(状態+表示制御)と `AbstractPickerPopoverViewController`(storyboardベースのVC)の継承ペアが4種類(String / ColumnString / Date / Countdown)。
- Fluentビルダー API(`setXxx() -> Self` チェーン)。状態は `private(set) var` の可変プロパティ群。
- 配布は CocoaPods + Carthage。SPM 未対応。テスト 0、CI 0。最終リリース 6.6.6(2019年)。
- 依存ライブラリはゼロ(良い点)。UI は storyboard + strings リソースに依存。

---

## 1. 重大リスク上位10

| # | リスク | 根拠 | 影響 |
|---|--------|------|------|
| 1 | **テストが1本もなく、CIも無い** | リポジトリに XCTest / .github/workflows が存在しない | あらゆる変更が検証不能。Xcode 16 / Swift 6 でビルドが通るかすら未確認。他の全リスクの改善速度を律速する |
| 2 | **SPM 未対応 + storyboard/strings リソース依存** | `Package.swift` 無し。`AbstractPopover.configureNavigationController` が `Bundle(for:)` でstoryboardをロード | 2026年のiOSエコシステムでは採用・継続利用の最大障壁。SPM化には `Bundle.module` 対応(リソースバンドル解決の書き換え)が必須で、単に Package.swift を置くだけでは動かない |
| 3 | **iOS 14+ で DatePicker 系の表示が崩れている可能性が高い** | `DatePickerPopoverViewController` / `CountdownPickerPopoverViewController` が `preferredDatePickerStyle` を設定していない。iOS 14 以降のデフォルト(.automatic → .compact)ではポップオーバー内がホイールにならない | 主要機能2/4がモダンOSで実質壊れている。ライブラリの信頼性を直撃 |
| 4 | **KVC による private view 取得** | `AbstractPopover.appear(barButtonItem:)` の `barButtonItem.value(forKey: "view")`(AbstractPopover.swift:113) | iOS のマイナーアップデートで nil / クラッシュになり得る。審査リスクも僅かにある。iOS 13+ なら公式 API(`UIPopoverPresentationController.barButtonItem`)で置換可能 |
| 5 | **`images` と `choices` のインデックス不整合クラッシュ** | `StringPickerPopover.setClearButton` が `choices` の先頭に `""` を insert するが `images` は補正しない。`pickerView(_:viewForRow:)` の `popover.images?[row]` は safe subscript 未使用 | クリアボタン+画像を併用すると最終行スクロールで index out of range クラッシュ(出荷済みアプリでのランタイムクラッシュ) |
| 6 | **4クラスへのロジックコピペ(継承の失敗)** | `setButton` / `setDoneButton` / `setCancelButton` / `setClearButton` / `ButtonParameterType` / フォント解決ロジックが各 Popover と各 VC にほぼ同一実装で重複 | 1つの修正を4〜8箇所に適用する必要があり、修正漏れが構造的に発生する。人にもAIにも危険な形 |
| 7 | **ローカライズが `Bundle.main` 参照で、framework 配布時に壊れる** | `String+Extension.swift` の `var localized` は main bundle のみ参照。podspec は `s.resources`(framework バンドルに配置) | `use_frameworks!` 利用時に日本語リソース(`ja.lproj/Localizable.strings`)が解決されず、キー("Done" 等)がそのまま表示される。英語では偶然動くため気づきにくい latent bug |
| 8 | **状態管理: VC⇔Popover の双方向参照と暗黙アンラップ** | `anyPopover: AbstractPopover!` + 各VCの `popover: PopoverType! { anyPopover as? PopoverType }`(downcast 失敗でも `!`)。VC が popover の可変状態を直接読み書き | ライフサイク ル起因のクラッシュ・状態不整合の温床。`disappear()` は `baseViewController?.dismiss` で「一番上のモーダル」を無差別に閉じるため、他のモーダルと併用すると誤 dismiss する |
| 9 | **リリース運用が完全手動かつ2019年から停止** | podspec のバージョン手書き、タグ手打ち、CHANGELOG 手書き。6.6.6 以降リリース無し | 「直してもユーザーに届かない」状態。fork が乱立し upstream の価値が下がる。バス係数1 |
| 10 | **ダークモード / アクセシビリティ未対応** | `fontColor: UIColor = .black` 固定、dimmed view が `UIScreen.main.bounds` 直貼り+`accessibilityIdentifier` をタグ代わりに流用、Dynamic Type 非対応 | ダークモードで文字が見えない、VoiceOver 利用者に偽の a11y 情報を与える。現行の App Store 品質基準に満たない |

補足(トップ10落ち): `UIFont(name:size:)!` の強制アンラップ(StringPickerPopoverViewController.swift:169 ほか)、`refrectPopoverProperties` の typo が実質公開APIになっている、demo 用ファイル(`SampleTableViewController.swift` / `TextFieldCel.swift`(ファイル名も typo)/ `TextFieldCell.xib`)がリポジトリ直下に散乱、`popoverPresentationControllerDidDismissPopover` がサブクラスに `override` なしで散在(objc optional 経由で偶然動いている)。

---

## 2. 今すぐ直すべきもの

1. **CI を立てる(全ての前提)**: GitHub Actions で「framework ビルド + Demo ビルド」を最新 Xcode で回す。まずビルドが通ることの確認から。
2. **`preferredDatePickerStyle = .wheels` を明示**(DatePicker / Countdown の両VC)。1行×2の修正で主要機能が現行OSで復活する。
3. **images/choices 不整合クラッシュの修正**: `setClearButton` で `images` にも nil を insert + 参照側を `images?[safe: row]` に統一。
4. **ローカライズの bundle 修正**: `localized` をライブラリ自身のバンドル(将来は `Bundle.module`)を参照する実装に変更。
5. **KVC(`value(forKey: "view")`)の排除**: `popoverPresentationController.barButtonItem` を使う経路に置換。
6. **SPM 対応**: Package.swift + リソースの `Bundle.module` 解決。これが済むまで新規採用はほぼ見込めない。
7. **リポジトリ直下の demo ファイルを `Demo/` へ移動**、`TextFieldCel.swift` のファイル名修正。
8. **deployment target を iOS 12+(推奨 14+)へ引き上げ**、`#available(iOS 11.0, *)` の空分岐など死んだコードを削除。

## 3. 直さなくてよいもの(意図的にやらない)

- **storyboard → コードUI の全面書き換え**: 効果に対してリスクが大きい。SPM のリソースバンドルで storyboard は配布できる。やるなら90日以降に1画面ずつ。
- **SwiftUI ラッパーの新規開発**: 需要シグナル(issue/star)を見てから。コア再生が先。
- **`refrectPopoverProperties` 等の命名 typo の即時一括 rename**: `open`/`public` 面に触れるため semver major が必要。7.0 で deprecated エイリアスを残して直す(今単独ではやらない)。
- **iOS 9〜11 サポートの維持**: 維持コストだけが残る。切る。
- **Carthage サポートへの追加投資**: 現状維持のみ。壊れたら SPM を案内。
- **タプルベースの `ButtonParameterType` を即 struct 化**: 公開型のため 7.0 の破壊的変更にまとめる。

## 4. 30日改善計画(テーマ: 検証可能にして、現行OSで動く7.0を出す)

- Week 1: GitHub Actions(ビルド+Demoビルド)/ SwiftLint 導入 / リポジトリ整理(demoファイル移動、.gitignore 見直し)
- Week 2: クラッシュ・破損修正(上記 2/3/4/5)。修正ごとに再現ユニットテストを追加(初のテストターゲット作成)
- Week 3: SPM 対応(`Bundle.module` 化、podspec は `resource_bundles` へ)/ deployment target 14+ / 死んだ分岐削除
- Week 4: スナップショットテスト基盤(swift-snapshot-testing、4 popover × light/dark)/ CHANGELOG 更新 / **v7.0.0 リリース**(SPM対応・iOS14+・修正込み、破壊的変更はここに集約)/ CLAUDE.md 導入

## 5. 90日改善計画(テーマ: 重複排除と運用自動化)

- Month 2:
  - ボタン/フォント/スタイル API をジェネリクス+コンポジションで一本化(`PopoverButton` struct、`PopoverStyle` struct)。4クラスのコピペ `setButton` 群を削除
  - VC → Popover の参照を読み取り専用の「表示スナップショット」渡しに変え、双方向可変参照を解消。`anyPopover!` の暗黙アンラップ排除
  - `disappear()` を `presentedViewController` の同一性確認付き dismiss に修正
- Month 3:
  - ダークモード対応(`.label` 等のセマンティックカラー化)、Dynamic Type、dimmed view の scene 対応
  - リリース自動化: タグ push → GitHub Release + `pod trunk push` + CHANGELOG 生成
  - カバレッジ目標: 状態ロジック 80%、スナップショット全画面
  - (需要があれば)SwiftUI ラッパーの spike を別モジュールで

## 6. リファクタリングPRの分割案(各PR独立・レビュー30分以内)

1. `chore/ci` — GitHub Actions + SwiftLint。コード変更なし
2. `chore/repo-hygiene` — demo ファイル移動・typo ファイル名修正。挙動変更なし
3. `fix/datepicker-style` — `preferredDatePickerStyle` 明示(+スナップショットテスト)
4. `fix/images-index-crash` — safe subscript 統一 + 回帰テスト
5. `fix/localization-bundle` — bundle 解決修正 + テスト
6. `fix/remove-kvc` — barButtonItem 経路の公式API化
7. `feat/spm` — Package.swift + Bundle.module + podspec を resource_bundles へ
8. `chore/drop-legacy` — target 14+、死んだ `#available` 分岐削除
9. `refactor/button-model`(7.0)— `PopoverButton`/`PopoverStyle` 導入、4クラスの重複削除、旧APIは deprecated で温存
10. `refactor/vc-decoupling`(7.0)— VC⇔Popover の参照整理、`!` 排除

順序依存: 1→(2〜6は並列可)→7→8→9→10。9と10だけが破壊的変更(7.0ブランチに集約)。

## 7. テスト追加方針

- **ユニットテスト(最優先・実装コスト最小)**: Popover クラスは UIKit 表示なしで生成できるため、ビルダーの状態遷移を直接検証する
  - `setClearButton` 後の choices/images の整合、`[safe:]`、`setButton` の上書き規則、`disappearAutomatically` のキャンセル挙動(DispatchWorkItem)
- **スナップショットテスト**: 4 popover × {light, dark} × {iPhone, iPad}。storyboard 由来のレイアウト退行はこれでしか守れない
- **バグ修正は必ず再現テストとセット**(fail first)
- **Demo アプリのビルドを CI に含める**(公開APIの互換性テストを兼ねる)
- UIテスト(XCUITest)は費用対効果が低いので最小限(表示→Done→callback の1本程度)に留める

## 8. AIエージェントにこのコードベースを触らせるためのルール

現状の構造はAIに不向きな点が2つある: (a) 同一ロジックが4クラスにコピペされており「1箇所直して満足する」失敗が起きやすい、(b) storyboard の変更は diff レビュー不能。ルールでこれを補う:

1. **公開API(`public`/`open`)のシグネチャ変更・削除は禁止**。必要なら `@available(*, deprecated)` の追加のみ。破壊的変更は人間が 7.0 ブランチで判断
2. **重複認識の強制**: Button/フォント系ロジックを触るときは、4 Popover + 4 VC の全対応箇所を grep して列挙してから変更する(リファクタPR 9 の完了までの暫定ルール)
3. **storyboard / xib の編集は原則禁止**。必要な場合はスナップショットテストの前後画像を添付
4. **すべての PR はビルド+テストが green であること**。テスト0の領域を触るなら、先にその領域のテストを追加
5. **クラッシュ修正は再現テスト必須**、force unwrap / KVC / private API の新規追加禁止
6. **1 PR = 1 関心事、差分 300 行以内目安**。リファクタと挙動変更を混ぜない
7. **CHANGELOG.md の該当セクションを毎PRで更新**
8. これらを `CLAUDE.md`(`AGENTS.md` は同内容)としてリポジトリ直下に置き、エージェント設定で強制する

## 9. CLAUDE.md / AGENTS.md 草案

リポジトリ直下の `CLAUDE.md` を参照(本レビューと同時にコミット)。`AGENTS.md` は同一内容のコピーまたはシンボリックリンクとして配置する。
