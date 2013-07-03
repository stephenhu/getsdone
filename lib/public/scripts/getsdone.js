GETSDONE  = "https://getsdone.io/";
REST      = GETSDONE + "api";
AUTH      = GETSDONE + "auth";

function signup() {

  $.ajax({
    type: "POST",
    url: REST + "/users",
    data: {
      name: document.getElementById("username").value,
      email: document.getElementById("email").value,
      password: document.getElementById("password").value
    },
    success: function( data, textStatus, xhr ) {
      console.log(xhr);
      window.location.href = "/home";
    },
    error: function( xhr, textStatus, msg ) {
      r = JSON.parse(xhr.responseText);
      console.log(r.msg);
      alert(r.msg);
    },
    datatype: "json"
  });

} // signup


function login() {

  $.ajax({
    type: "POST",
    url: AUTH + "/login",
    data: {
      name: document.getElementById("username").value,
      password: document.getElementById("password").value
    },
    success: function( xhr, textStatus, msg ) {
      r = JSON.parse(msg.responseText);
      window.location.href = "/home";
    },
    error: function( xhr, textStatus, msg ) {
      r = JSON.parse(xhr.responseText);
      alert(r.msg);
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
      window.location.href = "/login";
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
    },
    datatype: "json"
  });

} // logout


function follow(id) {

   $.ajax({
    type: "PUT",
    url: REST + "/users/" + id + "/followers",
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
    type: "DELETE",
    url: REST + "/users/" + id + "/followers",
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


function addAction(isReassign) {

  if(isReassign) {
    var reassignid = document.getElementById("actionid").value;
    var text = document.getElementById("reassignment").value;
  }
  else {
    var reassignid = null;
    var text = document.getElementById("action").value;
  }

  var owners   = twttr.txt.extractMentions(text);
  var hashtags = twttr.txt.extractHashtags(text);

  $.ajax({
    type: "POST",
    url: REST + "/actions",
    data: {
      "reassignid": reassignid,
      "action": text,
      "hashtags": hashtags,
      "owners": owners
    },
    success: function( data, textStatus, xhr ) {
      console.log(data);
      window.location.reload();
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
      alert("Unable to add action");
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


function reassignDialog(id) {

  $("#rcounter").text("140");
  original = $("#"+id).html();

  $("#current").html(original);
  $("#actionid").val(id);

  $("#reassign-dialog").dialog("open");

  $("#reassignment").val("");
  $("#reassignment").focus();

} // reassignDialog


function addComment(id) {

  var comment = document.getElementById("comment" + id).value;

  $.ajax({
    type: "POST",
    url: REST + "/actions/" + id + "/comments",
    data: {
      comment: comment
    },
    success: function( data, textStatus, xhr ) {
      prependComment( id, data );
      clearComment(id);
      incrementComment(id);
    },
    error: function( xhr, textStatus, msg ) {
      console.log(msg);
    },
    datatype: "json"
  });

} // addComment


function prependComment( id, data ) {

  response = JSON.parse(data);

  username = document.getElementById("username").value;
  gravatar = document.getElementById("gravatar").value;

  var comments = document.getElementById("clist" + id);

  var comment = document.createElement("div");
  var header  = document.createElement("div");
  var icon    = document.createElement("img");
  var user    = document.createElement("a");
  var text    = document.createElement("p");

  comment.setAttribute( "id", "dd" + response.msg.comment.id );
  comment.className = "comment";

  header.className = "comment-header form-inline";

  icon.setAttribute( "src", gravatar );
  icon.setAttribute( "width", "32" );
  icon.className = "pull-left spacing";

  user.setAttribute( "href", "/users/" + username );
  user.className = "pull-left spacing";
  user.innerHTML = "@" + username + ": ";

  text.className = "since";
  text.innerHTML = response.msg.comment.comment + " (now)";

  header.appendChild(icon);
  header.appendChild(user);
  header.appendChild(text);
  comment.appendChild(header);

  comments.insertBefore( comment, comments.childNodes[0] );

} // prependComment


function clearComment(id) {

  var comment = document.getElementById("comment" + id);

  comment.value = "";

} // clearComment


function incrementComment(id) {

  var comment = document.getElementById("vc" + id);

  a = comment.innerHTML.match(/([0-9]+)/);
  a = parseInt(a[0]) + 1;
  comment.innerHTML = "comments (" + a + ")";

} // incrementComment


function viewComments(id) {

  if( $("#c" + id).hasClass("hide") ) {
    $("#c" + id).removeClass("hide");
  }
  else {
    window.location.hash = "";
    $("#c" + id).addClass("hide");
  }

} // viewComments


function openComments() {

  var hash = window.location.hash.replace( "#", "" );
  viewComments(hash);
  
} // reloadComments


function parseReassign(text) {

  var before = text[0].trim();
  //var users  = before.match(/(?:\s|^)@[a-zA-Z0-9]+/g);

  if( users != null ) {
    alert(users);
  }
  else {
    alert("please add a user to reassign, e.g. @stephen");
  }

} // parseReassign


function parsePriority(text) {

  var priority = text.match("\B!{1}[1-3]");
  
  if( priority != null ) {
    return priority[0].replace( "!", "" );  
  }
  else {
    return null;
  }
  
} // parsePriority


function count( element, counter_name ) {
 
  var action  = element.value;
  var counter = document.getElementById(counter_name);
  
  counter.firstChild.nodeValue = 140 - action.length;
  
} // count


function goto(page) {

  window.location.href = page;

} // goto

