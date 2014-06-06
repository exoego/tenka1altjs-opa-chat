type message = {user author, string text} 
type rgb = (int, int, int)
type state = {IN} or {OUT}
type user = {string name, rgb textColor, state state} 

module Chatroom {

  private Network.network(message) room = Network.cloud("room")
  private Network.network(user) users = Network.cloud("users")

  exposed function broadcast(message) {
    Network.broadcast(message, room);
  }

  exposed function broadcast_user(author) {
    Network.broadcast(author, users);
  }

  function register_message_callback(callback) {
    Network.add_callback(callback, room);
  }

  function register_user_callback(callback) {
    Network.add_callback(callback, users);
  }

  function new_author() {
  	textColor = (Random.int(160), Random.int(160), Random.int(160));
    {name:"user_" + String.uppercase(Random.string(4)), ~textColor, state:{IN}}
  }
}