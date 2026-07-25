import json, random
from nltk.corpus import wordnet as wn
from wordfreq import zipf_frequency
POS={'n':'noun','v':'verb','a':'adjective','s':'adjective','r':'adverb'}
# skip crude/sensitive glosses — keep a daily widget wholesome
BAD=("genital","sexual","penis","vagina","obscene","vulgar","offensive term",
     "racial","ethnic slur","slang","buttock","copulat","masturbat","erotic","anus")
LO,HI=3.0,5.6   # zipf band: known but not trivial; ~good vocab
cands=set()
for syn in wn.all_synsets():
    if syn.pos() not in POS: continue
    for lem in syn.lemmas():
        n=lem.name()
        if n.isalpha() and n.islower() and 4<=len(n)<=14:
            cands.add(n)
rows={}
for w in cands:
    z=zipf_frequency(w,'en')
    if not (LO<=z<=HI): continue
    syn=wn.synsets(w)[0]                      # dominant sense
    d=syn.definition()
    if any(b in d for b in BAD): continue
    ex=syn.examples()[0] if syn.examples() else ""
    rows[w]=(POS[syn.pos()],d,ex,z)
allw=list(rows)
print(f"in-band candidates: {len(allw)}")
TARGET=12000
sel=allw if len(allw)<=TARGET else random.Random(7).sample(allw,TARGET)
random.Random(42).shuffle(sel)
with_ex=sum(1 for w in sel if rows[w][2])
print(f"selected: {len(sel)} | with example: {with_ex} ({100*with_ex//len(sel)}%)")
print("=== random 18 (quality eyeball) ===")
for w in random.Random(3).sample(sel,18): print(f"  {w:14} {rows[w][0]:9} z={rows[w][3]:.1f}  {rows[w][1][:52]}")
json.dump([{"term":w,"pos":rows[w][0],"def":rows[w][1],"ex":rows[w][2]} for w in sel],
          open("candidates.json","w"), ensure_ascii=False)
print("wrote candidates.json")
