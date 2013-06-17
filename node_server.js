var net = require('net');
var httpHeaderDelimiter = '\r\n';

net.createServer(function(connection){
  connection.on('data', function(data){
    var httpReqest = data.toString();
    var req = requestParser(httpReqest);
    var res = responseGenerator({
      body: 'You asked for url: ' + req.url //you can add html tags in here.
    });
    connection.write(res);
    connection.on('data', function(data){ console.log("data", data.toString()) });
    // connection.end(); // you dont need content length because you are manually closing the connection
  })
}).listen(4000);

function requestParser(str){
  var httpReqestLines = str.split(httpHeaderDelimiter);
  var firstLine = httpReqestLines[0];
  var url = firstLine.split(' ')[1];

  return {
    // method: method,
    url: url
    // headers: headers
  }
}

function responseGenerator(res){
  var str = '';
  str += "HTTP/1.1 200 OK" + httpHeaderDelimiter;
  str += 'x-randomStatus: awesome' + httpHeaderDelimiter;  //do the content length here if you dont wanna use connection.end()
  str += 'Content-Length: ' + res.body.length + httpHeaderDelimiter;
  str += httpHeaderDelimiter;
  str += res.body;
  return str;
}