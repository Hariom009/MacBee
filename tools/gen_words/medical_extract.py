# PURE medical dictionary from open WordNet (NOT MedlinePlus/A.D.A.M., which is
# copyrighted and forbids reuse): keep a word only if its dominant sense sits in
# the medical domain (disease/symptom/drug/procedure subtrees + medicine topic tags).
import json, random
from nltk.corpus import wordnet as wn
POS={'n':'noun','v':'verb','a':'adjective','s':'adjective','r':'adverb'}
BAD=("genital","sexual","obscene","racial","ethnic slur")
EXCLUDE=("cigar","a quick look","liquor","liqueur","tobacco","brandy","whiskey")
def closure(seeds, rel):
    seen=set(seeds); st=list(seeds)
    while st:
        s=st.pop()
        for h in rel(s):
            if h not in seen: seen.add(h); st.append(h)
    return seen
roots=[]
for n in ['disease.n.01','symptom.n.01','pathology.n.01','drug.n.01','operation.n.05','medical_procedure.n.01']:
    try: roots.append(wn.synset(n))
    except Exception: pass
sub=closure(roots, lambda s: s.hyponyms()+s.instance_hyponyms())
domain_names=['medicine','pathology','anatomy','physiology','pharmacology','surgery','psychiatry','immunology']
med_domain=set()
for dn in domain_names: med_domain |= set(wn.synsets(dn,'n'))
dom_syns={s for s in wn.all_synsets() if any(td in med_domain for td in s.topic_domains())}
domain=sub|dom_syns
cands={l.name() for s in domain for l in s.lemmas()}
rows={}
for w in cands:
    if not(w.isalpha() and w.islower() and 3<=len(w)<=20): continue
    syns=wn.synsets(w)
    if not syns or syns[0] not in domain: continue
    syn=syns[0]; d=syn.definition(); dl=d.lower()
    if any(b in dl for b in BAD) or any(x in dl for x in EXCLUDE): continue
    rows[w]=(POS[syn.pos()], d, syn.examples()[0] if syn.examples() else "")
sel=list(rows); random.Random(42).shuffle(sel)
print("PURE medical words:", len(sel))
json.dump([{"term":w,"pos":rows[w][0],"def":rows[w][1],"ex":rows[w][2]} for w in sel],
          open("medical_candidates.json","w"), ensure_ascii=False)
print("=== sample 18 ===")
for w in random.Random(9).sample(sel,18): print("  %-18s %-9s %s"%(w,rows[w][0],rows[w][1][:36]))
