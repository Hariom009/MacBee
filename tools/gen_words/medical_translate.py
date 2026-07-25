import json, time
import argostranslate.translate as T
langs=T.get_installed_languages()
en=next(l for l in langs if l.code=='en'); hi=next(l for l in langs if l.code=='hi')
tr=en.get_translation(hi)
cand=json.load(open("medical_candidates.json"))
def has_dev(s): return any('ऀ'<=c<='ॿ' for c in s)
out=[]; t0=time.time()
for c in cand:
    h=tr.translate(c["def"]).strip()
    if not has_dev(h): h=""
    out.append({"term":c["term"],"partOfSpeech":c["pos"],"hindi":h,"definition":c["def"],"example":c["ex"]})
json.dump(out, open("/Users/hariom/Desktop/MacBee/MacBee/Shared/medical.json","w"),
          ensure_ascii=False, indent=2)
print(f"DONE {len(out)} -> medical.json ({sum(1 for w in out if w['hindi'])} hindi) in {time.time()-t0:.0f}s")
