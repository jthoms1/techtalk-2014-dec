var http = require('http');
var cpus = require('os').cpus().length;

http.globalAgent.maxSockets = Infinity;

var PORT = process.env.PORT || 3000;

start();

function start() {
  console.log('Server listening to port ' + PORT);

  var server;

  process.on('SIGTERM', exit);

  server = http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello Earthlings!\n');
  });
  server.listen(PORT);
}

function exit(reason) {
  console.log('Server closing' + reason);
  process.exit();
}

