
import os
import re
import random
import time

import stanza
import pandas as pd

out_lemma = "data-raw/txts-lemmas/"
out_ent = "data-raw/txts-entities/"
infolder = 'data-raw/txts/'

## Helpers ---------------------------------------------------------------

def get_lemmas(doc): 
    data = []
    for sent_id, sent in enumerate(doc.sentences):
        ent_dict = {token.id[0]: ent.type for ent in sent.ents for token in ent.tokens}

        sent_data = [{
            'sentence_id': sent_id + 1,
            'token_id': i + 1,
            'token': token.text,
            'lemma': token.lemma,
            'pos': token.upos,
            'entity_type': ent_dict.get(i + 1, '')
        } for i, token in enumerate(sent.words)]
        
        data.extend(sent_data)
        
    return pd.DataFrame(data)

def get_entities(doc):
    out = [(ent.text, ent.type) for ent in doc.entities]
    return pd.DataFrame(out, columns = ['entity', 'type'])

# Program ---------------------------------------------------------------

# stanza.download('es', os.path.realpath("data-raw"))
nlp = stanza.Pipeline(
    lang ='es', 
    dir = os.path.realpath("data-raw"), 
    processors = 'tokenize,pos,lemma,ner',
    verbose = False,
    use_gpu = True,
)
nlp.max_length = 5000000

cases = [re.sub(r'\.txt$', '', f) for f in os.listdir(infolder)]
cases_done = [re.sub(r'\.parquet$', '', f) for f in os.listdir(out_lemma)]
cases_left = list(set(cases) - set(cases_done))

while len(cases_left) > 0:

    print(time.ctime())
    print(f"{len(cases_done)} done, {len(cases_left)} remaining")
    
    xl = random.sample(cases_left, k = min(20, len(cases_left))) 
    txtl = [open(infolder + x + '.txt', 'r').read() for x in xl]

    print(f"Working simultaneously on: {xl}")

    # in_docs = [stanza.Document([], text = d) for d in txtl] 
    # out_docs = nlp(in_docs)
    out_docs = nlp.bulk_process(txtl)

    for i, doc in enumerate(out_docs):
        df_lemma = get_lemmas(doc)
        df_lemma.insert(0, 'id', xl[i])
        df_lemma.to_parquet(out_lemma + xl[i] + '.parquet')

        df_ents = get_entities(doc)
        df_ents.insert(0, 'id', xl[i])
        df_ents.to_parquet(out_ent + xl[i] + '.parquet')

        cases_left.remove(xl[i])
        cases_done.append(xl[i])

