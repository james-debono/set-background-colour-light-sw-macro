# Set Background - Colour Light

A SOLIDWORKS macro that sets the graphics area background to plain white from a
toolbar button, instead of clicking through **Tools > Options > System Options >
Colors** every time.

**Tested on SOLIDWORKS 2022, 2024 and 2025** — those are the versions I
have. Other versions are likely to work; they are simply untested.

> **Want all ten macros at once?** This one is part of the [MacroShelf
> Collection](https://github.com/james-debono/macroshelf-collection-sw-macro-library) — a single
> download, already arranged as a library for the [MacroShelf](https://github.com/james-debono/macroshelf-sw-addin)
> add-in, so every macro lands on a SOLIDWORKS toolbar tab with its icon and
> hover text already set up.

## What it does

Sets the background appearance to **Plain** and the viewport background colour
to **white**, then redraws the graphics area. The interface around it is a
separate setting — see [Set UI Theme -
Dark](https://github.com/james-debono/set-ui-theme-dark-sw-macro).

It writes a **system option**, not a document property. Nothing is saved into
any part, assembly or drawing, and the setting persists across documents and
sessions until changed again.

## Install

**The macro on its own:** download `Set-Background-Colour-Light.swp` from the
[latest release](../../releases/latest), then run it with **Tools > Macro >
Run**, or add it to a toolbar with **Tools > Customize > Commands > Macro**.
**Tools > Customize > Keyboard** assigns a keyboard shortcut instead.

**With [MacroShelf](https://github.com/james-debono/macroshelf-sw-addin):** get
the [MacroShelf
Collection](https://github.com/james-debono/macroshelf-collection-sw-macro-library/releases/latest),
which packages this macro with its icon and hover text alongside every other
macro in the set. The five theme macros appear together as a Themes drop-down.

## Related macros

- [Set Background - Colour Dark](https://github.com/james-debono/set-background-colour-dark-sw-macro)
- [Set Background - Scene](https://github.com/james-debono/set-background-scene-sw-macro)

## Building from source

`src/Set-Background-Colour-Light.vba` is the source. A `.swp` is a binary VBA
project, so it has to be created from inside SOLIDWORKS — there is no build
step:

1. **Tools > Macro > New…**, and save it with the matching name.
2. The VBA editor opens on an empty `Sub main()`. Select all and delete.
3. Paste in the whole contents of the `.vba`.
4. Save and close the editor.

Nothing needs adding under **Tools > References** — a new SOLIDWORKS macro
already references the `SldWorks` and `swconst` type libraries, which is what
supplies the enum names the source uses.

## Licence

MIT — see [LICENSE](LICENSE). Free to use, modify and share. The full licence
text is also carried inside the macro itself, so a `.swp` passed on by itself
still carries its licence.

Created by James Debono, with AI assistance. Everything here was tested by
hand in SOLIDWORKS — nothing that touches the API can be verified any other way.

## Trademarks

SOLIDWORKS is a registered trademark of Dassault Systèmes SolidWorks
Corporation. This project is independent: it is not affiliated with, endorsed
by, or sponsored by Dassault Systèmes, and uses only the published SOLIDWORKS
API.