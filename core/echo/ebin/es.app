{application, es,
 [{description, "Echo Server remember what you told"},
  {vsn, "0.1.0"},
  {modules, [es_app,
			 es_sup,
			 es_store,
			 echo_server]},
  {registered, [es_sup]},
  {applications, [kernel, stdlib]},
  {mod, {es_app, []}}
 ]}.
