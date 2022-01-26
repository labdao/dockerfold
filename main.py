from fastapi import FastAPI
from Bio.Seq import Seq

app = FastAPI()

@app.get("/")
def read_root():
    return {"hello" : "world"}

@app.get("/items/{item_id}")
def read_item(item_id: int):
    return {"item_id" : item_id}

@app.get("/revcomplement/{sequence}")
def read_revcomplement(sequence: str):
    dna_seq = Seq(sequence)
    rev_comp = dna_seq.reverse_complement()
    rev_comp = str(rev_comp) # converting to string
    return {"sequence" : rev_comp}

