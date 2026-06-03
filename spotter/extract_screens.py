import re

data = open('figma-plugin/code.js', 'r', encoding='utf-8').read()
# Find all top-level screen names (4 spaces indent)
names = re.findall(r'^\s{4}"name":\s*"(.+?)"', data, re.MULTILINE)
print(f"Total screens: {len(names)}")
for i, n in enumerate(names, 1):
    print(f"{i}. {n}")
