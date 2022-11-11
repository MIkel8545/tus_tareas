import 'dart:convert';

final String _baseUrl = 'https://tareasapp-120e6-default-rtdb.firebaseio.com';

Future<String> login(String email, String password) async {
  final Map<String, dynamic> authData = {'email': email, 'password': password};

  final url = Uri.https(_baseUrl, '/usuarios/accounts:signInWithPassword',
      {'key': _firebaseToken});

  final resp = await http.post(url, body: jsonEncode(authData));
  final Map<String, dynamic> decodeResp = json.decode(resp.body);


  if( decodeResp,containsKey('idToken')){

    return null;

  }
  else{
    return decodeResp['error']['message'];
  }


}
