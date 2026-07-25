import json, time
import argostranslate.translate as T
langs=T.get_installed_languages()
en=next(l for l in langs if l.code=='en'); hi=next(l for l in langs if l.code=='hi')
tr=en.get_translation(hi)
cand=json.load(open("candidates.json"))
out=[]; t0=time.time()
for i,c in enumerate(cand):
    h=tr.translate(c["def"]).strip()
    out.append({"term":c["term"],"partOfSpeech":c["pos"],"hindi":h,
                "definition":c["def"],"example":c["ex"]})
    if i%250==0:
        with open("progress.txt","w") as f: f.write(f"{i}/{len(cand)} {time.time()-t0:.0f}s\n")
json.dump(out,open("words.gen.json","w"),ensure_ascii=False,indent=2)
with open("progress.txt","w") as f: f.write(f"DONE {len(out)}/{len(cand)} {time.time()-t0:.0f}s\n")
print("DONE",len(out))
