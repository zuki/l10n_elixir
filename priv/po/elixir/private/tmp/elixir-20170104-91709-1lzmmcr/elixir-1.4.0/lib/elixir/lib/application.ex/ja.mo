Þ          Ü   %         0    1    G  5  Ê  g      È   h  
  1  y   <  ¼   ¶  ³  s  î   '       T   ´"  O   	#  '   Y#  +   #  Y  ­#     %  |   %     &  Û   ¢&    ~'  G   -     f-  J  ò-  N  =/  Î  B    [K     qN  9  óN    -P     ÊQ  P  hR  *  ¹S  k  äV  Õ  PX  a   &\  ^   \  W   ç\  K   ?]  ©  ]     5_  «   Ê_  ¥   v`  X  a  ú  ub     pj  è   ôj           	                                                                         
                                           A module for working with applications and defining application callbacks.

In Elixir (actually, in Erlang/OTP), an application is a component
implementing some specific functionality, that can be started and stopped
as a unit, and which can be re-used in other systems.

Applications are defined with an application file named `APP.app` where
`APP` is the application name, usually in `underscore_case`. The application
file must reside in the same `ebin` directory as the compiled modules of the
application.

In Elixir, Mix is responsible for compiling your source code and
generating your application `.app` file. Furthermore, Mix is also
responsible for configuring, starting and stopping your application
and its dependencies. For this reason, this documentation will focus
on the remaining aspects of your application: the application environment
and the application callback module.

You can learn more about Mix generation of `.app` files by typing
`mix help compile.app`.

## Application environment

Once an application is started, OTP provides an application environment
that can be used to configure the application.

Assuming you are inside a Mix project, you can edit the `application/0`
function in the `mix.exs` file to the following:

    def application do
      [env: [hello: :world]]
    end

In the application function, we can define the default environment values
for our application. By starting your application with `iex -S mix`, you
can access the default value:

    Application.get_env(:APP_NAME, :hello)
    #=> :world

It is also possible to put and delete values from the application value,
including new values that are not defined in the environment file (although
this should be avoided).

Keep in mind that each application is responsible for its environment.
Do not use the functions in this module for directly accessing or modifying
the environment of other applications (as it may lead to inconsistent
data in the application environment).

## Application module callback

Often times, an application defines a supervision tree that must be started
and stopped when the application starts and stops. For such, we need to
define an application module callback. The first step is to define the
module callback in the application definition in the `mix.exs` file:

    def application do
      [mod: {MyApp, []}]
    end

Our application now requires the `MyApp` module to provide an application
callback. This can be done by invoking `use Application` in that module and
defining a `start/2` callback, for example:

    defmodule MyApp do
      use Application

      def start(_type, _args) do
        MyApp.Supervisor.start_link()
      end
    end

`start/2` typically returns `{:ok, pid}` or `{:ok, pid, state}` where
`pid` identifies the supervision tree and `state` is the application state.
`args` is the second element of the tuple given to the `:mod` option.

The `type` argument passed to `start/2` is usually `:normal` unless in a
distributed setup where application takeovers and failovers are configured.
This particular aspect of applications is explained in more detail in the
OTP documentation:

  * [`:application` module](http://www.erlang.org/doc/man/application.html)
  * [Applications â OTP Design Principles](http://www.erlang.org/doc/design_principles/applications.html)

A developer may also implement the `stop/1` callback (automatically defined
by `use Application`) which does any application cleanup. It receives the
application state and can return any value. Note that shutting down the
supervisor is automatically handled by the VM.
 Called when an application is started.

This function is called when an the application is started using
`Application.start/2` (and functions on top of that, such as
`Application.ensure_started/2`). This function should start the top-level
process of the application (which should be the top supervisor of the
application's supervision tree if the application follows the OTP design
principles around supervision).

`start_type` defines how the application is started:

  * `:normal` - used if the startup is a normal startup or if the application
    is distributed and is started on the current node because of a failover
    from another mode and the application specification key `:start_phases`
    is `:undefined`.
  * `{:takeover, node}` - used if the application is distributed and is
    started on the current node because of a failover on the node `node`.
  * `{:failover, node}` - used if the application is distributed and is
    started on the current node because of a failover on node `node`, and the
    application specification key `:start_phases` is not `:undefined`.

`start_args` are the arguments passed to the application in the `:mod`
specification key (e.g., `mod: {MyApp, [:my_args]}`).

This function should either return `{:ok, pid}` or `{:ok, pid, state}` if
startup is successful. `pid` should be the PID of the top supervisor. `state`
can be an arbitrary term, and if omitted will default to `[]`; if the
application is later stopped, `state` is passed to the `stop/1` callback (see
the documentation for the `c:stop/1` callback for more information).

`use Application` provides no default implementation for the `start/2`
callback.
 Called when an application is stopped.

This function is called when an application has stopped, i.e., when its
supervision tree has been stopped. It should do the opposite of what the
`start/2` callback did, and should perform any necessary cleanup. The return
value of this callback is ignored.

`state` is the return value of the `start/2` callback or the return value of
the `prep_stop/1` function if the application module defines such a function.

`use Application` defines a default implementation of this function which does
nothing and just returns `:ok`.
 Deletes the `key` from the given `app` environment.

See `put_env/4` for a description of the options.
 Ensures the given `app` and its applications are started.

Same as `start/2` but also starts the applications listed under
`:applications` in the `.app` file in case they were not previously
started.
 Ensures the given `app` is started.

Same as `start/2` but returns `:ok` if the application was already
started. This is useful in scripts and in test setup, where test
applications need to be explicitly started:

    :ok = Application.ensure_started(:my_test_dep)

 Formats the error reason returned by `start/2`,
`ensure_started/2`, `stop/1`, `load/1` and `unload/1`,
returns a string.
 Gets the application for the given module.

The application is located by analyzing the spec
of all loaded applications. Returns `nil` if
the module is not listed in any application spec.
 Gets the directory for app.

This information is returned based on the code path. Here is an
example:

    File.mkdir_p!("foo/ebin")
    Code.prepend_path("foo/ebin")
    Application.app_dir(:foo)
    #=> "foo"

Even though the directory is empty and there is no `.app` file
it is considered the application directory based on the name
"foo/ebin". The name may contain a dash `-` which is considered
to be the app version and it is removed for the lookup purposes:

    File.mkdir_p!("bar-123/ebin")
    Code.prepend_path("bar-123/ebin")
    Application.app_dir(:bar)
    #=> "bar-123"

For more information on code paths, check the `Code` module in
Elixir and also Erlang's `:code` module.
 Loads the given `app`.

In order to be loaded, an `.app` file must be in the load paths.
All `:included_applications` will also be loaded.

Loading the application does not start it nor load its modules, but
it does load its environment.
 Puts the `value` in `key` for the given `app`.

## Options

  * `:timeout`    - the timeout for the change (defaults to 5000ms)
  * `:persistent` - persists the given value on application load and reloads

If `put_env/4` is called before the application is loaded, the application
environment values specified in the `.app` file will override the ones
previously set.

The persistent option can be set to `true` when there is a need to guarantee
parameters set with this function will not be overridden by the ones defined
in the application resource file on load. This means persistent values will
stick after the application is loaded and also on application reload.
 Returns a list with information about the applications which are currently running.
 Returns a list with information about the applications which have been loaded.
 Returns all key-value pairs for `app`.
 Returns the given path inside `app_dir/1`.
 Returns the spec for `app`.

The following keys are returned:

  * :description
  * :id
  * :vsn
  * :modules
  * :maxP
  * :maxT
  * :registered
  * :included_applications
  * :applications
  * :mod
  * :start_phases

Note the environment is not returned as it can be accessed via
`fetch_env/2`. Returns `nil` if the application is not loaded.
 Returns the value for `key` in `app`'s environment in a tuple.

If the configuration parameter does not exist, the function returns `:error`.
 Returns the value for `key` in `app`'s environment.

If the configuration parameter does not exist, raises `ArgumentError`.
 Returns the value for `key` in `app`'s environment.

If the configuration parameter does not exist, the function returns the
`default` value.
 Returns the value for `key` in `app`'s specification.

See `spec/1` for the supported keys. If the given
specification parameter does not exist, this function
will raise. Returns `nil` if the application is not loaded.
 Starts the given `app`.

If the `app` is not loaded, the application will first be loaded using `load/1`.
Any included application, defined in the `:included_applications` key of the
`.app` file will also be loaded, but they won't be started.

Furthermore, all applications listed in the `:applications` key must be explicitly
started before this application is. If not, `{:error, {:not_started, app}}` is
returned, where `app` is the name of the missing application.

In case you want to automatically  load **and start** all of `app`'s dependencies,
see `ensure_all_started/2`.

The `type` argument specifies the type of the application:

  * `:permanent` - if `app` terminates, all other applications and the entire
    node are also terminated.

  * `:transient` - if `app` terminates with `:normal` reason, it is reported
    but no other applications are terminated. If a transient application
    terminates abnormally, all other applications and the entire node are
    also terminated.

  * `:temporary` - if `app` terminates, it is reported but no other
    applications are terminated (the default).

Note that it is always possible to stop an application explicitly by calling
`stop/1`. Regardless of the type of the application, no other applications will
be affected.

Note also that the `:transient` type is of little practical use, since when a
supervision tree terminates, the reason is set to `:shutdown`, not `:normal`.
 Stops the given `app`.

When stopped, the application is still loaded.
 Unloads the given `app`.

It will also unload all `:included_applications`.
Note that the function does not purge the application modules.
 Project-Id-Version: l 10n_elixir
PO-Revision-Date: 2017-01-25 17:23+0900
Last-Translator: å°ç° ç§æ¬ <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
 ã¢ããªã±ã¼ã·ã§ã³ã§åããã¢ããªã±ã¼ã·ã§ã³ã³ã¼ã«ããã¯ãå®ç¾©ããã¢ã¸ã¥ã¼ã«ã§ãã

Elixirã§ã¯(å®éã«ã¯ãErlang/OTPã§ã¯)ãã¢ããªã±ã¼ã·ã§ã³ã¨ã¯ãããã¤ãã®
ç¹å®ã®æ©è½(åä½ã¨ãã¦ã¹ã¿ã¼ããã¹ããããã§ããä»ã®ã·ã¹ãã ã§ã
åå©ç¨ã§ãããããª)ãå®è£ããã³ã³ãã¼ãã³ãã§ãã

ã¢ããªã±ã¼ã·ã§ã³ã¯ã`APP.app`ã¨åä»ããããã¢ããªã±ã¼ã·ã§ã³ãã¡ã¤ã«ã§
å®ç¾©ããã¾ãã`APP`ã¯éå¸¸`underscore_case`å¤æãããã¢ããªã±ã¼ã·ã§ã³ã®
ååã§ããã¢ããªã±ã¼ã·ã§ã³ãã¡ã¤ã«ã¯ãã¢ããªã±ã¼ã·ã§ã³ã¢ã¸ã¥ã¼ã«ã®
ãã¤ãã³ã¼ãã¨åã`ebin`ãã£ã¬ã¯ããªã«ç½®ãããªããã°ãªãã¾ããã

Elixirã§ã¯ãMixã¯ã½ã¼ã¹ã³ã¼ãã®ã³ã³ãã¤ã«ã¨ã¢ããªã±ã¼ã·ã§ã³
`.app`ãã¡ã¤ã«ã®çæã«è²¬ä»»ããã¡ã¾ããããã«ã¾ããMixã¯
ã¢ããªã±ã¼ã·ã§ã³ã®ä¾å­é¢ä¿ãæ§æããéå§ã¨åæ­¢ãè¡ãå½¹å²ãæãã¾ãã
ãã®çç±ããããã®ãã­ã¥ã¡ã³ãã¯ããªãã®ã¢ããªã±ã¼ã·ã§ã³ã®æ®ãã®
é¢ã«éä¸­ãã¾ã: ã¢ããªã±ã¼ã·ã§ã³ç°å¢ãã¢ããªã±ã¼ã·ã§ã³ã³ã¼ã«ããã¯
ã¢ã¸ã¥ã¼ã«ã§ãã

Mixã§`.app`ãã¡ã¤ã«ãçæãããã¨ã«ã¤ãã¦ã¯ã`mix help
compile.app`ã¨ã¿ã¤ããããã¨ã§å­¦ã¶ãã¨ãã§ãã¾ãã

## ã¢ããªã±ã¼ã·ã§ã³ç°å¢

ã¢ããªã±ã¼ã·ã§ã³ãéå§ããããOTPã¯ãã¢ããªã±ã¼ã·ã§ã³ãæ§æããããã«
ä½¿ããã¨ãã§ãããã¢ããªã±ã¼ã·ã§ã³ç°å¢ãæä¾ãã¾ãã

Mixãã­ã¸ã§ã¯ãã«ãããªãã°ã`mix.exs`ãã¡ã¤ã«ã®ä¸­ã®`application`é¢æ°ã
æ¬¡ã®ããã«ç·¨éãããã¨ãã§ãã¾ã:

    def application do
      [env: [hello: :world]]
    end

applicationé¢æ°ã§ãã¢ããªã±ã¼ã·ã§ã³ã®ããã®ããã©ã«ãã®ç°å¢ã®å¤ã
å®ç¾©ã§ãã¾ãã`iex -S mix`ã§ã¢ããªã±ã¼ã·ã§ã³ãéå§ãããã¨ã«ãã£ã¦ã
ãã®ããã©ã«ãå¤ã«ã¢ã¯ã»ã¹ã§ãã¾ã:

    Application.get_env(:APP_NAME, :hello)
    #=> {:ok, :hello}

(é¿ããã¹ããã¨ã§ãã)ç°å¢ãã¡ã¤ã«ã§å®ç¾©ãããªãæ°ããå¤ãå«ã¿ã
ã¢ããªã±ã¼ã·ã§ã³ããå¤ãputããdeleteãããã¨ã
å¯è½ã§ãã

ããããã®ã¢ããªã±ã¼ã·ã§ã³ããã®ç°å¢ã«è²¬ä»»ãæããã¨ãå¿ã«ã¨ãã¦ããã¦
ãã ããã(ã¢ããªã±ã¼ã·ã§ã³ç°å¢ã§çç¾ãã¦ãããã¼ã¿ã«è³ããããããªãã®
ã§)ä»ã®ã¢ããªã±ã¼ã·ã§ã³ã®ç°å¢ã¸ã®ç´æ¥ã¢ã¯ã»ã¹ãå¤æ´ã®ããã«ããã®ã¢ã¸ã¥ã¼
ã«ã®é¢æ°ãä½¿ããªãã§ãã ããã

## ã¢ããªã±ã¼ã·ã§ã¢ã¸ã¥ã¼ã«ã³ã¼ã«ããã¯

ãã°ãã°ãã¢ããªã±ã¼ã·ã§ã³ã¯ãã¢ããªã±ã¼ã·ã§ã³ãéå§ã¨åæ­¢ããã¨ãã«ã
éå§ã¨åæ­¢ãããã¹ã¼ããã¸ã§ã³ããªã¼ãå®ç¾©ãã¾ããããã§ãã¢ããªã±ã¼ã·ã§ã³
ã¢ã¸ã¥ã¼ã«ã³ã¼ã«ããã¯ãå®ç¾©ããå¿è¦ãããã¾ããæåã®ã¹ãããã¯`mix.exs`
ãã¡ã¤ã«ã®applicationã®å®ç¾©ã«ãã¢ã¸ã¥ã¼ã«ã³ã¼ã«ããã¯ãå®ç¾©ãããã¨ã§ã:

    def application do
      [mod: {MyApp, []}]
    end

ä»ããç§éã®ã¢ããªã±ã¼ã·ã§ã³ã¯ãã¢ããªã±ã¼ã·ã§ã³ã³ã¼ã«ããã¯ãæä¾ãããã¨ã
`MyApp`ã¢ã¸ã¥ã¼ã«ã«è¦æ±ãã¾ããããã¯ããã®ã¢ã¸ã¥ã¼ã«ã§`use Application`ã
å®è¡ãããã¨ã«ãããªããã`start/2`ã³ã¼ã«ããã¯ãå®ç¾©ãã¾ããä¾ãã°:

    defmodule MyApp do
      use Application

      def start(_type, _args) do
        MyApp.Supervisor.start_link()
      end
    end

`start/2`ã¯æãä¸è¬çã«ã¯`{:ok, pid}`ã`{:ok, pid, state}`ãè¿ãã¾ãã
`pid`ã¯ã¹ã¼ããã¸ã§ã³ããªã¼ã®è­å¥å­ã§ã`state`ã¯ã¢ããªã±ã¼ã·ã§ã³ã®ã¹ãã¼ã
ã§ãã
`args`ã¯`:mod`ãªãã·ã§ã³ã«ä¸ããã¿ãã«ã®2çªç®ã®è¦ç´ ã§ãã

`start/2`ã¸éã`type`ã¯ãã¢ããªã±ã¼ã·ã§ã³ã®ãã¤ã¯ãªã¼ãã¼ã¨ãã§ã¤ã«ãªã¼ãã
æ§æãããåæ£ã»ããã¢ããã§ãªãããããéå¸¸`:normal`ã§ãã
ã¢ããªã±ã¼ã·ã§ã³ã®ãã®ç¹å®ã®å´é¢ã¯ãOTPãã­ã¥ã¡ã³ãã§ããå¤ãè©³ç´°ã«èª­ã
ãã¨ãã§ãã¾ã:

  * [`:application` module](http://www.erlang.org/doc/man/application.html)
  * [Applications â OTP Design Principles](http://www.erlang.org/doc/design_principles/applications.html)

éçºèã¯ã`stop/1`ã³ã¼ã«ããã¯(`use Application`ã«ããèªåçã«å®ç¾©ããã¦ãã¾ã)ãã
ã¢ããªã±ã¼ã·ã§ã³ã®ãªãããã®ã¯ãªã¼ã³ã¢ããã®çºã«ãå®è£ããããããã¾ãããããã¯ã
ã¢ããªã±ã¼ã·ã§ã³ã¹ãã¼ããåãåããä»»æã®å¤ãè¿ããã¨ãã§ãã¾ããã¹ã¼ããã¤ã¶ã®
ã·ã£ãããã¦ã³ã¯ãVMã«ããèªåçã«ãã³ãã«ããããã¨ã«æ³¨æãã¦ãã ããã
 ã¢ããªã±ã¼ã·ã§ã³ã®éå§æã«å¼ã³åºããã¾ãã

ãã®é¢æ°ã¯ã¢ããªã±ã¼ã·ã§ã³ã`Application.start/2` ãä½¿ã£ã¦
éå§ãããæã«å¼ã³åºããã¾ãï¼ããã¦ã`Application.ensure_started/2`ã®
ããã«ãã®ä¸ã§æ©è½ãã¾ãï¼ããã®é¢æ°ã¯ã¢ããªã±ã¼ã·ã§ã³ã®æä¸ä½
ãã­ã»ã¹ãéå§ããã¹ãã§ãï¼ããã¯ã¢ããªã±ã¼ã·ã§ã³ãç£è¦ã«
é¢ããOPTè¨­è¨ååã«ããããã®ã§ããã°ãã¢ããªã±ã¼ã·ã§ã³ã®ç£è¦ããªã¼ã®
æä¸ä½ã¹ã¼ããã¤ã¶ã§ããã¹ãã§ãï¼ã

`start_type` ã¯ã¢ããªã±ã¼ã·ã§ã³ãéå§ããæ¹æ³ãå®ç¾©ãã¾ãã

  * `:normal` - ã¹ã¿ã¼ãã¢ãããéå¸¸ã®ã¹ã¿ã¼ãã¢ããã®å ´åããããã¯
    ã¢ããªã±ã¼ã·ã§ã³ãåæ£åã§ãããä»ã®ãã¼ãããã®ãã§ã¤ã«ãªã¼ãã®ããã«
    ã«ã¬ã³ããã¼ãã§éå§ãããã¢ããªã±ã¼ã·ã§ã³ã®è­å¥ã­ã¼`:start_phases`ã
    `:undefined`ã®å ´åã«ä½¿ç¨ããã¾ãã
  * `{:takeover, node}` - ã¢ããªã±ã¼ã·ã§ã³ãåæ£åã§ããããã¼ã`node`ã®
    ãã§ã¤ã«ãªã¼ãã®ããã«ã«ã¬ã³ããã¼ãã§éå§ãããå ´åã«ä½¿ç¨ããã¾ãã
  * `{:failover, node}` - ã¢ããªã±ã¼ã·ã§ã³ãåæ£åã§ããããã¼ã`node`ã®
    ãã§ã¤ã«ãªã¼ãã®ããã«ã«ã¬ã³ããã¼ãã§éå§ãããã¢ããªã±ã¼ã·ã§ã³ã®è­å¥
    ã­ã¼`:start_phases`ã`:undefined`ã®å ´åã«ä½¿ç¨ããã¾ãã

`start_args`ã¯`:mod`è­å¥ãã¼ã«ããã¢ããªã±ã¼ã·ã§ã³ã«æ¸¡ãããå¼æ°ã§ã
ï¼ãã¨ãã°ã`mod: {MyApp, [:my_args]}`ï¼ã

ãã®é¢æ°ã¯ã¹ã¿ã¼ããæåããå ´åã¯ã`{:ok, pid}`ã`{:ok, pid, state}`ã®ããããã
è¿ããªããã°ãªãã¾ããã`pid`ã¯æä¸ä½ã®ã¹ã¼ããã¤ã¶ã®PIDã§ãªããã°ãªãã¾ããã
`state`ã¯ä»»æã®é ãè¨­å®ã§ãã¾ããæå®ããªãå ´åã®ããã©ã«ãã¯`[]`ã§ãã
å¾ã«ã¢ããªã±ã¼ã·ã§ã³ãåæ­¢ããå ´åã`state`ã¯ã³ã¼ã«ããã¯`stop/1`ã«æ¸¡ããã¾ã
ï¼è©³ããæå ±ã¯`c:stop/1`ã®ãã­ã¥ã¡ã³ããåç§ãã¦ãã ããï¼ã

`use Application`ã¯ã³ã¼ã«ããã¯`start/2`ã®ããã©ã«ãå®è£ã¯
æä¾ãã¾ããã
 ã¢ããªã±ã¼ã·ã§ã³ãåæ­¢ããéã«å¼ã³åºããã¾ãã

ãã®é¢æ°ã¯ã¢ããªã±ã¼ã·ã§ã³ãåæ­¢ããæã«å¼ã³åºããã¾ããããªãã¡ã
ãã®ç£è¦ããªã¼ãåæ­¢ãããããã¨ãã§ããããã¯ã³ã¼ã«ããã¯`start/2`ã
ãããã¨ã®åå¯¾ã®ãã¨ãè¡ããªããã°ãªãã¾ãããã¾ããå¿è¦ãªã¯ãªã¼ã³ã¢ããã
å®è¡ããªããã°ãªãã¾ããããã®ã³ã¼ã«ããã¯ã®è¿ãå¤ã¯ç¡è¦ããã¾ãã

`stete`ã¯ã³ã¼ã«ããã¯`start/2`ã®è¿ãå¤ããã¢ããªã±ã¼ã·ã§ã³ã¢ã¸ã¥ã¼ã«ã
é¢æ°`prep_stop/1`ãå®ç¾©ãã¦ããå ´åã¯ãã®è¿ãå¤ã®ããããã§ãã

`use Application`ã¯ä½ãããããã `:ok`ãè¿ãããã®é¢æ°ã®ããã©ã«ãå®è£ã
å®ç¾©ãã¾ãã
 ä¸ãããã`app`ç°å¢ãã`key`ãåé¤ãã¾ãã

ãªãã·ã§ã³ã®è©³ç´°ã¯`put_env/4`ãåç§ãã¦ãã ããã
 ä¸ãããã`app`ã¨ãããä¾å­ãã¦ããã¢ããªã±ã¼ã·ã§ã³ãéå§ãã¦ãããã¨ã
ç¢ºå®ã«ãã¾ãã

`start/2`ã¨åãã§ããã`.app`ãã¡ã¤ã«ã«`:applications`ã§ãªã¹ãããã¦ãã
ã¢ããªã±ã¼ã·ã§ã³ããã¾ã éå§ãã¦ããªãå ´åã«ã¯ãéå§ãã¾ãã
 ä¸ãããã`app`ãéå§ãã¦ããã®ãç¢ºå®ã«ãã¾ãã

`start/2`ã¨åãã§ããããã®ã¢ããªã±ã¼ã·ã§ã³ãæ¢ã«éå§ãã¦ãããã
`:ok`ãè¿ãã¾ããããã¯ãã¹ã¯ãªããä¸­ããã¹ãã®ã»ããã¢ããã§
ãã¹ãã¢ããªã±ã¼ã·ã§ã³ãæç¤ºçã«éå§ãããå¿è¦ãããå ´åã«ã
ä¾¿å©ã§ã:

    :ok = Application.ensure_started(:my_test_dep)

 `start/2`ã`ensure_started/2`ã`stop/1`ã`load/1`ã`unload/1`ã§
è¿ããããã¨ã©ã¼ã®reasonããã©ã¼ãããããæå­åãè¿ãã¾ãã
 æå®ããmoduleã®ã¢ããªã±ã¼ã·ã§ã³ãåå¾ãã¾ãã

ã¢ããªã±ã¼ã·ã§ã³ã¯ã­ã¼ãããããã¹ã¦ã®ã¢ããªã±ã¼ã·ã§ã³ã®specãåæãã
ãã¨ã«ãã£ã¦ç¹å®ããã¾ããã¢ã¸ã¥ã¼ã«ãã©ã®ã¢ããªã±ã¼ã·ã§ã³ã®specã«
ããªã¹ãããã¦ããªãå ´åã¯ã`nil`ãè¿ãã¾ãã
 appã®ãã£ã¬ã¯ããªãåå¾ãã¾ãã

ãã®é¢æ°ã¯ã³ã¼ããã¹ã«åºãã¦è¿ããã¾ããä»¥ä¸ã¯
ä¾ã§ã:

    File.mkdir_p!("foo/ebin")
    Code.prepend_path("foo/ebin")
    Application.app_dir(:foo)
    #=> "foo"

ãã£ã¬ã¯ããªãç©ºã§ã`.app`ãã¡ã¤ã«ãç¡ãã¦ããåå"foo/ebin"ã«
åºãã¦ã¢ããªã±ã¼ã·ã§ã³ãã£ã¬ã¯ããªã¨èãããã¾ãã
ååã¯ãappã®ãã¼ã¸ã§ã³ã¨ãã¦èãããæ¤ç´¢ç®çã§ã¯åãé¤ãããã
ããã·ã¥`-`ãå«ãããããã¾ãã:

    File.mkdir_p!("bar-123/ebin")
    Code.prepend_path("bar-123/ebin")
    Application.app_dir(:bar)
    #=> "bar-123"

ã³ã¼ããã¹ã«ã¤ãã¦ã®è©³ç´°ã¯ãElixirã®`Code`ã¢ã¸ã¥ã¼ã«ã¨ãErlangã®
`:code`ã¢ã¸ã¥ã¼ã«ããã§ãã¯ãã¦ãã ããã
 ä¸ãããã`app`ãã­ã¼ããã¾ãã

ã­ã¼ããããçºã«ã¯ã`.app`ãã¡ã¤ã«ã¯ã­ã¼ããã¹ä¸ã«ãªããã°ãªãã¾ããã
å¨ã¦ã®`:included_applications`ãã­ã¼ãããã¾ãã

ã­ã¼ãããã¢ããªã±ã¼ã·ã§ã³ã¯éå§ãã¾ããããã¢ã¸ã¥ã¼ã«ã®ã­ã¼ãããã¾ã
ããããã®ç°å¢ãã­ã¼ããã¾ãã
 ä¸ãããã`value`ã`key`ã«ä¸ãããã`app`ã®çºã«ããããã¾ãã

## ãªãã·ã§ã³

  * `:timeout`    - å¤æ´ã®çºã®ã¿ã¤ã ã¢ã¦ã (ããã©ã«ã 5000ms)
  * `:persistent` - ã¢ããªã±ã¼ã·ã§ã³ãã­ã¼ãããªã­ã¼ãã§ãã¦ãå¤ãæ°¸ç¶åãã¾ã

ããã¢ããªã±ã¼ã·ã§ã³ãã­ã¼ããããåã«`put_env/4`ãå¼ã°ããã¨ã
`.app`ãã¡ã¤ã«ã§æå®ãããã¢ããªã±ã¼ã·ã§ã³ç°å¢å¤æ°ã¯ãä»¥åã®å¤ã
ä¸æ¸ãããã¾ãã

ã­ã¼ããã¦ããã¢ããªã±ã¼ã·ã§ã³ãªã½ã¼ã¹ãã¡ã¤ã«ã§å®ç¾©ãããå¤ã«ãããã
ã®é¢æ°ã«ããã»ããããããã©ã¡ã¿ãããªã¼ãã©ã¤ããããªãããã«ä¿è¨¼ãã
å¿è¦ãããã¨ãã«ãpersistent ãªãã·ã§ã³ã`true`ã«ã»ããã§ãã¾ããããã¯ã
æ°¸ç¶åãããå¤ã¯ã¢ããªã±ã¼ã·ã§ã³ãã­ã¼ããããã¢ããªã±ã¼ã·ã§ã³ããªã­ã¼
ããããå¾ãå®çãããã¨ãæå³ãã¾ãã
 ç¾å¨åãã¦ããã¢ããªã±ã¼ã·ã§ã³ã«ã¤ãã¦ã®æå ±ããªã¹ãã§è¿ãã¾ãã
 ã­ã¼ããããã¢ããªã±ã¼ã·ã§ã³ã«ã¤ãã¦ã®æå ±ããªã¹ãã§è¿ãã¾ãã
 `app`ã®ç°å¢ãªã¹ãã«ã¤ãã¦å¨ã¦ã®ã­ã¼ããªã¥ã¼ã®çµãè¿ãã¾ãã
 `app_dir/1`ã®åå´ã«ä¸ãããããã¹ãè¿½å ãã¦è¿ãã¾ãã
 `app`ã®specãè¿ãã¾ãã

ä»¥ä¸ã®ã­ã¼ãè¿ãã¾ã:

  * :description
  * :id
  * :vsn
  * :modules
  * :maxP
  * :maxT
  * :registered
  * :included_applications
  * :applications
  * :mod
  * :start_phases

`fetch_env/2` ãéãã¦ã¢ã¯ã»ã¹ã§ããã®ã§ãenvironmentã¯
è¿ãããªãç¹ã«æ³¨æãã¦ãã ãããã¢ããªã±ã¼ã·ã§ã³ã
ã­ã¼ãããã¦ããªãæã`nil`ãè¿ãã¾ãã
 `app`ã®ç°å¢ã®`key`ã«å¯¾å¿ããå¤ãè¿ãã¾ãã

ããconfigurationãã©ã¡ã¼ã¿ãå­å¨ããªãå ´åã`:error`ãè¿ãã¾ãã
 `app`ã®ç°å¢ã®`key`ã«å¯¾å¿ããå¤ãè¿ãã¾ãã

ããæå®ãããconfigurationãã©ã¡ã¼ã¿ãå­å¨ããªãå ´åã
`ArgumentError`ãä¸ãã¾ãã
 `app`ã®ç°å¢ã®ä¸­ã®`key`ã«å¯¾å¿ããå¤ãè¿ãã¾ãã

ããconfigurationãã©ã¡ã¿ãå­å¨ããªãå ´åãé¢æ°ã¯`default`å¤ã
è¿ãã¾ãã
 `app`ã®ä»æ§ã®`key`ã«å¯¾å¿ããå¤ãè¿ãã¾ãã

ãµãã¼ãããã¦ããã­ã¼ã«ã¤ãã¦ã¯`spec/1`ãåç§ãã¦ãã ããã
ããä¸ããããä»æ§ãã©ã¡ã¼ã¿ãå­å¨ããªãå ´åããã®é¢æ°ã¯ä¾å¤ã
ä¸ãã¾ããã¢ããªã±ã¼ã·ã§ã³ãã­ã¼ãããã¦ããªããªãã`nil`ã
è¿ãã¾ãã
 ä¸ãããã`app`ãéå§ãã¾ãã

`app`ãã­ã¼ãããã¦ããªããªããã¢ããªã±ã¼ã·ã§ã³ã¯æåã«`load/1`ãä½¿ã£ã¦
ã­ã¼ãããã¾ãã`.app`ãã¡ã¤ã«ã®`:included_applications`ã­ã¼ã§å®ç¾©ãã
ãä»»æã®å«ã¾ããã¢ããªã±ã¼ã·ã§ã³ãã¾ããã­ã¼ãããã¾ãããéå§ã¯ããã¾
ããã

ããã«ã`:application`ã­ã¼ã«ãªã¹ããããå¨ã¦ã®ã¢ããªã±ã¼ã·ã§ã³ã¯ã¢ããªã±ã¼ã·ã§ã³ã
éå§ããåã«ãæç¤ºçã«éå§ãããªããã°ãªãã¾ãããããããã§ãªããªãã
`app`ãè¶³ããªãã¢ããªã±ã¼ã·ã§ã³ã®ååã§`{:error, {:not_started, app}}`ãè¿ããã¾ãã

èªåçã«`app`ã«ä¾å­ããå¨ã¦ã®ã¢ããªã±ã¼ã·ã§ã³ãã­ã¼ãããéå§ããããå ´åã
`ensure_all_started/2`ãåç§ãã¦ãã ããã

`type`å¼æ°ã¯ã¢ããªã±ã¼ã·ã§ã³ã®ã¿ã¤ããæå®ãã¾ã:

  * `:permanent` - `app`ãçµäºããããå¨ã¦ã®ä»ã®ã¢ããªã±ã¼ã·ã§ã³ã¨
     ãã¼ãå¨ä½ãçµäºããã¾ãã

  * `:transient` - `app`ã`:normal` reasonã§çµäºãããã
    ã¬ãã¼ãããã¾ãããä»ã®ã¢ããªã±ã¼ã·ã§ã³ã¯çµäºãã¾ããã
    ããtransient(ä¸æç)ãªã¢ããªã±ã¼ã·ã§ã³ãç°å¸¸çµäºãããã
    å¨ã¦ã®ä»ã®ã¢ããªã±ã¼ã·ã§ã³ã¨ãã¼ãå¨ä½ãçµäºããã¾ãã

  * `:temporary` - `app`ãçµäºããããã¬ãã¼ãããã¾ããã
    ä»ã®ã¢ããªã±ã¼ã·ã§ã³ã¯çµäºããã¾ãã(ãããããã©ã«ãã§ã)ã

`stop/1`ãå¼ã¶ãã¨ã§ãæç¤ºçã«ã¢ããªã±ã¼ã·ã§ã³ãçµäºãããã¨ãå¸¸ã«ã§ãã
ãã¨ã«ãæ°ãä»ãã¦ãã ãããã¢ããªã±ã¼ã·ã§ã³ã®ã¿ã¤ãã«é¢ä¿ãªãã
ä»ã®ãããªãã¢ããªã±ã¼ã·ã§ã³ãå½±é¿ãåãã¾ããã

`:transient`ã¿ã¤ãã¯ã»ã¨ãã©å®ç¨çã§ãªããã¨ã«æ³¨æãã¦ãã ããã
ç£è¦ããªã¼ãçµäºããéã«ãçç±ã«`:normal`ã§ã¯ãªãã`:shutdown`ãã»ãããããããã§ããn

 ä¸ãããã`app`ãåæ­¢ãã¾ãã

åæ­¢ããã¨ããã¢ããªã±ã¼ã·ã§ã³ã¯ã¾ã ã­ã¼ããããã¾ã¾ã§ãã
 ä¸ãããã`app`ãã¢ã³ã­ã¼ããã¾ãã

ããã¯`:included_applications`å¨ã¦ããã¢ã³ã­ã¼ããã¾ãã
é¢æ°ã¯ã¢ããªã±ã¼ã·ã§ã³ã¢ã¸ã¥ã¼ã«ããã¼ã¸ããªããã¨ã«
æ³¨æãã¦ãã ããã
 