Þ          ¬      <      °  ß  ±  Ì       ^  Þ   `  i  ?  á   ©  0      ¼  Ã   Á  q     £   ÷  O       ë     ú       ¼       Û  J  ã   ª  ."  )  Ù5  ?  7  I  C8  Ó  9    a;  ¾   =  Ý  ¿>    E     ¤F  Ù   >G  ¤  H     ½I  '   ÙI  !   J    #J  t  (K                                              	                                        
               Agents are a simple abstraction around state.

Often in Elixir there is a need to share or store state that
must be accessed from different processes or by the same process
at different points in time.

The Agent module provides a basic server implementation that
allows state to be retrieved and updated via a simple API.

## Examples

For example, in the Mix tool that ships with Elixir, we need
to keep a set of all tasks executed by a given project. Since
this set is shared, we can implement it with an Agent:

    defmodule Mix.TasksServer do
      def start_link do
        Agent.start_link(fn -> MapSet.new end, name: __MODULE__)
      end

      @doc "Checks if the task has already executed"
      def executed?(task, project) do
        item = {task, project}
        Agent.get(__MODULE__, fn set ->
          item in set
        end)
      end

      @doc "Marks a task as executed"
      def put_task(task, project) do
        item = {task, project}
        Agent.update(__MODULE__, &MapSet.put(&1, item))
      end

      @doc "Resets the executed tasks and returns the previous list of tasks"
      def take_all() do
        Agent.get_and_update(__MODULE__, fn set ->
          {Enum.into(set, []), MapSet.new}
        end)
      end
    end

Note that agents still provide a segregation between the
client and server APIs, as seen in GenServers. In particular,
all code inside the function passed to the agent is executed
by the agent. This distinction is important because you may
want to avoid expensive operations inside the agent, as it will
effectively block the agent until the request is fulfilled.

Consider these two examples:

    # Compute in the agent/server
    def get_something(agent) do
      Agent.get(agent, fn state -> do_something_expensive(state) end)
    end

    # Compute in the agent/client
    def get_something(agent) do
      Agent.get(agent, &(&1)) |> do_something_expensive()
    end

The first function blocks the agent. The second function copies
all the state to the client and then executes the operation in the
client. The difference is whether the data is large enough to require
processing in the server, at least initially, or small enough to be
sent to the client cheaply.

## Name Registration

An Agent is bound to the same name registration rules as GenServers.
Read more about it in the `GenServer` docs.

## A word on distributed agents

It is important to consider the limitations of distributed agents. Agents
provide two APIs, one that works with anonymous functions and another
that expects an explicit module, function, and arguments.

In a distributed setup with multiple nodes, the API that accepts anonymous
functions only works if the caller (client) and the agent have the same
version of the caller module.

Keep in mind this issue also shows up when performing "rolling upgrades"
with agents. By rolling upgrades we mean the following situation: you wish
to deploy a new version of your software by *shutting down* some of your
nodes and replacing them with nodes running a new version of the software.
In this setup, part of your environment will have one version of a given
module and the other part another version (the newer one) of the same module.

The best solution is to simply use the explicit module, function, and arguments
APIs when working with distributed agents.

## Hot code swapping

An agent can have its code hot swapped live by simply passing a module,
function, and args tuple to the update instruction. For example, imagine
you have an agent named `:sample` and you want to convert its inner state
from some dict structure to a map. It can be done with the following
instruction:

    {:update, :sample, {:advanced, {Enum, :into, [%{}]}}}

The agent's state will be added to the given list as the first argument.
 Gets an agent value via the given function.

Same as `get/3` but a module, function and args are expected
instead of an anonymous function. The state is added as first
argument to the given list of args.
 Gets an agent value via the given function.

The function `fun` is sent to the `agent` which invokes the function
passing the agent state. The result of the function invocation is
returned.

A timeout can also be specified (it has a default value of 5000).
 Gets and updates the agent state in one operation.

Same as `get_and_update/3` but a module, function and args are expected
instead of an anonymous function. The state is added as first
argument to the given list of args.
 Gets and updates the agent state in one operation.

The function `fun` is sent to the `agent` which invokes the function
passing the agent state. The function must return a tuple with two
elements, the first being the value to return (i.e. the `get` value)
and the second one is the new state.

A timeout can also be specified (it has a default value of 5000).
 Performs a cast (fire and forget) operation on the agent state.

Same as `cast/2` but a module, function and args are expected
instead of an anonymous function. The state is added as first
argument to the given list of args.
 Performs a cast (fire and forget) operation on the agent state.

The function `fun` is sent to the `agent` which invokes the function
passing the agent state. The function must return the new state.

Note that `cast` returns `:ok` immediately, regardless of whether the
destination node or agent exists.
 Starts an agent linked to the current process with the given function.

This is often used to start the agent as part of a supervision tree.

Once the agent is spawned, the given function is invoked and its return
value is used as the agent state. Note that `start_link` does not return
until the given function has returned.

## Options

The `:name` option is used for registration as described in the module
documentation.

If the `:timeout` option is present, the agent is allowed to spend at most
the given number of milliseconds on initialization or it will be terminated
and the start function will return `{:error, :timeout}`.

If the `:debug` option is present, the corresponding function in the
[`:sys` module](http://www.erlang.org/doc/man/sys.html) will be invoked.

If the `:spawn_opt` option is present, its value will be passed as options
to the underlying process as in `Process.spawn/4`.

## Return values

If the server is successfully created and initialized, the function returns
`{:ok, pid}`, where `pid` is the PID of the server. If an agent with the
specified name already exists, the function returns
`{:error, {:already_started, pid}}` with the PID of that process.

If the given function callback fails with `reason`, the function returns
`{:error, reason}`.
 Starts an agent linked to the current process with the given module
function and arguments.

Same as `start_link/2` but a module, function and args are expected
instead of an anonymous function.
 Starts an agent process without links (outside of a supervision tree).

See `start_link/2` for more information.
 Starts an agent with the given module function and arguments.

Similar to `start/2` but a module, function and args are expected
instead of an anonymous function.
 Stops the agent with the given `reason`.

It returns `:ok` if the server terminates with the given
reason, if it terminates with another reason, the call will
exit.

This function keeps OTP semantics regarding error reporting.
If the reason is any other than `:normal`, `:shutdown` or
`{:shutdown, _}`, an error report will be logged.
 The agent name The agent reference The agent state Updates the agent state.

Same as `update/3` but a module, function and args are expected
instead of an anonymous function. The state is added as first
argument to the given list of args.
 Updates the agent state.

The function `fun` is sent to the `agent` which invokes the function
passing the agent state. The function must return the new state.

A timeout can also be specified (it has a default value of 5000).
This function always returns `:ok`.
 Project-Id-Version: l 10n_elixir
PO-Revision-Date: 2017-01-25 16:49+0900
Last-Translator: å°ç° ç§æ¬ <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
 Agentã¯ã¹ãã¼ãã¾ããã®åç´ãªæ½è±¡ã§ãã

Elixirã§ã¯ãã°ãã°ãç°ããã­ã»ã¹ãããã¾ãã¯ãåããã­ã»ã¹ã®
ç°ãæç¹ã«ãããã¢ã¯ã»ã¹ãããªããã°ãªããªãã¹ãã¼ããã
ä¿å­ã¾ãã¯å±æããå¿è¦ãããã¾ãã

Agentã¢ã¸ã¥ã¼ã«ã¯ãã·ã³ãã«ãªAPIã«ããã¹ãã¼ããåãåºãããæ´æ°ããã
ã®ãè¨±ããåºæ¬çãªãµã¼ãå®è£ãæä¾ãã¾ãã

## ä¾

ä¾ãã°ãElixirã«åæ¢±ããã¦ããMixãã¼ã«ã§ã¯ãä¸ãããããã­ã¸ã§ã¯ãã«ã
ãå®è¡ãããå¨ã¦ã®ã¿ã¹ã¯ã®éåããä¿æãã¦ããå¿è¦ãããã¾ãã
ãã®éåãå±æãããã®ã§ããããAgentã§å®è£ã§ãã¾ã:

    defmodule Mix.TasksServer do
      def start_link do
        Agent.start_link(fn -> HashSet.new end, name: __MODULE__)
      end

      @doc "Checks if the task has already executed"
      def executed?(task, project) do
        item = {task, project}
        Agent.get(__MODULE__, fn set ->
          item in set
        end)
      end

      @doc "Marks a task as executed"
      def put_task(task, project) do
        item = {task, project}
        Agent.update(__MODULE__, &Set.put(&1, item))
      end

      @doc "Resets the executed tasks and return the previous list of tasks"
      def take_all() do
        Agent.get_and_update(__MODULE__, fn set ->
          {Enum.into(set, []), HashSet.new}
        end)
      end
    end

GenServerã§è¦ãããããã«ãã¾ã ã¨ã¼ã¸ã§ã³ãã¯ã¯ã©ã¤ã¢ã³ãã¨ãµã¼ãAPIã®
éã§åé¢ãæä¾ããç¹ã«æ³¨æãã¦ãã ãããç¹ã«ãã¨ã¼ã¸ã§ã³ãã«æ¸¡ãããé¢
æ°ã®åå´ã®å¨ã¦ã®ã³ã¼ãã¯ã¨ã¼ã¸ã§ã³ãã«ãã£ã¦å®è¡ããã¾ããè¦æ±ãæºãã
ãã¾ã§ããããã¨ã¼ã¸ã§ã³ããå¹æçã«ãã­ãã¯ãããããé«ä¾¡ãªãªãã¬ã¼ã·ã§
ã³ãé¿ãããã¨ãããªãã¯æããããããªãã®ã§ããã®åºå¥ã¯éè¦ã§ãã

äºã¤ã®ä¾ãèãã¦ã¿ã¦ãã ãã:

    # Compute in the agent/server
    def get_something(agent) do
      Agent.get(agent, fn state -> do_something_expensive(state) end)
    end

    # Compute in the agent/client
    def get_something(agent) do
      Agent.get(agent, &(&1)) |> do_something_expensive()
    end

ç¬¬2ã®ãã®ãå¨ã¦ã®ã¹ãã¼ããã¯ã©ã¤ã¢ã³ãã¸ã³ãã¼ãã¦ã
ã¯ã©ã¤ã¢ã³ãã§ãªãã¬ã¼ã·ã§ã³ãå®è¡ããéãæåã®ãã®ã¯ã¨ã¼ã¸ã§ã³ãã
ãã­ãã¯ãã¾ãã
ãã¼ã¿ãå®ãã¯ã©ã¤ã¢ã³ãã«éä¿¡ãããã®ã«ååã«å°ãããã
ãµã¼ãã§è¦æ±ãå¦ç(ãããã¯å°ãªãã¨ãåæå¦ç)ããã®ã«ååã«å¤§ãããã®ã
ããã¯æ­£ã«ãã¬ã¼ããªãã§ãã

## Name Registration

Agentã¯GenServerã¨åãååç»é²è¦åã«æç¸ããã¾ãã
ããã«ã¤ãã¦ã¯`GenServer`ã®ãã­ã¥ã¡ã³ããåç§ãã¦ãã ããã

## A word on distributed agents

åæ£ãããã¨ã¼ã¸ã§ã³ãã®å¶éãèæ®ãããã¨ã¯éè¦ã§ããAgentã¯ã
äºã¤ã®APIãæä¾ãã¾ããä¸ã¤ã¯ç¡åé¢æ°ã§åããã®ã¨ãããä¸ã¤ã¯
æç¤ºçãªã¢ã¸ã¥ã¼ã«ãé¢æ°ãå¼æ°ãæå¾ãããã®ã§ãã

è¤æ°ã®ãã¼ãã«ããåæ£ã»ããã¢ããã«ããã¦ãå¼ã³åºãå´(ã¯ã©ã¤ã¢ã³ã)ã¨
ã¨ã¼ã¸ã§ã³ããå¼ã³åºãå´ã¨åããã¼ã¸ã§ã³ã®ã¢ã¸ã¥ã¼ã«ããã£ã¦ããã°ã
ãã®ã¨ãã ããç¡åé¢æ°ãåãä»ããAPIã¯åä½ãã¾ãã

ã¨ã¼ã¸ã§ã³ãã§"ã­ã¼ãªã³ã°ã¢ããã°ã¬ã¼ã"ãå®è¡ããæã«ãããã®åé¡ãè¡¨
ãããã¨ãå¿ã«ã¨ãã¦ããã¦ãã ãããã­ã¼ãªã³ã°ã¢ããã°ã¬ã¼ãã«ãããä»¥
ä¸ã®ã·ãã¥ã¨ã¼ã·ã§ã³ãæå³ãã¦ãã¾ã:ããªãã¯ããã¼ãã®å¹¾ã¤ãã*ã·ã£ã
ããã¦ã³*ãã¦ãã½ããã¦ã¨ã¢ã®æ°ãããã¼ã¸ã§ã³ãèµ°ããã¦ãããã¼ãã¨å¥ã
æ¿ãããã¨ã«ãã£ã¦ãã½ããã¦ã¨ã¢ã®æ°ãããã¼ã¸ã§ã³ãããã­ã¤ããããã
ã®ã»ããã¢ããã«ããã¦ãããªãã®ç°å¢ã®ä¸é¨ã¯ä¸ããããã¢ã¸ã¥ã¼ã«ã®ä¸ã¤
ã®ãã¼ã¸ã§ã³ãæã¡ãä»ã®ä¸é¨ã¯ãåãã¢ã¸ã¥ã¼ã«ã®ããä¸ã¤ã®ãã¼ã¸ã§ã³(ã
ãæ°ãããã®)ãæã¡ã¾ãã

æé«ã®è§£æ±ºç­ã¯ãåã«ãåæ£ãããã¨ã¼ã¸ã§ã³ãã§åããã¨ããæç¤ºçãªã¢
ã¸ã¥ã¼ã«ãé¢æ°ãå¼æ°APIãä½¿ããã¨ã§ãã

## Hot code swapping

ã¨ã¼ã¸ã§ã³ãã¯ãåã«updateå½ä»¤ã«ã¢ã¸ã¥ã¼ã«ãé¢æ°ãå¼æ°ã¿ãã«ãéããã¨
ã§ããããã³ã¼ãã¹ã¯ããã³ã°ãã§ãã¾ããä¾ãã°ã`:sample`ã¨åä»ãããã
ã¨ã¼ã¸ã§ã³ããæã£ã¦ãã¦ããã®åé¨ã¹ãã¼ãã®ããã¤ããdictæ§é ãã
mapã¸å¤æãããã¨ãã¾ããä»¥ä¸ã®å½ä»¤ã§ãããã§ãã¾ã:

    {:update, :sample, {:advanced, {Enum, :into, [%{}]}}}

ã¨ã¼ã¸ã§ã³ãã®ã¹ãã¼ãã¯æåã®å¼æ°ã¨ãã¦ä¸ãããããªã¹ãã«
å ãããã¾ãã
 ä¸ããããé¢æ°ã«ãã£ã¦ã¨ã¼ã¸ã§ã³ãã®å¤ãåå¾ãã¾ãã

`get/3`ã¨åãã§ãããç¡åé¢æ°ã®æ¿ãã«ãã¢ã¸ã¥ã¼ã«ãé¢æ°ãã
ãã¦å¼æ°ãæå¾ããã¾ããã¹ãã¼ãã¯ä¸ããããå¼æ°ãªã¹ãã®æåã®å¼æ°ã¨ã
ã¦è¿½å ããã¾ãã
 æå®ããé¢æ°ãä»ãã¦ã¨ã¼ã¸ã§ã³ãã®å¤ãåå¾ãã¾ãã

é¢æ°`fun`ãã¨ã¼ã¸ã§ã³ãã¹ãã¼ããæ¸¡ãã¦é¢æ°ãå®è¡ãã
`agent`ã«éããã¾ããé¢æ°ã®å®è¡çµæã
è¿ããã¾ãã

ã¿ã¤ã ã¢ã¦ããæå®ãããã¨ãã§ãã¾ã(ããã©ã«ãå¤ã¯5000ã§ã)ã
 ä¸ã¤ã®ãªãã¬ã¼ã·ã§ã³ã§ãã¨ã¼ã¸ã§ã³ãã¹ãã¼ããåå¾ãã¦æ´æ°ãã¾ãã

`get_and_update/3`ã¨åãã§ãããç¡åé¢æ°ã®æ¿ãã«ãã¢ã¸ã¥ã¼ã«ãé¢æ°ãã
ãã¦å¼æ°ãæå¾ããã¾ããã¹ãã¼ãã¯ä¸ããããå¼æ°ãªã¹ãã®æåã®å¼æ°ã¨ã
ã¦è¿½å ããã¾ãã
 1åã®æä½ã§ãã¨ã¼ã¸ã§ã³ãã®ã¹ãã¼ããåå¾ã»æ´æ°ãã¾ãã

é¢æ°`fun`ãã¨ã¼ã¸ã§ã³ãã¹ãã¼ããæ¸¡ãã¦é¢æ°ãå®è¡ãã
`agent`ã«éããã¾ããé¢æ°ã¯2ã¤ã®æ§ãæã¤ã¿ãã«ã
è¿ããªããã°ãªãã¾ãããç¬¬1è¦ç´ ã¯è¿ãããå¤(å³ã¡`get`ããå¤)ã§
ãããç¬¬2è¦ç´ ã¯æ°ããã¹ãã¼ãã§ãã


ã¿ã¤ã ã¢ã¦ããæå®ãããã¨ãã§ãã¾ã(ããã©ã«ãå¤ã¯5000ã§ã)ã
 ã¨ã¼ã¸ã§ã³ãã®ã¹ãã¼ãã§ã­ã£ã¹ã(çºç«ãã¦å¿ãã)ãªãã¬ã¼ã·ã§ã³ãå®è¡ãã¾ãã

`cast/2`ã¨åãã§ãããç¡åé¢æ°ã®ãããã«ãã¢ã¸ã¥ã¼ã«ãé¢æ°ãå¼æ°ãæç¤º
ãã¦ã¾ããã¹ãã¼ãã¯ä¸ããããå¼æ°ãªã¹ãã®æåã«è¿½å ããã¾ããé¢æ°
`fun`ã¯`agent`ã«éãããã¨ã¼ã¸ã§ã³ãã¹ãã¼ããæ¸¡ããã¦å®è¡ããã¾ãã
 ã¨ã¼ã¸ã§ã³ãã®ã¹ãã¼ãã§ã­ã£ã¹ã(çºç«ãã¦å¿ãã)ãªãã¬ã¼ã·ã§ã³ãå®è¡ãã¾ãã

é¢æ°`fun`ã¯`agent`ã«éãããã¨ã¼ã¸ã§ã³ãã¹ãã¼ããæ¸¡ããã¦å®è¡ããã¾ãã
é¢æ°ã¯æ°ããã¹ãã¼ããè¿ããªããã°ãªãã¾ããã

éä¿¡åã®ãã¼ããããã¯ã¨ã¼ã¸ã§ã³ãã®å­å¨ã®æç¡ã«æãããã`cast`ã¯
`:ok`ãç´ã¡ã«è¿ããã¨ã«æ³¨æãã¦ãã ããã
 ç¾å¨ã®ãã­ã»ã¹ã«æå®ããé¢æ°ããªã³ã¯ããã¨ã¼ã¸ã§ã³ããéå§ãã¾ãã

ããã¯éå¸¸ãç£è¦ããªã¼ã®ä¸é¨ã¨ãã¦ã¨ã¼ã¸ã§ã³ããéå§ããããã«
ä½¿ããã¾ãã

ã¨ã¼ã¸ã§ã³ããçæãããã¨ãæå®ããé¢æ°ãå®è¡ããã
ãã®è¿ãå¤ã¯ã¨ã¼ã¸ã§ã³ãã®ã¹ãã¼ãã¨ãã¦ä½¿ããã¾ãã`start_link`ã¯ã
æå®ããé¢æ°ãæ»ãã¾ã§ã¯ãæ»ããªããã¨ã«æ³¨æãã¦ãã ããã

## ãªãã·ã§ã³

`:name`ãªãã·ã§ã³ã¯ã¢ã¸ã¥ã¼ã«ãã­ã¥ã¡ã³ãã§è¨è¼ããã¦ããããã«ã
ç»é²ã®ããã«ä½¿ããã¾ãã

`:timeout`ãªãã·ã§ã³ãæå®ãããå ´åãã¨ã¼ã¸ã§ã³ãã¯åæåã«æå¤§
æå®ã®ããªã»ã«ã³ãç§ã®æéãããããã¨ãè¨±ããã¾ãã
ãã®æéåã«çµäºããªãå ´åã¯ãã¨ã¼ã¸ã§ã³ãã¯çµäºããããã
ã¹ã¿ã¼ãé¢æ°ã¯`{:error, :timeout}`ãè¿ãã¾ãã

`:debug`ãªãã·ã§ã³ãæå®ãããå ´åã[`:sys` ã¢ã¸ã¥ã¼ã«](http://www.erlang.org/doc/man/sys.html) ã«ããå¯¾å¿ããé¢æ°ãèµ·åããã¾ãã

`:spawn_opt`ãæå®ãããå ´åããã®å¤ã¯`Process.spawn/4`ã¨åæ§ã«ã
æ ¹åºã«ãããã­ã»ã¹ã«ãªãã·ã§ã³ã¨ãã¦æ¸¡ããã¾ãã

## è¿ãå¤

ãµã¼ãã®ä½æãæåããåæåãããå ´åãé¢æ°ã¯`{:ok, pid}`ãè¿ãã¾ãã
ããã§pidã¯ãµã¼ãã®ãã­ã»ã¹è­å¥å­ã§ããæå®ããååãæã¤ã¨ã¼ã¸ã§ã³ãã
ãã§ã«å­å¨ããå ´åã¯ãé¢æ°ã¯ããã®ãã­ã»ã¹ã®PIDãä»ãã¦
`{:error, {:already_started, pid}}`ãè¿ãã¾ãã

æå®ããã³ã¼ã«ããã¯é¢æ°ã`reason`ã§å¤±æããå ´åã¯ã
é¢æ°ã¯`{:error, reason}`ãè¿ãã¾ãã
 ä¸ããããã¢ã¸ã¥ã¼ã«ãé¢æ°ãå¼æ°ã§ç¾å¨ã®ãã­ã»ã¹ã«ãªã³ã¯ããã
ã¨ã¼ã¸ã§ã³ããéå§ãã¾ãã

`start_link/2`ã¨åãã§ãããç¡åé¢æ°ã®æ¿ããã«ãã¢ã¸ã¥ã¼ã«ãé¢æ°ãå¼æ°
ãæå¾ãã¦ãã¾ãã
 ã¨ã¼ã¸ã§ã³ããã­ã»ã¹ããªã³ã¯ãªã(ç£è¦ããªã¼ã®å¤å´)ã§éå§ãã¾ãã

è©³ç´°ã¯ `start_link/2` ãåç§ãã¦ãã ããã
 ä¸ããããã¢ã¸ã¥ã¼ã«ã¨é¢æ°ãå¼æ°ã§ã¨ã¼ã¸ã§ã³ããéå§ãã¾ãã

`start/2`ã¨ä¼¼ã¦ãã¾ãããç¡åé¢æ°ã®æ¿ããã«ã
ã¢ã¸ã¥ã¼ã«ãé¢æ°ãå¼æ°ãæå¾ãã¦ãã¾ãã
 æå®ãã`reason`ã§ã¨ã¼ã¸ã§ã³ããåæ­¢ãã¾ãã

ãµã¼ããæå®ããreasonã§çµäºããå ´åã¯`:ok` ãè¿ãã
ä»ã® reason ã§çµäºããå ´åã¯ãexit ã
å¼ã³ã¾ãã

ãã®é¢æ°ã¯ã¨ã©ã¼ã¬ãã¼ãã«é¢ãã OTPã®ã»ãã³ãã£ã¯ã¹ã
ä¿æãã¾ããçç±ã`:normal`, `:shutdown`ã`{:shutdown, _}`
ä»¥å¤ã®å ´åã¯ãã¨ã©ã¼ã¬ãã¼ãã¯ã­ã°ããã¾ãã
 ã¨ã¼ã¸ã§ã³ãã®åå ã¨ã¼ã¸ã§ã³ãã®ãªãã¡ã¬ã³ã¹ ã¨ã¼ã¸ã§ã³ãã®ã¹ãã¼ã ã¨ã¼ã¸ã§ã³ãã¹ãã¼ããæ´æ°ãã¾ãã

`update/3`ã¨åãã§ãããç¡åé¢æ°ã®ãããã«ã¢ã¸ã¥ã¼ã«ãé¢æ°ãå¼æ°ãæå®
ãã¾ããã¹ãã¼ãã¯ä¸ããããå¼æ°ãªã¹ãã®æåã®å¼æ°ã¨ãã¦è¿½å ããã¾ãã
 ã¨ã¼ã¸ã§ã³ãã¹ãã¼ããæ´æ°ãã¾ãã

é¢æ°`fun`ãã¨ã¼ã¸ã§ã³ãã¹ãã¼ãããããã¦é¢æ°ãå¼ã³åºã`agent`ã¸
éä¿¡ããã¾ããé¢æ°ã¯æ°ããã¹ãã¼ããè¿ããªããã°ãªãã¾ããã

ã¿ã¤ã ã¢ã¦ããæå®ãããã¨ãã§ãã¾ã(ããã©ã«ãå¤ã¯5000ã§ã)ã
ãã®é¢æ°ã¯å¸¸ã«`:ok`ãè¿ãã¾ãã
 