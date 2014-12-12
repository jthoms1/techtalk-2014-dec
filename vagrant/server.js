var http = require('http');
var cpus = require('os').cpus().length;
var throng = require('throng');

http.globalAgent.maxSockets = Infinity;

var PORT = process.env.PORT || 3000;

throng(start, {
  workers: cpus * 2,
  lifetime: Infinity
});

function start() {
  console.log('Server listening to port ' + PORT);

  var server;

  process.on('SIGTERM', exit);

  server = http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello Earthlings!\n');
  });
  server.listen(PORT);

  function exit(reason) {
    console.log('Server closing' + reason);

    if (server)  {
      server.close(process.exit.bind(process));
    } else {
      process.exit();
    }
  }
}

