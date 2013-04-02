GETSDONE  = "http://192.168.174.135:9292/";
REST      = GETSDONE + "api";
AUTH      = GETSDONE + "auth";

function login() {

  $.ajax({
    type: "GET",
    url: AUTH + "/login",
    success: function( data, textStatus, xhr ) {
      console.log(xhr);
      window.location.href = data.msg;
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
    },
    dataType: "json"
  });

} // login


function logout() {

  $.ajax({
    type: "PUT",
    url: AUTH + "/logout",
    success: function( data, textStatus, xhr ) {
      console.log(xhr);
      window.location.href = "/";
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
    },
    datatype: "json"
  });

} // logout


function follow(id) {

   $.ajax({
    type: "POST",
    url: REST + "/user/" + id,
    data: {
      "verb": "follow"
    },
    success: function( data, textStatus, xhr ) {
      console.log(xhr);
      window.location.reload();
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
    },
    datatype: "json"
  });
 
} // follow


function unfollow(id) {

  $.ajax({
    type: "PUT",
    url: REST + "/user/" + id,
    data: {
      "verb": "unfollow"
    },
    success: function( data, textStatus, xhr ) {
      console.log(xhr);
      window.location.reload();
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
    },
    datatype: "json"
  });

} // unfollow


function addAction() {
  
  var text = document.getElementById("action").value;

  var priority = parsePriority(text);
  var owner    = parseOwner(text);
  var hashTag  = parseHashTag(text);

  $.ajax({
    type: "POST",
    url: REST + "/actions",
    data: {
      "action": document.getElementById("action").value,
      "hashtag": hashTag,
      "priority": priority,
      "owner": owner
    },
    success: function( data, textStatus, xhr ) {
      console.log(data);
      window.location.reload();
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
    },
    dataType: "json"
  });

} // addAction


function deleteAction(id) {

  $.ajax({
    type: "DELETE",
    url: REST + "/actions/" + id,
    success: function( data, textStatus, xhr ) {
      console.log(data);
      window.location.reload();
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
    },
    datatype: "json"
  });

} // deleteAction


function completeAction(id) {

   $.ajax({
    type: "PUT",
    url: REST + "/actions/" + id,
    success: function( data, textStatus, xhr ) {
      console.log(data);
      window.location.reload();
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
    },
    datatype: "json"
  });

 
} // completeAction


function assignDialog(id) {

  alert(id);

} // assign_dialog


function parseOwner(text) {
  
  var username = text.match("[@]+[A-Za-z0-9-_]+");
  
  if( username != null ) {
    return username[0].replace( "@", "" );
  }
  else {
    return null;
  }
  
} // parseOwner


function parsePriority(text) {

  var priority = text.match("[!]+[1-3]");
  
  if( priority != null ) {
    return priority[0].replace( "!", "" );  
  }
  else {
    return null;
  }
  
} // parsePriority


function parseHashTag(text) {

  var hashTag = text.match("[#]+[a-zA-Z0-9]+");
  
  if( hashTag != null ) {
    return hashTag[0].replace( "#", "" );
  }
  else {
    return null;
  }
  
} // parseHashTag

