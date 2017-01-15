{application, ht,
 [{description, "Hunter Server, go hunt from Baidu zhidao"},
  {vsn, "0.1.0"},
  {modules, [ht_app,
			 ht_sup,
			 ht_store,
			 hunt_server]},
  {registered, [ht_sup]},
  {applications, [kernel, stdlib]},
  {mod, {ht_app, []}}
 ]}.
