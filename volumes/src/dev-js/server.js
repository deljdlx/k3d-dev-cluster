const http = require("http");
const port = 3000;
http.createServer((req, res) => {
  res.end("Hello World!"); }).listen(port);
  console.log("Server running on port " + port);

