Ū    
      l      ŧ       đ   Y  ņ   Ú  K    &  `  *	  H  
  Ö  Ô  }  Ģ  ;  )     e  I    ž  Ë  W    U  â  g  8  F     B  į#  Ô  *&  Û  ˙'     Û)     
                  	                      Configures the given application.

Keyword lists are always deep merged.

## Examples

The given `opts` are merged into the existing configuration
for the given `app`. Conflicting keys are overridden by the
ones specified in `opts`. For example, the declaration below:

    config :lager,
      log_level: :warn,
      mode: :truncate

    config :lager,
      log_level: :info,
      threshold: 1024

Will have a final configuration of:

    [log_level: :info, mode: :truncate, threshold: 1024]

This final configuration can be retrieved at run or compile time:

    Application.get_all_env(:lager)

 Configures the given key for the given application.

Keyword lists are always deep merged.

## Examples

The given `opts` are merged into the existing values for `key`
in the given `app`. Conflicting keys are overridden by the
ones specified in `opts`. For example, given the two configurations
below:

    config :ecto, Repo,
      log_level: :warn,
      adapter: Ecto.Adapters.Postgres

    config :ecto, Repo,
      log_level: :info,
      pool_size: 10

the final value of the configuration for the `Ecto` key in the `:ecto`
application will be:

    [log_level: :info, pool_size: 10, adapter: Ecto.Adapters.Postgres]

This final value can be retrieved at runtime or compile time with:

    Application.get_env(:ecto, Repo)

 Imports configuration from the given file or files.

If `path_or_wildcard` is a wildcard, then all the files
matching that wildcard will be imported; if no file matches
the wildcard, no errors are raised. If `path_or_wildcard` is
not a wildcard but a path to a single file, then that file is
imported; in case the file doesn't exist, an error is raised.
This behaviour is analogous to the one for `read_wildcard!/1`.

If path/wildcard is a relative path/wildcard, it will be expanded relatively
to the directory the current configuration file is in.

## Examples

This is often used to emulate configuration across environments:

    import_config "#{Mix.env}.exs"

Or to import files from children in umbrella projects:

    import_config "../apps/*/config/config.exs"

 Merges two configurations.

The configuration of each application is merged together
with the values in the second one having higher preference
than the first in case of conflicts.

## Examples

    iex> Mix.Config.merge([app: [k: :v1]], [app: [k: :v2]])
    [app: [k: :v2]]

    iex> Mix.Config.merge([app1: []], [app2: []])
    [app1: [], app2: []]

 Module for defining, reading and merging app configurations.

Most commonly, this module is used to define your own configuration:

    use Mix.Config

    config :plug,
      key1: "value1",
      key2: "value2"

    import_config "#{Mix.env}.exs"

All `config/*` macros, including `import_config/1`, are used
to help define such configuration files.

Furthermore, this module provides functions like `read!/1`,
`merge/2` and friends which help manipulate configurations
in general.

Configuration set using `Mix.Config` will set the application env, so
that `Application.get_env/3` and other `Application` functions can be used
at run or compile time to retrieve or change the configuration.

For example, the `:key1` value from application `:plug` (see above) can be
retrieved with:

    "value1" = Application.fetch_env!(:plug, :key1)

 Persists the given configuration by modifying
the configured applications environment.

`config` should be a list of `{app, app_config}` tuples or a
`%{app => app_config}` map where `app` are the applications to
be configured and `app_config` are the configuration (as key-value
pairs) for each of those applications.

Returns the configured applications.

## Examples

    Mix.Config.persist(logger: [level: :error], my_app: [my_config: 1])
    #=> [:logger, :my_app]

 Reads and validates a configuration file.

`file` is the path to the configuration file to be read. If that file doesn't
exist or if there's an error loading it, a `Mix.Config.LoadError` exception
will be raised.

`loaded_paths` is a list of configuration files that have been previously
read. If `file` exists in `loaded_paths`, a `Mix.Config.LoadError` exception
will be raised.
 Reads many configuration files given by wildcard into a single config.

Raises an error if `path` is a concrete filename (with no wildcards)
but the corresponding file does not exist; if `path` matches no files,
no errors are raised.

`loaded_paths` is a list of configuration files that have been previously
read.
 Validates a configuration.
 Project-Id-Version: elixir 1.4.0
PO-Revision-Date: 2017-01-24 17:01+0900
Last-Translator: Keiji Suzuki <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
 æåŽãããĸããĒãąãŧãˇã§ãŗãæ§æããžãã

ã­ãŧã¯ãŧããĒãšãã¯å¸¸ãĢããŖãŧãããŧã¸ãããžãã

## äž

æåŽãã`opts`ã¯æåŽãã`app`ãŽæĸå­ãŽæ§æãĢããŧã¸ãããžãã
æ§æã­ãŧã¯`opts`ã§æåŽãããããŽã§ä¸æ¸ããããžãã
ãã¨ãã°ãæŦĄãŽåŽįžŠã§ã¯:

    config :lager,
      log_level: :warn,
      mode: :truncate

    config :lager,
      log_level: :info,
      threshold: 1024

æįĩįãĢæŦĄãŽæ§æãĢãĒããžã:

    [log_level: :info, mode: :truncate, threshold: 1024]

ããŽæįĩįãĒæ§æã¯åŽčĄæãžãã¯ãŗãŗãã¤ãĢæãĢåãåēããã¨ãã§ããžã:

    Application.get_all_env(:lager)

 æåŽãããĸããĒãąãŧãˇã§ãŗãŽæåŽããã­ãŧãæ§æããžãã

ã­ãŧã¯ãŧããĒãšãã¯å¸¸ãĢããŖãŧãããŧã¸ãããžãã

## äž

æåŽãã`opts`ã¯æåŽãã`app`ãŽæĸå­ãŽå¤ãĢããŧã¸ãããžãã
čĄįĒããã­ãŧã¯ã`opts`ã§æåŽããã­ãŧã§ä¸æ¸ããããžãã
ãã¨ãã°ãæŦĄãŽãããĒīŧã¤ãŽæ§æããã
å ´å:

    config :ecto, Repo,
      log_level: :warn,
      adapter: Ecto.Adapters.Postgres

    config :ecto, Repo,
      log_level: :info,
      pool_size: 10

`:ecto`ãĸããĒãąãŧãˇã§ãŗãŽ`Ecto`ã­ãŧãŽæįĩįãĒ
æ§æãŽå¤ã¯æŦĄãŽãããĢãĒããžã:

    [log_level: :info, pool_size: 10, adapter: Ecto.Adapters.Postgres]

ããŽæįĩįãĒå¤ã¯åŽčĄæãžãã¯ãŗãŗãã¤ãĢæãĢåãåēããã¨ãã§ããžã:

    Application.get_env(:ecto, Repo)

 æåŽããīŧīŧã¤ãžãã¯č¤æ°ãŽīŧããĄã¤ãĢããæ§æãã¤ãŗããŧãããžãã

`path_or_wildcard`ãã¯ã¤ãĢããĢãŧããŽå ´åã¯ã¯ã¤ãĢããĢãŧããĢ
ãããããããšãĻãŽããĄã¤ãĢãã¤ãŗããŧããããžããã¯ã¤ãĢããĢãŧããĢ
ãããããããĄã¤ãĢããĒãå ´åã¯ã¨ãŠãŧã¯įēįããžããã`path_or_wildcard`ã
ã¯ã¤ãĢããĢãŧãã§ã¯ãĒãåä¸ããĄã¤ãĢãŽããšã§ããå ´åã¯ãããŽããĄã¤ãĢã
ã¤ãŗããŧããããžããããĄã¤ãĢãå­å¨ããĒãå ´åã¯ã¨ãŠãŧãįēįããžãã
ããŽããã¤ããĸã¯`read_wildcard!/1`ã¨åãã§ãã

ããšãžãã¯ã¯ã¤ãĢããĢãŧããį¸å¯žčĄ¨įžãŽå ´åãįžå¨ãŽæ§æããĄã¤ãĢããã
ããŖãŦã¯ããĒãããŽį¸å¯žã¨ããĻåąéãããžãã
## äž

äģĨä¸ã¯č¤æ°ãŽį°åĸãŽæ§æãã¨ããĨãŦãŧãããéãĢããäŊŋãããžã:

    import_config "#{Mix.env}.exs"

ãžãããĸãŗããŦãŠãã­ã¸ã§ã¯ããŽå­ããããĄã¤ãĢãã¤ãŗããŧããããĢã¯æŦĄãŽãããĢããžã:

    import_config "../apps/*/config/config.exs"

 īŧã¤ãŽæ§æãããŧã¸ããžãã

åãĸããĒãąãŧãˇã§ãŗãŽæ§æãããŧã¸ããžããæ§æãčĄįĒããå ´åã¯
æåãŽæ§æããīŧįĒįŽãŽå¤ãåĒåãããžãã

## äž

    iex> Mix.Config.merge([app: [k: :v1]], [app: [k: :v2]])
    [app: [k: :v2]]

    iex> Mix.Config.merge([app1: []], [app2: []])
    [app1: [], app2: []]

 ãĸããĒãąãŧãˇã§ãŗãŽæ§æãåŽįžŠãčĒ­ãŋčžŧãŋãããŧã¸ãããããŽãĸã¸ãĨãŧãĢã§ãã

éå¸¸ãããŽãĸã¸ãĨãŧãĢã¯įŦčĒãŽæ§æãåŽįžŠãããããĢäŊŋį¨ãããžãã

    use Mix.Config

    config :plug,
      key1: "value1",
      key2: "value2"

    import_config "#{Mix.env}.exs"

`import_config/1`ãåĢãããšãĻãŽ`config/*`ãã¯ã­ã¯ããŽãããĒ
æ§æããĄã¤ãĢãåŽįžŠãããŽãĢäŊŋį¨ãããžãã

ãããĢãããŽãĸã¸ãĨãŧãĢã¯ãä¸čŦãĢæ§æãŽæäŊãåŠãã
`read!/1`ã`merge/2` ãĒãŠãŽéĸæ°ãæäžããĻ
ããžãã

`Mix.Config` ãäŊŋãæ§æãģããã¯ãĸããĒãąãŧãˇã§ãŗãŽį°åĸãč¨­åŽããžãã
ããŽããã `Application.get_env/3`ãããŽäģãŽ`Application`éĸæ°ã
åŽčĄæããŗãŗãã¤ãĢæãĢäŊŋį¨ããĻãæ§æãåãåēãããå¤æ´ããããããã¨ãã§ããžãã

ãã¨ãã°ããĸããĒãąãŧãˇã§ãŗãŽ`:plug`ãã`:key1`ãŽå¤īŧä¸ãåį§īŧãæŦĄãŽ
ãããĢåãåēããã¨ãã§ããžãã

    "value1" = Application.fetch_env!(:plug, :key1)

 æ§æããããĸããĒãąãŧãˇã§ãŗãŽį°åĸãå¤æ´ãããã¨ãĢãã
æåŽããæ§æãæ°¸įļåããžãã

`config`ã¯`{app, app_config}` ãŋããĢãŽãĒãšãã
`%{app => app_config}` ãããã§ãĒããã°ãããžããã
ããã§ã`app`ã¯æ§æããããĸããĒãąãŧãˇã§ãŗã`app_config`ã¯
åãĸããĒãąãŧãˇã§ãŗãŽåããĢå¯žããæ§æīŧã­ãŧãģå¤ããĸīŧã§ãã

æ§æããããĸããĒãąãŧãˇã§ãŗãčŋããžãã
## äž

    Mix.Config.persist(logger: [level: :error], my_app: [my_config: 1])
    #=> [:logger, :my_app]

 æ§æããĄã¤ãĢãčĒ­ãŋčžŧãã§æ¤č¨ŧããžãã

`file`ã¯čĒ­ãŋčžŧãæ§æããĄã¤ãĢãŽããšã§ããããŽããĄã¤ãĢãå­å¨ããĒãã
ãžãã¯ãã­ãŧãä¸­ãĢã¨ãŠãŧãįēįããå ´åã¯ã`Mix.Config.LoadError`
äžå¤ãįēįããžãã

`loaded_paths`ã¯åããŖãĻčĒ­ãŋčžŧãžããĻããæ§æããĄã¤ãĢãŽãĒãšãã§ãã
`file`ã`loaded_paths`ãĢåĢãžããĻããå ´åã¯ã`Mix.Config.LoadError`
äžå¤ãįēįããžãã
 ã¯ã¤ãĢããĢãŧããĢããæåŽãããå¤ããŽæ§æããĄã¤ãĢãä¸ã¤ãŽåæ§ãĢčĒ­ãŋčžŧãŋãžãã

`path`ãåˇäŊįãĒããĄã¤ãĢåīŧã¯ã¤ãĢããĢãŧããĒãīŧãŽå ´åã¯ã¨ãŠãŧãįēįããžããã
å¯žåŋããããĄã¤ãĢãå­å¨ããĒããããĒããĄã`path`ãĢãããããããĄã¤ãĢããĒãå ´åã¯
ã¨ãŠãŧã¯įēįããžããã

`loaded_paths`ã¯åããŖãĻčĒ­ãŋčžŧãžããĻããæ§æããĄã¤ãĢãŽãĒãšã
ã§ãã
 æ§æãæ¤č¨ŧããžãã
 