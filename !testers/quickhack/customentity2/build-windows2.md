run 'x64 Native Tools Command Prompt'

```bash
cd D:\agent zero\!v2b\projects\cyberpunk\testers\quickhack\customentity2\red4ext
rmdir /s /q build
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DRED4EXT_SDK_PATH="D:\agent zero\!v2b\projects\cyberpunk\sdk\RED4ext.SDK\include"
cmake --build . --config Release
```

DLL output: `build\Release\OrbHackingBridge.dll`