Þ          ¼      \      Ð     Ñ  ¬   S  Ù     e   Ú  
  @  2   K  *  ~     ©  )   @  ­   j  W       p  ¯     |  ²  ;   /  ³   k  	    #  )  .  M  I  |  Å   Æ   /  !  Ë  ¼"  ±   5  ±  :6  [   ì7  ¨  H8  Ñ   ñ9  I   Ã:  À   ;    Î;     ^=  Â   ý=  $  À>  [   å@  ë   AA  )  -B    WE  ¸  ñG                                   	                                
                                Builds the project structure for the current application.

## Options

  * `:symlink_ebin` - symlink ebin instead of copying it

 Compiles the given project.

It will run the compile task unless the project
is in build embedded mode, which may fail as an
explicit command to `mix compile` is required.
 Defines and manipulates Mix projects.

A Mix project is defined by calling `use Mix.Project` in a module, usually
placed in `mix.exs`:

    defmodule MyApp.Mixfile do
      use Mix.Project

      def project do
        [app: :my_app,
         version: "0.6.0"]
      end
    end

## Configuration

In order to configure Mix, the module that `use`s `Mix.Project` should export
a `project/0` function that returns a keyword list representing configuration
for the project.

This configuration can be read using `Mix.Project.config/0`. Note that
`config/0` won't fail if a project is not defined; this allows many Mix tasks
to work without a project.

If a task requires a project to be defined or needs to access a
special function within the project, the task can call `Mix.Project.get!/0`
which fails with `Mix.NoProjectError` in the case a project is not
defined.

There isn't a comprehensive list of all the options that can be returned by
`project/0` since many Mix tasks define their own options that they read from
this configuration. For example, look at the "Configuration" section in the
documentation for the `Mix.Tasks.Compile` task.

These are a few options that are not used by just one Mix task (and will thus
be documented here):

  * `:build_per_environment` - if `true`, builds will be *per-environment*. If
    `false`, builds will go in `_build/shared` regardless of the Mix
    environment. Defaults to `true`.

  * `:aliases` - a list of task aliases. For more information, check out the
    "Aliases" section in the documentation for the `Mix` module. Defaults to
    `[]`.

  * `:config_path` - a string representing the path of the main config
    file. See `config_files/0` for more information. Defaults to
    `"config/config.exs"`.

  * `:default_task` - a string representing the default task to be run by
    `mix` when no task is specified. Defaults to `"run"`.

  * `:deps` - a list of dependencies of this project. Refer to the
    documentation for the `Mix.Tasks.Deps` task for more information. Defaults
    to `[]`.

  * `:deps_path` - directory where dependencies are stored. Also see
    `deps_path/1`. Defaults to `"deps"`.

  * `:lockfile` - the name of the lockfile used by the `mix deps.*` family of
    tasks. Defaults to `"mix.lock"`.

  * `:preferred_cli_env` - a keyword list of `{task, env}` tuples here `task`
    is the task name as an atom (for example, `:"deps.get"`) and `env` is the
    preferred environment (for example, `:test`). This option overrides what
    specified by the single tasks with the `@preferred_cli_env` attribute (see
    `Mix.Task`). Defaults to `[]`.

For more options, keep an eye on the documentation for single Mix tasks; good
examples are the `Mix.Tasks.Compile` task and all the specific compiler tasks
(such as `Mix.Tasks.Compile.Elixir` or `Mix.Tasks.Compile.Erlang`).

Note that sometimes the same configuration option is mentioned in the
documentation for different tasks; this is just because it's common for many
tasks to read and use the same configuration option (for example,
`:erlc_paths` is used by `mix compile.erlang`, `mix compile.yecc`, and other
tasks).

## Erlang projects

Mix can be used to manage Erlang projects that don't have any Elixir code. To
ensure Mix tasks work correctly for an Erlang project, `language: :erlang` has
to be part of the configuration returned by `project/0`. This setting also
makes sure Elixir is not added as a dependency to the generated `.app` file or
to the escript generated with `mix escript.build`, and so on.
 Ensures the project structure exists.

In case it does exist, it is a no-op. Otherwise, it is built.
 Retrieves the current project if there is one.

Otherwise `nil` is returned. It may happen in cases
there is no mixfile in the current directory.

If you expect a project to be defined, i.e. it is a
requirement of the current task, you should call
`get!/0` instead.
 Returns `true` if project is an umbrella project.
 Returns a list of project configuration files for this project.

This function is usually used in compilation tasks to trigger
a full recompilation whenever such configuration files change.

By default it includes the mix.exs file, the lock manifest and
all config files in the `config` directory.
 Returns a map with the umbrella child applications
paths based on `:apps_path` and `:apps` configurations.

Returns `nil` if not an umbrella project.
 Returns all load paths for this project.
 Returns the application path inside the build.

The returned path will be expanded.

## Examples

    Mix.Project.app_path
    #=> "/path/to/project/_build/shared/lib/app"

 Returns the build path for this project.

The returned path will be expanded.

## Examples

    Mix.Project.build_path
    #=> "/path/to/project/_build/shared"

If `:build_per_environment` is set to `true`, it will create a new build per
environment:

    Mix.env
    #=> :dev
    Mix.Project.build_path
    #=> "/path/to/project/_build/dev"

 Returns the full path of all dependencies as a map.

## Examples

    Mix.Project.deps_paths
    #=> %{foo: "deps/foo", bar: "custom/path/dep"}

 Returns the path where dependencies are stored for this project.

The returned path will be expanded.

## Examples

    Mix.Project.deps_path
    #=> "/path/to/project/deps"

 Returns the path where manifests are stored.

By default they are stored in the app path inside
the build directory. Umbrella applications have
the manifest path set to the root of the build directory.
Directories may be changed in future releases.

The returned path will be expanded.

## Examples

    Mix.Project.manifest_path
    #=> "/path/to/project/_build/shared/lib/app"

 Returns the path where protocol consolidations are stored.
 Returns the paths this project compiles to.

The returned path will be expanded.

## Examples

    Mix.Project.compile_path
    #=> "/path/to/project/_build/shared/lib/app/ebin"

 Returns the project configuration.

If there is no project defined, it still returns a keyword
list with default values. This allows many Mix tasks to work
without the need for an underlying project.

Note this configuration is cached once the project is
pushed onto the stack. Calling it multiple times won't
cause it to be recomputed.

Do not use `Mix.Project.config/0` to find the runtime configuration.
Use it only to configure aspects of your project (like
compilation directories) and not your application runtime.
 Runs the given `fun` inside the given project.

This function changes the current working directory and
loads the project at the given directory onto the project
stack.

A `post_config` can be passed that will be merged into
the project configuration.

`fun` is called with the module name of the given `Mix.Project`.
The return value of this function is the return value of `fun`.

## Examples

    Mix.Project.in_project :my_app, "/path/to/my_app", fn module ->
      "Mixfile is: #{inspect module}"
    end
    #=> "Mixfile is: MyApp.Mixfile"

 Same as `get/0`, but raises an exception if there is no current project.

This is usually called by tasks that need additional
functions on the project to be defined. Since such
tasks usually depend on a project being defined, this
function raises `Mix.NoProjectError` in case no project
is available.
 Project-Id-Version: elixir 1.4.0
PO-Revision-Date: 2017-01-24 17:49+0900
Last-Translator: Keiji Suzuki <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
 ç¾å¨ã®ã¢ããªã±ã¼ã·ã§ã³ã®ãã­ã¸ã§ã¯ãæ§é ããã«ããã¾ãã

## ãªãã·ã§ã³

  * `:symlink_ebin` - ebinãã³ãã¼ããä»£ããã«ã·ã³ããªãã¯ãªã³ã¯ãã

 æå®ãããã­ã¸ã§ã¯ããã³ã³ãã¤ã«ãã¾ãã

ãã­ã¸ã§ã¯ããåãè¾¼ã¿ãã«ãã¢ã¼ãã§ãªãå ´åã¯ã³ã³ãã¤ã«ã¿ã¹ã¯ãå®è¡
ãã¾ããåãè¾¼ã¿ãã«ãã¢ã¼ãå ´åã¯`mix compile`ã¸ã®æç¤ºçãªã³ãã³ãã
å¿è¦ãªã®ã§å¤±æãã§ãããã
 Mixãã­ã¸ã§ã¯ãã®å®ç¾©ã¨æä½ãè¡ãã¾ãã

Mixãã­ã¸ã§ã¯ãã¯ã¢ã¸ã¥ã¼ã«ã®ä¸­ã§`use Mix.Project`ãå¼ã³åºããã¨ã§å®ç¾©
ããã¾ããããã¯éå¸¸ `mix.exs`ã«ç½®ããã¾ã:

    defmodule MyApp.Mixfile do
      use Mix.Project

      def project do
        [app: :my_app,
         version: "0.6.0"]
      end
    end

## æ§æ

MIxãæ§æããããã«`Mix.Project`ã`use`ããã¢ã¸ã¥ã¼ã«ã¯ããã­ã¸ã§ã¯ãã®
æ§æãè¡¨ãã­ã¼ã¯ã¼ããªã¹ããè¿ã`project/0`é¢æ°ãã¨ã¯ã¹ãã¼ãããªããã°
ãªãã¾ããã

ãã®æ§æã¯`Mix.Project.config/0`ãä½¿ã£ã¦èª­ããã¨ãã§ãã¾ãã`config/0`ã¯
ãã­ã¸ã§ã¯ããå®ç¾©ããã¦ããªãã¦ãå¤±æããªããã¨ã«æ³¨æãã¦ãã ãããããã¯
ãã­ã¸ã§ã¯ããªãã§å¤ãã®Mixã¿ã¹ã¯ãç¨¼åã§ããããã«ããããã§ãã

ã¿ã¹ã¯ããã­ã¸ã§ã¯ããå®ç¾©ããã¦ãããã¨ãè¦æ±ããå ´åãã¾ãã¯ãã­ã¸ã§ã¯ãåã®
ç¹å®ã®é¢æ°ã«ã¢ã¯ã»ã¹ããå¿è¦ãããå ´åã¯ãã¿ã¹ã¯ã¯`Mix.Project.get!/0`ãå¼ã³åºã
ãã¨ãã§ãã¾ããããã¯ãã­ã¸ã§ã¯ããå®ç¾©ããã¦ããªãã¨`Mix.NoProjectError`
ã§å¤±æãã¾ãã

`project/0`ãè¿ããªãã·ã§ã³ã¯ãã¹ã¦ã®ãªãã·ã§ã³ã®å®å¨ãªãªã¹ãã§ã¯ããã¾ããã
ãã®æ§æããèª­ã¿è¾¼ã¾ããå¤ãã®Mixã¿ã¹ã¯ã¯ç¬èªã®ãªãã·ã§ã³ãå®ç¾©ãã¦ãããã
ã§ãããã¨ãã°ã`Mix.Tasks.Compile`ã¿ã¹ã¯ã®ãã­ã¥ã¡ã³ãã®âæ§æâã»ã¯ã·ã§ã³ã
è¦ã¦ãã ããã

ãã£ãï¼ã¤ã®Mixã¿ã¹ã¯ã ãã§ä½¿ãããã®ã§ã¯ãªããªãã·ã§ã³ãããã¤ãå­å¨ãã¾ã
ï¼ã§ãã®ã§ããã«æ¸ãã¦ããã¾ãï¼:

  * `:build_per_environment` - `true`ã®å ´åããã«ãã¯*ç°å¢ãã¨*ã«ãããªãããã¾ãã
    `false`ã®å ´åã¯Mixç°å¢ã«ããããã,`_build/shared`ã§è¡ããã¾ãã
    ããã©ã«ãã¯`true`ã§ãã

  * `:aliases` - ã¿ã¹ã¯ã¨ã¤ãªã¢ã¹ã®ãªã¹ããããã«è©³ããæå ±ã¯`Mix` ã¢ã¸ã¥ã¼ã«ã®
    ãã­ã¥ã¡ã³ãã®âã¨ã¤ãªã¢ã¹â ã»ã¯ã·ã§ã³ããã§ãã¯ãã¦ãã ãããããã©ã«ãã¯`[]`ã§ãã

  * `:config_path` - ä¸»ããæ§æãã¡ã¤ã«ã®ãã¹ãè¡¨ãæå­åãããã«è©³ããæå ±ã¯
    `config_files/0`ãåç§ãã¦ãã ãããããã©ã«ãã¯`"config/config.exs"`ã§ãã 

  * `:default_task` - ã¿ã¹ã¯ãæå®ãããªãå ´åã«`mix`ã«ããå®è¡ãããããã©ã«ãã®
    ã¿ã¹ã¯ãè¡¨ãæå­åãããã©ã«ãã¯`"run"`ã§ãã

  * `:deps` - ãã®ãã­ã¸ã§ã¯ãã®ä¾å­é¢ä¿ã®ãªã¹ããããã«è©³ããæå ±ã¯
     `Mix.Tasks.Deps`ã¿ã¹ã¯ã®ãã­ã¥ã¡ã³ããåç§ãã¦ãã ãããããã©ã«ãã¯
     `[]`ã§ãã

  * `:deps_path` - ä¾å­é¢ä¿ãæ ¼ç´ããã¦ãããã£ã¬ã¯ããªã`deps_path/1`ã
     è¦ã¦ãã ãããããã©ã«ãã¯`"deps"`ã§ããn

  * `:lockfile` - ã¿ã¹ã¯ã®`mix deps.*`ãã¡ããªãä½¿ç¨ããã­ãã¯ãã¡ã¤ã«ã®ååã
    ããã©ã«ãã¯`"mix.lock"`ã§ãã

  * `:preferred_cli_env` - a keyword list of `{task, env}`ã¿ãã«ã®ã­ã¼ã¯ã¼ããªã¹ãã
    ããã§ã`task`ã¯ã¢ãã ã«ããã¿ã¹ã¯åï¼ãã¨ãã°ã`:"deps.getâ`ï¼ã`env` ã¯
    åªåã®ç°å¢ï¼ãã¨ãã°ã`:test`ï¼ã§ãããã®ãªãã·ã§ã³ã¯ã¿ã¹ã¯ã`@preferred_cli_env` 
     å±æ§ã§æå®ãããã®ãä¸æ¸ããã¾ãï¼`Mix.Task`ã®ãã­ã¥ã¡ã³ããåç§ï¼ã
     ããã©ã«ãã¯`[]`ã§ãã

ãããªããªãã·ã§ã³ã«ã¤ãã¦ã¯ãåå¥ã®Mixã¿ã¹ã¯ã®ãã­ã¥ã¡ã³ãã«ç®ãåãã¦ãã ããã
è¯ãä¾ã¯`Mix.Tasks.Compile` ã¿ã¹ã¯ã¨ãã¹ã¦ã®ç¹å®ã®ã³ã³ãã¤ã©ã¼ã¿ã¹ã¯ï¼ãã¨ãã°ã
`Mix.Tasks.Compile.Elixir` ã `Mix.Tasks.Compile.Erlang`ï¼ã§ãã

ç°ãªãã¿ã¹ã¯ã®ãã­ã¥ã¡ã³ãã§åãæ§æãªãã·ã§ã³ã«è¨åããã¦ããå ´åããããã¨ã«æ³¨æ
ãã¦ãã ãããããã¯å¤ãã®ã¿ã¹ã¯ã§åãæ§æãªãã·ã§ã³ãèª­ã¿è¾¼ã¾ãä½¿ç¨ãããã®ã¯
æ®éã®ãã¨ã ããã§ãï¼ãã¨ãã°ã`:erlc_paths`ã¯`mix compile.erlang`ã
`mix compile.yecc`ãªã©ã§ä½¿ããã¦ãã¾ãï¼ã

## Erlangãã­ã¸ã§ã¯ã

Mixã¯Elixirã³ã¼ããã¾ã£ããå«ã¾ãªãErlangãã­ã¸ã§ã¯ãã®ç®¡çã«ä½¿ç¨ãããã¨ãã§ãã¾ãã
Erlangãã­ã¸ã§ã¯ãã§Mixã¿ã¹ã¯ãæ­£ããåãããã«ããããã«ã`project/0`ãè¿ãæ§æã«
`language: :erlang` ãå«ã¾ããããã«ããªããã°ãªãã¾ãããã¾ãããã®æ§æã¯ãçæããã
`.app`ãã¡ã¤ã«ã`mix escript.build`ã§çæãããescriptãªã©ã®ä¾å­é¢ä¿ã«Elixirãè¿½å 
ãããªãããã«ãã¾ãã
 ãã­ã¸ã§ã¯ãæ§é ãå­å¨ãããã¨ãä¿è¨¼ãã¾ãã

ãã­ã¸ã§ã¯ããå­å¨ããå ´åã¯ä½ããã¾ãããããã§ãªãå ´åã¯ãã«ããã¾ãã
 å­å¨ããå ´åãã«ã¬ã³ããã­ã¸ã§ã¯ããåãåºãã¾ãã

ããã§ãªãå ´åã¯`nil`ãè¿ãã¾ããããã¯ã«ã¬ã³ããã£ã¬ã¯ããªã«
mixfileãå­å¨ããªãå ´åã«èµ·ããã¾ãã

ãã­ã¸ã§ã¯ããå®ç¾©ããã¦ãããã¨ãæå¾ããå ´åãããªãã¡ã
ãããã«ã¬ã³ãã¿ã¹ã¯ã®è¦ä»¶ã§ããå ´åã¯ããã®é¢æ°ã§ã¯ãªã`get!/0`ã
å¼ã³åºãã¹ãã§ãã
 ãã­ã¸ã§ã¯ããã¢ã³ãã¬ã©ãã­ã¸ã§ã¯ãã®å ´åã`true`ãè¿ãã¾ãã
 ãã®ãã­ã¸ã§ã¯ãã®ãã­ã¸ã§ã¯ãæ§æãã¡ã¤ã«ã®ãªã¹ããè¿ãã¾ãã

ãã®é¢æ°ã¯éå¸¸ãæ§æãã¡ã¤ã«ãå¤æ´ãããæ¯ã«åãã«ã³ã³ãã¤ã«ã
èµ·åãããããã«ã³ã³ãã¤ã«ã¿ã¹ã¯ã§ä½¿ç¨ããã¾ãã

ããã©ã«ãã§ã¯ãmix.exsãã¡ã¤ã«ãã­ãã¯ãããã§ã¹ãã`config`ãã£ã¬ã¯ããªã®
ãã¹ã¦ã®æ§æãã¡ã¤ã«ãå«ãã§ãã¾ãã
 `:apps_path` ã¨ `:apps`ã®æ§æãåã« ã¢ã³ãã¬ã©å­ã¢ããªã±ã¼ã·ã§ã³ã®
ãã¹ãæã¤ããããè¿ãã¾ãã

ã¢ã³ãã¬ã©ãã­ã¸ã§ã¯ãã§ãªãå ´åã¯`nil`ãè¿ãã¾ãã

 ãã®ãã­ã¸ã§ã¯ãã®ãã¹ã¦ã®ã­ã¼ããã¹ãè¿ãã¾ãã
 ãã«ãåã®ã¢ããªã±ã¼ã·ã§ã³ãã¹ãè¿ãã¾ãã

è¿ããããã¹ã¯å±éããã¾ãã

## ä¾

    Mix.Project.app_path
    #=> "/path/to/project/_build/shared/lib/app"

 ãã®ãã­ã¸ã§ã¯ãã®ãã«ããã¹ãè¿ãã¾ãã

è¿ããããã¹ã¯å±éããã¾ãã

## ä¾

    Mix.Project.build_path
    #=> "/path/to/project/_build/shared"

`:build_per_environment`ã`true`ã«è¨­å®ããã¦ããå ´åã¯
 ç°å¢ãã¨ã«æ°ããªãã«ããä½æãã¾ãã:

    Mix.env
    #=> :dev
    Mix.Project.build_path
    #=> "/path/to/project/_build/dev"

 ãã¹ã¦ã®ä¾å­é¢ä¿ã®ãã«ãã¹ããããã§è¿ãã¾ãã

## ä¾

    Mix.Project.deps_paths
    #=> %{foo: "deps/foo", bar: "custom/path/dep"}

 ãã®ãã­ã¸ã§ã¯ãã®ä¾å­é¢ä¿ãæ ¼ç´ããããã¹ãè¿ãã¾ãã

è¿ããããã¹ã¯å±éããã¾ãã

## ä¾

    Mix.Project.deps_path
    #=> "/path/to/project/deps"

 ãããã§ã¹ããæ ¼ç´ããããã¹ãè¿ãã¾ãã

ããã©ã«ãã§ã¯ããããã§ã¹ãã¯ãã«ããã£ã¬ã¯ããªåã®
appãã¹ã«æ ¼ç´ããã¾ããã¢ã³ãã¬ã©ã¢ããªã±ã¼ã·ã§ã³ã¯
ãã«ããã£ã¬ã¯ããªã®ã«ã¼ãã«è¨­å®ããããããã§ã¹ããã¹ã
æã£ã¦ãã¾ãããã£ã¬ã¯ããªã¯å°æ¥ã®ãªãªã¼ã¹ã§ã¯å¤æ´ãããå¯è½æ§ãããã¾ãã

è¿ããããã¹ã¯å±éããã¾ãã

## ä¾

    Mix.Project.manifest_path
    #=> "/path/to/project/_build/shared/lib/app"


 ãã­ãã³ã«ã³ã³ã½ãªãã¼ã·ã§ã³ãæ ¼ç´ããã¦ãããã¹ãè¿ãã¾ãã
 ãã®ãã­ã¸ã§ã¯ããã³ã³ãã¤ã«ããã³ã¼ããç½®ããããã¹ãè¿ãã¾ãã

è¿ããããã¹ã¯å±éããã¾ãã
n
## ä¾

    Mix.Project.compile_path
    #=> "/path/to/project/_build/shared/lib/app/ebin"

 ãã­ã¸ã§ã¯ãã®æ§æãè¿ãã¾ãã

ãã­ã¸ã§ã¯ããå®ç¾©ããã¦ããªãå ´åã§ããããã©ã«ãå¤ã«ãã
ã­ã¼ã¯ã¼ããªã¹ããè¿ãã¾ããããã«ããåºæ¬ã¨ãªããã­ã¸ã§ã¯ãã
å¿è¦ã¨ãããã¨ãªãå¤ãã®Mixã¿ã¹ã¯ãä½åã§ãã¾ãã

ãã®è¨­å®ã¯ãã­ã¸ã§ã¯ããä¸æ¦ã¹ã¿ãã¯ã«ããã·ã¥ãããã¨
ã­ã£ãã·ã¥ããããã¨ã«æ³¨æãã¦ãã ãããè¤æ°åå¼ã³ãã¦ã
åè¨ç®ãè¡ããã¨ã¯ããã¾ããã

å®è¡ä¸­ã®æ§æãæ¢ãããã«`Mix.Project.config/0`ãä½¿ããªãã§ãã ããã
ï¼ã³ã³ãã¤ã«ãã£ã¬ã¯ããªã®ãããªï¼ãã­ã¸ã§ã¯ãã®æ§ç¸ãæ§æããããã«ã®ã¿
ä½¿ç¨ããã¢ããªã±ã¼ã·ã§ã³ã©ã³ã¿ã¤ã ã«ã¯ä½¿ç¨ããªãã§ãã ããã
 æå®ãã`fun`ãæå®ãããã­ã¸ã§ã¯ãã§å®è¡ãã¾ãã

ãã®é¢æ°ã¯ã«ã¬ã³ãã¯ã¼ã­ã³ã°ãã£ã¬ã¯ããªãå¤æ´ãã
æå®ãããã£ã¬ã¯ããªã«ãããã­ã¸ã§ã¯ãããã­ã¸ã§ã¯ã
ã¹ã¿ãã¯ã«ã­ã¼ããã¾ãã

ãã­ã¸ã§ã¯ãã®æ§æã«ãã¼ã¸ããã`post_config`ã
æ¸¡ããã¨ãã§ãã¾ãã

`fun`ã¯æå®ãã`Mix.Project`ã®ã¢ã¸ã¥ã¼ã«åãå¼æ°ã«
å¼ã³ããã¾ãããã®é¢æ°ã®è¿ãå¤ã¯`fun`ã®è¿ãå¤ã§ãã

## ä¾

    Mix.Project.in_project :my_app, "/path/to/my_app", fn module ->
      "Mixfile is: #{inspect module}"
    end
    #=> "Mixfile is: MyApp.Mixfile"

 `get/0`ã¨åãã§ãããã«ã¬ã³ããã­ã¸ã§ã¯ããå­å¨ããªãå ´åãä¾å¤ãçºçãã¾ãã

ããã¯éå¸¸ããã­ã¸ã§ã¯ãã«è¿½å ã®é¢æ°ãå®ç¾©ããå¿è¦ããã
ã¿ã¹ã¯ã«ããå¼ã³åºããã¾ãããã®ãããªã¿ã¹ã¯ã¯éå¸¸å®ç¾©ä¸­ã®
ãã­ã¸ã§ã¯ãã«ä¾å­ãã¾ãã®ã§ããã­ã¸ã§ã¯ããå©ç¨ã§ããªãå ´åã
ãã®é¢æ°ã¯`Mix.NoProjectError`ã
çºçãã¾ãã

 