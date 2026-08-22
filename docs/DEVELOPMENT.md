# Set Background - Colour Light — development notes

`README.md` is the user-facing documentation. This is the technical reference: the
API calls and constants, the traps, and what is and is not verified.

The five theme macros share one mechanism, so this document covers the set. This
repository holds **Set Background - Colour Light**; the others are linked from the README.

---

## 1. What these macros do

Each writes a single **system option** through `ISldWorks::SetUserPreferenceIntegerValue`
and, where the graphics area is affected, redraws it. Nothing is written into any
part, assembly or drawing, so the settings persist across documents and sessions
until changed again.

They fall into two independent groups that combine freely:

- **Graphics area** — the background behind the model.
- **Interface** — the CommandManager, FeatureManager, menus and task pane.

## 2. Constants

| Constant | Value | What it is |
|---|---|---|
| `swUserPreferenceIntegerValue_e.swColorsBackgroundAppearance` | 305 | the "Background appearance" radio group |
| `swUserPreferenceIntegerValue_e.swSystemColorsViewportBackground` | 99 | the "Viewport Background" colour |
| `swUserPreferenceIntegerValue_e.swSystemColorsBackground` | 554 | the "Background:" dropdown (interface theme) |

| `swColorsBackgroundAppearance_e` | Value |
|---|---|
| `..._Plain` | 0 |
| `..._Gradient` | 1 |
| `..._Image` | 2 |
| `..._DocumentScene` | 3 |

| `swInterfaceBrightnessTheme_e` | Value |
|---|---|
| `..._Light` | 0 |
| `..._Medium` | 1 |
| `..._Dark` | 2 |
| `..._MediumLight` | 3 |
| `..._3DExperience` | 4 |

Nothing needs adding under **Tools > References**: a new SOLIDWORKS macro already
references the `SldWorks` and `swconst` type libraries, which supply these names.

## 3. Two traps worth knowing

### 3.1 The theme enum is not in dropdown order

The dropdown reads Light, Medium Light, Medium, Dark. The enum does not:

| Dropdown position | Label | Enum value |
|---|---|---|
| 1 | Light | 0 |
| 2 | Medium Light | **3** |
| 3 | Medium | **1** |
| 4 | Dark | **2** |

**Deriving a value from the dropdown position silently selects the wrong theme** —
position 2 would give Medium instead of Medium Light. Light and Dark happen to be
unaffected, which is why the two shipped interface macros work either way, but
anyone adding a Medium variant must use the named constant.

Medium Light having the highest number is consistent with it being added to the
product after the original three.

### 3.2 Colours are COLORREF, not RGB

SOLIDWORKS expects a Win32 `COLORREF`, which is `&H00BBGGRR` — blue in the high
byte, red in the low byte, the reverse of the usual web ordering. VBA's
`RGB(r, g, b)` produces exactly this, so calling `RGB()` handles it.

- `RGB(255,255,255)` = 16777215
- `RGB(73,73,73)` = 4802889

A wrong byte order would be invisible on grey and would transpose any other colour,
so this is worth getting right rather than assuming.

## 4. Known issue — Task Pane script error

**Cosmetic, and not caused by these macros.**

Changing the interface theme can raise a Windows **Script Error** dialog. Clicking
Yes dismisses it and the theme applies correctly.

It comes from SOLIDWORKS' own task pane content, not from the macro: changing the
theme by hand in System Options produces the same dialog. Collapsing the task pane
before switching avoids it.

## 5. Adding the missing themes

Only Light and Dark have interface macros. For Medium or Medium Light, copy the
source and swap the constant for `swInterfaceBrightnessTheme_Medium` or
`..._MediumLight` — **using the named constant, not the dropdown position**, per
trap 3.1.

## 6. Verification status

Stated precisely, because it is uneven.

**Confirmed working in SOLIDWORKS:** the two interface macros. They apply the theme
correctly even when the Task Pane dialog above appears.

**Confirmed by evidence, not by an end-to-end run:** the three background macros.
They share their entire mechanism with the interface pair, so the risk is low, but
that is the honest status.

**Verified without running anything:** the constant names and values come from the
type library itself; the registry keys hold these exact settings; and the
`&H00BBGGRR` byte order was confirmed by reading back a known stock colour.

## 7. There is no build step

A `.swp` is a binary VBA project. Editing the `.vba` in `src\` changes nothing that
runs until the source is pasted into the SOLIDWORKS VBA editor and saved. Treat the
`.vba` as the source of truth and re-paste after every change.

Do not try to patch a `.swp` directly: it stores compiled p-code ahead of the source
text, and VBA runs the p-code — so a patched file shows new code in the editor while
still running the old.
