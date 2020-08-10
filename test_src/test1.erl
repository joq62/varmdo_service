%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test1). 
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([start/0]).



%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------



%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start()->
    ok=t1_test(),
    ok=t2_test(),
    ok=t3_test(),
   init:stop(),
    ok.


t1_test()->
    ok=application:start(varmdo_service),
    ok=application:start(mail_service),
    ok.

t2_test()->
    ?assertEqual({varme,"pa"},varmdo_service:varme("pa")),

    ok.
t3_test()->
      Receiver="service.varmdo@gmail.com",
    Sender="service.varmdo@gmail.com",

    Subject1="mfa varmdo_service info no",
    Msg1="Glurk",
    ?assertEqual(ok,mail_service:connect_send()),
    ?assertMatch({ok,_},mail_service:send_mail(Subject1,Msg1,Receiver,Sender)),
    ?assertEqual(ok,mail_service:disconnect_send()), 
    timer:sleep(12*1000),
    [{_From,"mfa",[MStr,FStr,Arg]}]=mail_service:get_mail_list(),
    L=rpc:call(node(),list_to_atom(MStr),list_to_atom(FStr),[Arg]),
    {device_info,DeviceInfo}=lists:keyfind(device_info,1,L),
    {sensor_info,SensorInfo}=lists:keyfind(sensor_info,1,L),
    Dev1=[Id++"="++Value++"; "||{_,Id,Value}<-DeviceInfo,
		     Id/="ej anvand"],
    Sens1=lists:append([Id++"="++Temp++"; "||{Id,Temp}<-SensorInfo],
		       [Id++"="++Temp++"; "||{Id,Temp,_}<-SensorInfo]),
    Info=lists:append(Dev1,Sens1),
    Dev2=unicode:characters_to_list(Dev1,unicode),
    Sens2=unicode:characters_to_list(Sens1,unicode),
    io:format("~p~n",[Dev2]),
    io:format("~p~n",[Sens2]),
   % ?assertEqual(glurk,R),
    ok.

    %Subject2="{"++integer_to_list(Y)++","++integer_to_list(M)++","++integer_to_list(D)++"}",
    %?assertEqual(ok,mail_service:connect_send()),
    %?assertMatch({ok,_},mail_service:send_mail(Subject2,Msg1,Receiver,Sender)),
    %?assertEqual(ok,mail_service:disconnect_send()), 
