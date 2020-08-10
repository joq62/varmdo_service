%% This is the application resource file (.app file) for the 'base'
%% application.
{application, varmdo_service,
[{description, "varmdo_service  " },
{vsn, "1.0.0" },
{modules, 
	  [varmdo_service_app,varmdo_service_sup,varmdo_service]},
{registered,[varmdo_service]},
{applications, [kernel,stdlib]},
{mod, {varmdo_service_app,[]}},
{start_phases, []}
]}.
