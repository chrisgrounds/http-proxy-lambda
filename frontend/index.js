module.exports.handler = (event, context, callback) => 
  callback(
    null,
    {
      statusCode: 200,
      headers: { "Content-Type": "text/html" },
      body: "<div id=\"root\"> <form action=\"render\" method=\"get\"> <input type=\"text\" name=\"url\"></input> <input type=\"submit\" value=\"Submit\"></input> </form> </div>"
    }
  )

