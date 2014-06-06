module View {
  PAGE_TITLE = "#tenka1altjs chat"

  function page_template(content) {
    <div class="navbar navbar-inverse navbar-fixed-top">{header(PAGE_TITLE)}</div>
    <div id=#main>{content}</div>
  }

  function header(title){
    <div class="container">
      <div class="collapse navbar-collapse">
        <ul class="nav navbar-nav">
          <li class="active"><a class="navbar-brand" href="#">{title}</a></li>
          <li><a href="#about" onclick={about_app}>About</a></li>
        </ul>
      </div>
    </div>
  }

  function chat_html(user author) {
    function init(_) {
      welcome(author);
      Chatroom.register_message_callback(post_message);
      Chatroom.register_user_callback(change_user_state);
      Dom.bind_unload_confirmation(function(_) {
        Chatroom.broadcast_user({author with state:{OUT}})
        none
      }); 
    }
    function post(_){ broadcast(author) } 

    <div id=#conversation class=container-fluid onready={init} />
    <div id=#footer class="navbar navbar-inverse navbar-fixed-bottom" role=navigation>
      <div class=container>
        <div class=row>   
          <div class="input-group">
            <input id=#entry type=text class=form-control placeholder="Message" onnewline={post} />
            <span class="input-group-btn">
              <button class="btn btn-primary" type=button onclick={post}>Post</button>
            </span>
          </div>
        </div>
      </div>
    </div>
  }
  
  function default_page() {
    author = Chatroom.new_author();
    Chatroom.broadcast_user(author);
    Resource.page(PAGE_TITLE, page_template(chat_html(author)));
  }

  function post_message(message msg) {
    line =
      <div class="row line">
        <div class="col-md-1 userpic">
          <span class="glyphicon glyphicon-user" style={user_style(msg.author)} />
        </div>
        <div class="col-md-2 user">{user_name(msg.author)}:</>
        <div class="col-md-9 message">{msg.text}</>
      </div>;
    #conversation += line;
  }

  function change_user_state(user author){
    message =
      match(author.state){
        case {IN}: "joined room !!!"
        case {OUT}: "left room..."
      }
    #conversation += system_message(<span>{user_name(author)} {message}</span>);
  }

  function welcome(author){
    #conversation += system_message(<span>Welcome, you joined room as {user_name(author)}</span>);
  }

  function about_app(author){
    about = 
      <div>
        <h2>About this app</h2>
        <p>Online chat app written in <a href="http://opalang.org/">Opa</a>.</p>
        <p>Code is customized from the original version found in  
          <a href="https://github.com/MLstate/opalang/wiki/Hello,-chat">Hello, chat</a>,
          as exercises to learn Opa.
        </p>
      </div>
    #conversation += system_message(about);
  }

  function user_name(author){
    <b style={user_style(author)}>{author.name}</b>
  }

  function user_style(author) {
    (r, g, b)  = author.textColor
    css { color: rgb(r, g, b) ; }
  }

  function system_message(message){
    <div class="row line">
      <div class="col-md-12">{message}</div>
    </div>
  }

  function broadcast(author) {
    text = Dom.get_value(#entry);
    Chatroom.broadcast(~{author, text});
    Dom.clear_value(#entry);
  }
}
