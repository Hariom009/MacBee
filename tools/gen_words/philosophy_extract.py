# PURE philosophy dictionary from open WordNet (NOT the Oxford book): keep a word
# only if its dominant sense sits in the philosophy domain (branch subtrees +
# doctrines + schools of thought + logic, plus WordNet topic-domain tags).
import json, random
from nltk.corpus import wordnet as wn
POS={'n':'noun','v':'verb','a':'adjective','s':'adjective','r':'adverb'}
BAD=("genital","sexual","obscene","racial","ethnic slur")
EXCLUDE=("christ","theolog","judaism","psychoanalys","islam","buddh","hindu","gospel",
         "bible","the church","irredent","expansionism","annex","territor")
def closure(seeds, rel):
    seen=set(seeds); st=list(seeds)
    while st:
        s=st.pop()
        for h in rel(s):
            if h not in seen: seen.add(h); st.append(h)
    return seen
root_names=['philosophy.n.02','philosophical_doctrine.n.01','school_of_thought.n.01',
            'logic.n.01','metaphysics.n.01','epistemology.n.01','ethics.n.01','aesthetics.n.01']
roots=[]
for n in root_names:
    try: roots.append(wn.synset(n))
    except Exception: pass
sub=closure(roots, lambda s: s.hyponyms()+s.instance_hyponyms())
domain_names=['philosophy','logic','metaphysics','epistemology','ethics','aesthetics','ontology']
phil_domain=set()
for dn in domain_names: phil_domain |= set(wn.synsets(dn,'n'))
dom_syns={syn for syn in wn.all_synsets() if any(td in phil_domain for td in syn.topic_domains())}
domain=sub|dom_syns
cands={l.name() for s in domain for l in s.lemmas()}
rows={}
for w in cands:
    if not(w.isalpha() and w.islower() and 3<=len(w)<=20): continue
    syns=wn.synsets(w)
    if not syns or syns[0] not in domain: continue      # dominant sense must be philosophy
    syn=syns[0]; d=syn.definition()
    dl=d.lower()
    if any(b in dl for b in BAD): continue
    if any(x in dl for x in EXCLUDE): continue
    rows[w]=(POS[syn.pos()], d, syn.examples()[0] if syn.examples() else "")
sel=list(rows); random.Random(42).shuffle(sel)
print("PURE philosophy words:", len(sel))
json.dump([{"term":w,"pos":rows[w][0],"def":rows[w][1],"ex":rows[w][2]} for w in sel],
          open("philosophy_candidates.json","w"), ensure_ascii=False)
print("=== sample 24 ===")
for w in random.Random(7).sample(sel,24): print("  %-18s %-9s %s"%(w,rows[w][0],rows[w][1][:38]))
