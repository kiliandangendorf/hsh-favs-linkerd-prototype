from typing import Optional
import requests

from fastapi import FastAPI

app = FastAPI()


@app.get("/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    response = requests.get("/nameapi/items/{}".format(item_id))
    return {"Hello World {}".format(response)}
