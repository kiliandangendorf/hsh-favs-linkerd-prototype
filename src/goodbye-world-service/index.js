//now it load express module with `require` directive
var express = require('express')
//var axios = require('axios');
const fetch = require("node-fetch");
//var fetch = require('fetch');
var app = express()
//Define request response in root URL (/) and response with text Hello World!
app.get('/', function (req, res) {
  console.log('get')
  res.send('Goodbye short World!')
})

app.get('/goodbyeworld/', function (req, res) {
  console.log('get')
  res.send('Goodbye long long World!')
})

app.get('/goodbyeworld/v2/:id', function (req, res) {
  var id = req.params.id;
  console.log('get by id'+id)
//  rex = axios.get('http://nameapi.default.svc.cluster.local:80/nameapi/1')
//  console.log('res'+rex)
//  var mydata = JSON.parse(rex);
//  let response = fetch('http://nameapi.default.svc.cluster.local:80/nameapi/1')
  fetch('http://nameapi.default.svc.cluster.local:80/nameapi/1')
    .then(res => res.json())
    .then(json => res.send('Goodbye World '+json.name));
//    .then(json => console.log(json.name);res.send('Goodbye World '+json.name));
//  let data = response.json()
//  console.log('data'+response)
//  res.send('Goodbye World!'+rex.data["name"])
})

// POST method route
app.post('/', function (req, res) {
  console.log('post')
  res.send('POST request to the homepage');
});

//Launch listening server on port 8080 and consoles the log.
app.listen(8080, function () {
  console.log('app listening on port 8080!')
})
