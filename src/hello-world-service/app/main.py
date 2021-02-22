from typing import Optional
import requests
import os
from fastapi import FastAPI

import logging

app = FastAPI()

@app.get("/")
def read_root():
    logging.info('calling "/helloworld/"-root')
    return {"Hello": "World"}

@app.get("/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    logging.info('calling "/helloworld/"-items')
    host=os.getenv('NAME_SERVICE_HOST', 'nameapi.default.svc.cluster.local:80')
    get_test_url= f"http://{host}/items/{item_id}/"
    response = requests.get(get_test_url).json()
    name=response["name"]
    return {"text": "Hello World {}".format(name)}

