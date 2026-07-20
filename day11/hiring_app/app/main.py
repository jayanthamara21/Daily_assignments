from fastapi import FastAPI
#This imports the FastAPI class from the fastapi module

app = FastAPI()
#This creatas a FastApi application object

@app.get('/')
def home():
    return {'message': 'Welcome to the FastApi'}

'''
@app.get('/')
This is called a decorator.
It tells FastAPI:
"When someone sends a GET request to /, execute the function below"

home() - Python function
return - FastAPI automatically converts the dictionary to JSON
'''

