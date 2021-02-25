from typing import Optional

from fastapi import FastAPI

app = FastAPI()

@app.get("/nameapi/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    if item_id == 1:
        return {"item_id": item_id, "name": "Kilian"}
    if item_id == 2:
        return {"item_id": item_id, "name": "Manuel"}
    if item_id == 3:
        return {"item_id": item_id, "name": "Eike"}
    if item_id == 4:
        return {"item_id": item_id, "name": "Christopher"}
    return {"item_id": item_id, "name": "Stranger (not in DB)"}
