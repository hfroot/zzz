#!flask/bin/python
from flask import Flask, jsonify, abort, make_response, request
#from flask_httpauth import HTTPBasicAuth
from temperature import svm_temp
#from .humidity import svm_humi

app = Flask(__name__)
#auth = HTTPBasicAuth()

input = {}

#@auth.get_password
#def get_password(username):
#	if username == 'zzz':
#		return 'goodnight!'
#	return None

#@auth.error_handler
#def unauthorized():
#	return make_response(jsonify({'error': 'Unauthorized access'}), 401) #use 403 code if browser keeps showing dialog box

#this block is for calling temperature
@app.route('/zzz/api/v1/temperature', methods=['POST'])
#@auth.login_required
def temperature():
    # check data input is correct
    if not request.json or not 'temp_mean' or not 'temp_max' in request.json:
        abort(400)
    # store input in dictionnary to send to svm function
    input = {
        'temp_mean': request.json['temp_mean'],
        'temp_max': request.json['temp_max']
    }
    # calculate classifier value based on input values
    temp_classifier = svm_temp(input)
    # return json string with result
    return jsonify({'temp_classifier': temp_classifier[0]}), 201

#this block is for calling humidity
#@app.route('/zzz/api/v1/humidity', methods=['POST'])
#@auth.login_required
#def create_board():
#    if not request.json or not 'id' or not 'timestamp' or not 'contents' in request.json:
#        abort(400)
#    board = {
#        'id': boards[-1]['id'] + 1,
#        'timestamp': request.json['timestamp'],
#        'contents': request.json['contents']
#    }
#    boards.append(board)
#    return jsonify({'board': board}), 201

@app.errorhandler(404)
def not_found(error):
	return make_response(jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
	app.run(debug=True, host="0.0.0.0")
