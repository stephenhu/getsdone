REST = "http://192.168.174.135:9292/api/";

function add_action() {
  
  var text = document.getElementById("action").value;

  var priority = parsePriority(text);
  var owner    = parseOwner(text);
  var hashTag  = parseHashTag(text);

  $.ajax({
    type: "POST",
    url: REST + "actions",
    data: {
      "action": document.getElementById("action").value,
      "hashtag": hashTag,
      "priority": priority,
      "owner": owner
    },
    success: function( data, textStatus, xhr ) {
      window.location.reload();
    },
    error: function( xhr, textStatus, msg ) {
      alert(msg);
    },
    dataType: "json"
  });

} // add_action


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

