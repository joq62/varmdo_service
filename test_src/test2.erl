%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test2). 
   
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
    ok=t2_test(5),
   init:stop(),
    ok.


t1_test()->
    ok=application:start(varmdo_service),
    ok.
t2_test(0)->
    ok;
t2_test(N)->
    varme("ON"),
    timer:sleep(1000),
    varme("OFF"),
    timer:sleep(1000),
    t2_test(N-1).

varme("ON")->
    TellstickNode='varmdo_1@rpi2',
    "Turning on device 2, vaermdo_main_kitchen_heater_1 - Success\n"=rpc:call(TellstickNode,tellstick_service,set_device,["element_koket","on"]),
    rpc:call(TellstickNode,tellstick_service,set_device,["element_vardagsrum","on"]),
    ok;

varme("OFF")->
    TellstickNode='varmdo_1@rpi2',
    rpc:call(TellstickNode,tellstick_service,set_device,["element_koket","off"]),
     rpc:call(TellstickNode,tellstick_service,set_device,["element_vardagsrum","off"]),
    ok.
