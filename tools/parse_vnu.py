#!/usr/bin/env python3
import json,sys
fn = sys.argv[1] if len(sys.argv)>1 else 'vnu-out.json'
try:
    j=json.load(open(fn))
except Exception as e:
    print('ERR: failed to load',fn,e); sys.exit(2)
msgs=j.get('messages',[])
if not msgs:
    print('No messages (valid HTML)')
    sys.exit(0)
from collections import Counter
types=Counter(m.get('type','unknown') for m in msgs)
for t,c in types.items(): print(f"{t}: {c}")
print('---')
for m in msgs[:50]:
    loc = f"{m.get('lastLine')}:{m.get('lastColumn')}" if m.get('lastLine') else ''
    print(f"[{m.get('type')}] [{loc}] {m.get('message')}")
sys.exit(1)
