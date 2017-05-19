// iOS push testing
Parse.Cloud.define("iosPushTest", function(request, response) {

  // request has 2 parameters: params passed by the client and the authorized user                                                                                                                               
  var params = request.params;
  console.log(params)
  var user = request.user;
console.log(user)


  // Our "Message" class has a "text" key with the body of the message itself                                                                                                                                    
  var messageText = params.text;
	
	console.log(messageText)

  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo('deviceType', 'ios'); // targeting iOS devices only                                                                                                                                          

	console.log(pushQuery)

  Parse.Push.send({
    where: pushQuery, // Set our Installation query                                                                                                                                                              
    data: {
      alert: "Message: " + messageText
    }
  }, { success: function() {
      console.log("#### PUSH OK");
     response.success('success');
  }, error: function(error) {
      console.log("#### PUSH ERROR" + error.message);
  }, useMasterKey: true});

 
});