//now it load express module with `require` directive
var express = require('express')
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


// POST method route
app.post('/', function (req, res) {
  console.log('post')
  res.send('POST request to the homepage');
});

//Launch listening server on port 8080 and consoles the log.
app.listen(8080, function () {
  console.log('app listening on port 8080!')
})
