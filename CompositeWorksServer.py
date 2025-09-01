# Copyright (c) 2025 Jonas Costa Campos
# Server-side of CompositeWorks (https://github.com/jonasCCa/CompositeWorks)

from flask import Flask
from flask import request

app = Flask(__name__)

compositeNumbers = [0] * 32
compositeBools   = ['0'] * 32

@app.route("/postComposite")
def postComposite():
    if 'n' in request.args and 'b' in request.args:

        numbers = request.args.get('n').split(',')
        bools = request.args.get('b').split(',')
        for i in range(32):
            compositeNumbers[i] = float(numbers[i])
            compositeBools[i] = bools[i]
        
        return "OK", 200
    else:
        return "Bad Request", 400
    
@app.route("/getComposite")
def getComposite():
    responseN = ""
    responseB = ""
    
    for i in range(32):
        responseN += str(compositeNumbers[i]) + ","
        responseB += compositeBools[i]
    
    return responseN + responseB, 200