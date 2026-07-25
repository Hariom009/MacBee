# PURE emotions dictionary: a word is kept only if its DOMINANT WordNet sense is
# itself inside the emotion/feeling/mood domain — so no generic words (able, dingy).
import json, random
from nltk.corpus import wordnet as wn
from wordfreq import zipf_frequency
POS={'n':'noun','v':'verb','a':'adjective','s':'adjective','r':'adverb'}
BAD=("genital","sexual","penis","vagina","obscene","vulgar","offensive term",
     "racial","ethnic slur","buttock","copulat","masturbat","erotic","anus","lecher","lust")
def closure(seeds, rel):
    seen=set(seeds); st=list(seeds)
    while st:
        s=st.pop()
        for h in rel(s):
            if h not in seen: seen.add(h); st.append(h)
    return seen
roots=[wn.synset('emotion.n.01'), wn.synset('feeling.n.01'), wn.synset('mood.n.01')]
emo_nouns=closure(roots, lambda s: s.hyponyms()+s.instance_hyponyms())
emo_adjs=set(); emo_verbs=set()
for s in emo_nouns:
    for l in s.lemmas():
        for r in l.derivationally_related_forms():
            rs=r.synset()
            if rs.pos() in ('a','s'): emo_adjs.add(rs)
            elif rs.pos()=='v': emo_verbs.add(rs)
for adj in wn.all_synsets('a'):
    if any(a in emo_nouns for a in adj.attributes()): emo_adjs.add(adj)
domain=emo_nouns|emo_adjs|emo_verbs
cands={l.name() for s in domain for l in s.lemmas()}
rows={}
for w in cands:
    if not (w.isalpha() and w.islower() and 3<=len(w)<=16): continue
    if zipf_frequency(w,"en")<0.0: continue
    syns=wn.synsets(w)
    if not syns or syns[0] not in domain: continue     # DOMINANT sense must be an emotion
    syn=syns[0]; d=syn.definition()
    if any(b in d.lower() for b in BAD): continue
    rows[w]=(POS[syn.pos()], d, syn.examples()[0] if syn.examples() else "")
sel=list(rows); random.Random(42).shuffle(sel)
print("PURE emotion words:", len(sel))
json.dump([{"term":w,"pos":rows[w][0],"def":rows[w][1],"ex":rows[w][2]} for w in sel],
          open("emotions_candidates.json","w"), ensure_ascii=False)
print("=== sample 22 ===")
for w in random.Random(6).sample(sel,22): print("  %-14s %-9s %s"%(w,rows[w][0],rows[w][1][:40]))
