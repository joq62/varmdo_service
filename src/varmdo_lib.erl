%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(varmdo_lib).
  


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------

%% External exports


-export([info/0,
	 varme/1
	]).


%% ===================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
info()->
    [TellstickNode|_]=sd_service:fetch_service("tellstick_service"),
    L=rpc:call(TellstickNode,tellstick_service,get_all_info,[]),
    {device_info,DeviceInfo}=lists:keyfind(device_info,1,L),
    {sensor_info,SensorInfo}=lists:keyfind(sensor_info,1,L),
    Dev1=[Id++"="++Value++"; "||{_,Id,Value}<-DeviceInfo,
		     Id/="ej anvand"],
    Sens1=lists:append([Id++"="++Temp++"; "||{Id,Temp}<-SensorInfo],
		       [Id++"="++Temp++"; "||{Id,Temp,_}<-SensorInfo]),
   
   % Dev2=unicode:characters_to_list(Dev1,unicode),
   % Sens2=unicode:characters_to_list(Sens1,unicode),
   % io:format("~p~n",[Dev2]),
   % io:format("~p~n",[Sens2]),
    Subject="Info",
    Msg=unicode:characters_to_list([Dev1,Sens1],unicode),
    io:format("~p~n",[Msg]),
    {reply,Subject,Msg}.
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
%filter_events(Key
varme("ON")->
    [TellstickNode|_]=sd_service:fetch_service("tellstick_service"),
    rpc:call(TellstickNode,tellstick_service,set_device,["element_koket","on"]),
     rpc:call(TellstickNode,tellstick_service,set_device,["element_vardagsrum","on"]),
    no_reply;
varme("OFF")->
    [TellstickNode|_]=sd_service:fetch_service("tellstick_service"),
    rpc:call(TellstickNode,tellstick_service,set_device,["element_koket","off"]),
     rpc:call(TellstickNode,tellstick_service,set_device,["element_vardagsrum","off"]),
    no_reply.
