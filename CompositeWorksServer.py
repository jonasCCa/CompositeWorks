# Copyright (c) 2025 Jonas Costa Campos
# Server-side of CompositeWorks (https://github.com/jonasCCa/CompositeWorks)

from flask import Flask
from flask import request

app = Flask(__name__)

compositeTable = {}

@app.route("/postComposite")
def postComposite():
    if 'n' in request.args and 'b' in request.args and 'id' in request.args:
        compositeNumber = [0] * 32
        compositeBool   = ['0'] * 32

        numbers = request.args.get('n').split(',')
        bools = request.args.get('b').split(',')
        for i in range(32):
            compositeNumber[i] = float(numbers[i])
            compositeBool[i] = bools[i]
        
        compositeTable.update({request.args.get('id') : {'number': compositeNumber, 'bool': compositeBool}})
        
        return "OK", 200
    else:
        return "Unprocessable Content", 422
    
@app.route("/getComposite")
def getComposite():
    responseN = ""
    responseB = ""
    responseCode = 0
    
    compositeNumber = None
    compositeBool   = None
    
    if not ('id' in request.args):
        responseCode = 422
    else:
        if request.args.get('id') in compositeTable:
            compositeNumber = compositeTable[request.args.get('id')]['number']
            compositeBool = compositeTable[request.args.get('id')]['bool']
            responseCode = 200
        else:
            responseCode = 404
        
    if responseCode != 200:
        compositeNumber = [0] * 32
        compositeBool   = ['0'] * 32

    for i in range(32):
        responseN += str(compositeNumber[i]) + ","
        responseB += compositeBool[i]
        
    return responseN + responseB, responseCode