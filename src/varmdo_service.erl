%%% -------------------------------------------------------------------
%%% Author  : Joq Erlang
%%% Description : test application calc
%%%  
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(varmdo_service). 

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state,{}).

%% Definitions 
-define(HB_interval,10*1000).
-define(Sender,"service.varmdo@gmail.com").
%% --------------------------------------------------------------------
-export([varme/1,
	 info/1	 
	]).

-export([start/0,
	 stop/0,
	 ping/0,
	 heart_beat/0
	]).

%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================

%% Asynchrounus Signals



%% Gen server functions

start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).



%%-----------------------------------------------------------------------
ping()->
    gen_server:call(?MODULE, {ping},infinity).

varme(Args)->
    gen_server:call(?MODULE, {varme,Args},infinity).
info(Args)->
    gen_server:call(?MODULE, {info,Args},infinity).    


%%-----------------------------------------------------------------------
heart_beat()->
    gen_server:cast(?MODULE, {heart_beat}).


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%
%% --------------------------------------------------------------------
init([]) ->
    spawn(fun()->h_beat() end),  
    {ok, #state{}}.
%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (aterminate/2 is called)
%% --------------------------------------------------------------------
handle_call({ping}, _From, State) ->
    Reply={pong,node(),?MODULE},
    {reply, Reply, State};

handle_call({varme,"pa"}, _From, State) ->
     Reply={varme,"pa"},
    {reply, Reply, State};
handle_call({varme,"av"}, _From, State) ->
     Reply={varme,"av"},
    {reply, Reply, State};

handle_call({info,_}, _From, State) ->
    Reply=rpc:call(node(),varmdo_lib,info,[]),
    {reply, Reply, State};


handle_call({stop}, _From, State) ->
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast({heart_beat}, State) ->
    spawn(fun()->h_beat() end),  
    {noreply, State};

handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
h_beat()->
    timer:sleep(?HB_interval),
    [MailService|_]=sd_service:fetch_service("mail_service"),
    MailList=rpc:call(MailService,mail_service,get_mail_list,[]),
    execute(MailList),
    
    rpc:cast(node(),?MODULE,heart_beat,[]).

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

execute([])->
    ok;

execute([{From,Cmd,[M,F,A]}|T])->
    [Service|_]=sd_service:fetch_service(M),
    case rpc:call(Service,list_to_atom(M),list_to_atom(F),[A]) of
	{reply,Subject,Msg}->
	    [MailService|_]=sd_service:fetch_service("mail_service"),
	    ok=rpc:call(MailService,mail_service,connect_send,[]),
	    {ok,_}=rpc:call(MailService,mail_service,send_mail,[Subject,Msg,From,?Sender]),
	    ok=rpc:call(MailService,mail_service,disconnect_send,[]),
	    ok=rpc:call(MailService,mail_service,delete_mail,[From,Cmd,[M,F,A]]);
	 no_reply->
	    [MailService|_]=sd_service:fetch_service("mail_service"),
	    ok=rpc:call(MailService,mail_service,delete_mail,[From,Cmd,[M,F,A]]);
	Err->
	    io:format("~p~n",[{?MODULE,?LINE,Err}])
    end,
    execute(T).
    
