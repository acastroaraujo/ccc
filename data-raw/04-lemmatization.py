
import os
import re
import random

import stanza
import pandas as pd

out_lemma = "data-raw/txts-lemmas/"
out_ent = "data-raw/txts-entities/"
infolder = 'data-raw/txts/'

## Helpers ---------------------------------------------------------------

def get_lemmas(doc): 
    data = []
    for sent_id, sent in enumerate(doc.sentences):
        ent_dict = {}
        for ent in sent.ents:
            for token in ent.tokens:
                ent_dict[token.id[0]] = ent.type

        for token_id, token in enumerate(sent.words):
            data.append({
                'sentence_id': sent_id + 1,
                'token_id': token_id + 1,
                'token': token.text,
                'lemma': token.lemma,
                'pos': token.upos,
                'entity_type': ent_dict.get(token_id + 1, '')
            })

    return(pd.DataFrame(data))

def get_entities(doc):
    out = pd.DataFrame([x.to_dict() for x in doc.entities])
    out = out.rename(columns={'text': 'entity'})
    out = out.drop(['start_char', 'end_char'], axis = 1)
    return(out)

# Program ---------------------------------------------------------------

nlp = stanza.Pipeline('es')
nlp.max_length = 3200000

cases = [re.sub(r'\.txt$', '', f) for f in os.listdir(infolder)]
cases_done = [re.sub(r'\.parquet$', '', f) for f in os.listdir(out_lemma)]
cases_left = list(set(cases) - set(cases_done))

while len(cases_left) > 0:

    x = random.choice(cases_left)
    print(f"{x}: {len(cases_left)} remaining")

    with open(infolder + x + ".txt", 'r') as ruling:
        txt = ruling.read()

    doc = nlp(txt)

    df_lemma = get_lemmas(doc)
    df_lemma.insert(0, 'id', x)
    df_lemma.to_parquet(out_lemma + x + '.parquet')

    df_ents = get_entities(doc)
    df_ents.insert(0, 'id', x)
    df_ents.to_parquet(out_ent + x + '.parquet')

    cases_left.remove(x)

