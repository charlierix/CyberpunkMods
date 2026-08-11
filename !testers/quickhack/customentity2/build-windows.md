# Building the RED4ext DLL on Windows 11

Companion to `deploy.md`. Use this if you have **Visual Studio** installed with the **Desktop development with C++** workload and want to build from the command line.

---

## The Problems You Will Hit

### Problem 1: NMake not found

```text
CMake Error at CMakeLists.txt:2 (project):
  Running 'nmake' '-?' failed with: no such file or directory
CMake Error: CMAKE_C_COMPILER not set, after EnableLanguage
```

**Why:** CMake defaults to the **NMake Makefiles** generator on Windows. That generator needs `nmake.exe` and `cl.exe` in PATH, which are only inside a Visual Studio developer shell.

### Problem 2: Cannot open `RED4ext/RED4ext.hpp`

```text
error C1083: Cannot open include file: 'RED4ext/RED4ext.hpp': No such file or directory
```

**Why:** The RED4ext source repo only has internal headers (`src/dll/`). The public SDK headers are a **separate download** from the RED4ext GitHub releases.

---

## Step 1: Download the RED4ext SDK

1. Go to <https://github.com/WolvenKit/RED4ext/releases>
2. Download the latest **SDK** zip (e.g. `RED4ext-SDK-x.x.x.zip`)
3. Extract it somewhere convenient, e.g. `C:\red4ext-sdk`
4. After extraction you should have:
   ```
   C:\red4ext-sdk\
       include\
           RED4ext\
               RED4ext.hpp
   ```

---

## Step 2: Build

### Method A — Visual Studio Generator (Recommended)

Works from any `cmd` or PowerShell — no developer shell needed.

```bat
cd D:\agent zero\!v2b\projects\cyberpunk\testers\quickhack\customentity2\red4ext
rmdir /s /q build
mkdir build
cd build
cmake .. -G "Visual Studio 17 2022" -A x64 -DRED4EXT_SDK_PATH="C:/red4ext-sdk/include"
cmake --build . --config Release
```

DLL output: `build\Release\OrbHackingBridge.dll`

> If you have VS 2019 use `-G "Visual Studio 16 2019"`.
> VS 2026 (Visual Studio 18) works with `-G "Visual Studio 17 2022"`.

### Method B — NMake from x64 Native Tools Command Prompt

1. Press **Win** and search for **"x64 Native Tools Command Prompt for VS"**
2. Open it and run:

```bat
cd D:\agent zero\!v2b\projects\cyberpunk\testers\quickhack\customentity2\red4ext
rmdir /s /q build
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DRED4EXT_SDK_PATH="C:/red4ext-sdk/include"
cmake --build . --config Release
```

DLL output: `build\OrbHackingBridge.dll`

---

## Do You Need VS Code?

**No.** Both methods above are pure command line.

---

## Troubleshooting

| Issue | Fix |
|---|---|
| `nmake not found` | Use Method A (VS generator), or run from x64 Native Tools Command Prompt |
| `Cannot open RED4ext/RED4ext.hpp` | Download the RED4ext SDK and pass `-DRED4EXT_SDK_PATH="C:/path/to/sdk/include"` |
| `cmake: command not found` | Install CMake or use Developer Command Prompt which includes it |
| `No CMAKE_C_COMPILER found` | Ensure "Desktop development with C++" workload is installed |
| Wrong architecture (32-bit) | VS generator: add `-A x64`. NMake: use `vcvars64.bat` not `vcvars32.bat` |
| Previous build cache conflicts | Delete the `build` folder and recreate it |

---

## Quick Reference

| Method | Generator | Any prompt? | Output |
|---|---|---|---|
| A (recommended) | `Visual Studio 17 2022` | Yes | `build\Release\OrbHackingBridge.dll` |
| B | NMake Makefiles | No — needs dev shell | `build\OrbHackingBridge.dll` |
