import json
import os

brain_dir = r"C:\Users\Ritesh Mahatme\.gemini\antigravity\brain"
found_files = []
for root, dirs, files in os.walk(brain_dir):
    for file in files:
        if file == "transcript.jsonl":
            found_files.append(os.path.join(root, file))

for path in found_files:
    try:
        with open(path, 'r', encoding='utf-8') as f:
            for line in f:
                try:
                    data = json.loads(line)
                    tool_calls = data.get("tool_calls", [])
                    if not tool_calls:
                        continue
                    for tool in tool_calls:
                        args = tool.get("args", {})
                        if isinstance(args, str):
                            try:
                                args = json.loads(args)
                            except:
                                pass
                        target = args.get("TargetFile", "")
                        if target and "home_screen.dart" in target:
                            content = args.get("CodeContent", "") or args.get("ReplacementContent", "")
                            print(f"File {path[-40:]} step={data.get('step_index')} len={len(content)} start={repr(content[:60])}")
                except Exception as e:
                    pass
    except Exception as e:
        pass
print("Done.")
