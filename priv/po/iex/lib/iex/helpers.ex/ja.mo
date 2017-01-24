Þ          ä   %   ¬      @  5  A  9   w  ­   ±  °  _  V     ·   g  >    <  ^	  <   
  ð   Ø
    É  &   ×  ,   þ  å   +      Ä   "  O  ç  e   7  Ñ    Y  o  Z   É  )  $    N  ³  k  I  $    i%  U   '  ú   X'     S(  [   ô*  ¿   P+  Î  ,  v  ß.  [   V0  y  ²0  +  ,2  7   X3  8   3  A  É3  *  5  Ê   66  Q  7     S8  Ç  ó8    »<     D@  (  Ï@  M  øB  ½  FE                                              
                                                   	                             Calls `import/2` with the given arguments, but only if the module is available.

This lets you put imports in `.iex.exs` files (including `~/.iex.exs`) without
getting compile errors if you open a console where the module is not available.

## Example

    # In ~/.iex.exs
    import_if_available Ecto.Query

 Changes the current working directory to the given path.
 Clears the console screen.

This function only works if ANSI escape codes are enabled
on the shell, which means this function is by default
unavailable on Windows machines.
 Compiles the given files.

It expects a list of files to compile and an optional path to write
the compiled code to (defaults to the current directory). When compiling
one file, there is no need to wrap it in a list.

It returns the names of the compiled modules.

If you want to recompile an existing module, check `r/1` instead.

## Examples

    iex> c ["foo.ex", "bar.ex"], "ebin"
    [Foo, Bar]

    iex> c "baz.ex"
    [Baz]

 Creates a PID from `string`.

## Examples

    iex> pid("0.21.32")
    #PID<0.21.32>

 Creates a PID with 3 non negative integers passed as arguments
to the function.

## Examples

    iex> pid(0, 21, 32)
    #PID<0.21.32>
    iex> pid(0, 64, 2048)
    #PID<0.64.2048>

 Deploys a given module's BEAM code to a list of nodes.

This function is useful for development and debugging when you have code that
has been compiled or updated locally that you want to run on other nodes.

The node list defaults to a list of all connected nodes.

Returns `{:error, :nofile}` if the object code (i.e. ".beam" file) for the module
could not be found locally.

## Examples

    iex> nl(HelloWorld)
    {:ok, [{:node1@easthost, :loaded, HelloWorld},
           {:node1@westhost, :loaded, HelloWorld}]}

    iex> nl(NoSuchModuleExists)
    {:error, :nofile}

 Evaluates the contents of the file at `path` as if it were directly typed into
the shell.

`path` has to be a literal string. `path` is automatically expanded via
`Path.expand/1`.

## Examples

    # ~/file.exs
    value = 13

    # in the shell
    iex(1)> import_file "~/file.exs"
    13
    iex(2)> value
    13

 Flushes all messages sent to the shell and prints them out.
 Loads the given module's BEAM code (and ensures any previous
old version was properly purged before).

This function is useful when you know the bytecode for module
has been updated in the filesystem and you want to tell the VM
to load it.
 Prints information about the data type of any given term.

## Examples

    iex> i(1..5)

Will print:

    Term
      1..5
    Data type
      Range
    Description
      This is a struct. Structs are maps with a __struct__ key.
    Reference modules
      Range, Map

 Prints the current working directory.
 Prints the documentation for `IEx.Helpers`.
 Prints the documentation for the given callback function.

It also accepts single module argument to list
all available behaviour callbacks.

## Examples

    iex> b(Mix.Task.run/1)
    iex> b(Mix.Task.run)
    iex> b(GenServer)
 Prints the documentation for the given module
or for the given function/arity pair.

## Examples

    iex> h(Enum)

It also accepts functions in the format `fun/arity`
and `module.fun/arity`, for example:

    iex> h receive/1
    iex> h Enum.all?/2
    iex> h Enum.all?

 Prints the specs for the given module or for the given function/arity pair.

## Examples

    iex> s(Enum)
    iex> s(Enum.all?)
    iex> s(Enum.all?/2)
    iex> s(is_atom)
    iex> s(is_atom/1)

 Prints the types for the given module or for the given function/arity pair.

## Examples

    iex> t(Enum)
    @type t() :: Enumerable.t()
    @type element() :: any()
    @type index() :: integer()
    @type default() :: any()

    iex> t(Enum.t/0)
    @type t() :: Enumerable.t()

    iex> t(Enum.t)
    @type t() :: Enumerable.t()

 Produces a simple list of a directory's contents.

If `path` points to a file, prints its full path.
 Recompiles and reloads the given `module`.

Please note that all the modules defined in the same
file as `module` are recompiled and reloaded.

This function is meant to be used for development and
debugging purposes. Do not depend on it in production code.

## In-memory reloading

When we reload the module in IEx, we recompile the module source
code, updating its contents in memory. The original `.beam` file
in disk, probably the one where the first definition of the module
came from, does not change at all.

Since typespecs and docs are loaded from the .beam file (they
are not loaded in memory with the module because there is no need
for them to be in memory), they are not reloaded when you reload
the module.
 Recompiles the current Mix application.

This helper only works when IEx is started with a Mix
project, for example, `iex -S mix`. The application is
not restarted after compilation, which means any long
running process may crash as the code is updated but the
state does not go through the proper code changes callback.
In any case, the supervision tree should notice the failure
and restart such servers.

If you want to reload a single module, consider using
`r ModuleName` instead.

This function is meant to be used for development and
debugging purposes. Do not depend on it in production code.
 Respawns the current shell by starting a new shell process.

Returns `true` if it worked.
 Returns the value of the `n`th expression in the history.

`n` can be a negative value: if it is, the corresponding expression value
relative to the current one is returned. For example, `v(-2)` returns the
value of the expression evaluated before the last evaluated expression. In
particular, `v(-1)` returns the result of the last evaluated expression and
`v()` does the same.

## Examples

    iex(1)> "hello" <> " world"
    "hello world"
    iex(2)> 40 + 2
    42
    iex(3)> v(-2)
    "hello world"
    iex(4)> v(2)
    42
    iex(5)> v()
    42

 Similar to `import_file` but only imports the file it if it is available.

By default, `import_file/1` fails when the given file does not exist.
However, since `import_file/1` is expanded at compile-time, it's not
possible to conditionally import a file since the macro is always
expanded:

    # This raises a File.Error if ~/.iex.exs doesn't exist.
    if ("~/.iex.exs" |> Path.expand |> File.exists?) do
      import_file "~/.iex.exs"
    end

This macro addresses this issue by checking if the file exists or not
in behalf of the user.
 Welcome to Interactive Elixir. You are currently
seeing the documentation for the module `IEx.Helpers`
which provides many helpers to make Elixir's shell
more joyful to work with.

This message was triggered by invoking the helper `h()`,
usually referred to as `h/0` (since it expects 0 arguments).

You can use the `h/1` function to invoke the documentation
for any Elixir module or function:

    iex> h Enum
    iex> h Enum.map
    iex> h Enum.reverse/1

You can also use the `i/1` function to introspect any value
you have in the shell:

    iex> i "hello"

There are many other helpers available:

  * `b/1`           - prints callbacks info and docs for a given module
  * `c/1`           - compiles a file into the current directory
  * `c/2`           - compiles a file to the given path
  * `cd/1`          - changes the current directory
  * `clear/0`       - clears the screen
  * `flush/0`       - flushes all messages sent to the shell
  * `h/0`           - prints this help message
  * `h/1`           - prints help for the given module, function or macro
  * `i/1`           - prints information about the data type of any given term
  * `import_file/1` - evaluates the given file in the shell's context
  * `l/1`           - loads the given module's BEAM code
  * `ls/0`          - lists the contents of the current directory
  * `ls/1`          - lists the contents of the specified directory
  * `nl/2`          - deploys local BEAM code to a list of nodes
  * `pid/1`         - creates a PID from a string
  * `pid/3`         - creates a PID with the 3 integer arguments passed
  * `pwd/0`         - prints the current working directory
  * `r/1`           - recompiles the given module's source file
  * `recompile/0`   - recompiles the current project
  * `respawn/0`     - respawns the current shell
  * `s/1`           - prints spec information
  * `t/1`           - prints type information
  * `v/0`           - retrieves the last value from the history
  * `v/1`           - retrieves the nth value from the history

Help for all of those functions can be consulted directly from
the command line using the `h/1` helper itself. Try:

    iex> h(v/0)

To learn more about IEx as a whole, type `h(IEx)`.
 Project-Id-Version: l 10n_elixir
PO-Revision-Date: 2017-01-24 14:45+0900
Last-Translator: Keiji Suzuki <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
 `quoted_module`ãå©ç¨å¯è½ãªå ´åã«éãã`import/2`ãæå®ããå¼æ°ã§å¼ã³åºãã¾ãã

ãã®ã¢ã¸ã¥ã¼ã«ãå©ç¨ã§ããªãã³ã³ã½ã¼ã«ãéããå ´åãã³ã³ãã¤ã«ã¨ã©ã¼ãåºããã¨ãªã
`.iex.exs`ãã¡ã¤ã«ï¼`~/.iex.exs`ãå«ãï¼ã«ã¤ã³ãã¼ããç½®ããã¨ãã§ãã¾ãã

## ä¾

    # ~/.iex.exs ã«ããã¦
    import_if_available Ecto.Query

 ã«ã¬ã³ãã¯ã¼ã­ã³ã°ãã£ã¬ã¯ããªãæå®ã®ãã¹ã«å¤æ´ãã¾ãã
 ã³ã³ã½ã¼ã«ã¹ã¯ãªã¼ã³ãã¯ãªã¢ãã¾ãã

ãã®é¢æ°ã¯ANSIã¨ã¹ã±ã¼ãã³ã¼ããæå¹ãªã·ã§ã«ã§ã®ã¿åä½ãã¾ãã
ããã¯ãã®é¢æ°ã¯ããã©ã«ãã§ã¯Windowsã§å©ç¨ã§ããªããã¨ã
æå³ãã¾ãã
 æå®ãããã¡ã¤ã«ãã³ã³ãã¤ã«ãã¾ãã

ã³ã³ãã¤ã«ãããã¡ã¤ã«ã®ãªã¹ããæå®ãã¾ãã
ãªãã·ã§ã³ã§ã³ã³ãã¤ã«ãããã³ã¼ããæ¸ãåºããã¹ãæå®ãã¾ã
(ããã©ã«ãã¯ã«ã¬ã³ããã£ã¬ã¯ããªã§ã)ã
ãã¡ã¤ã«ãï¼ã¤ã ãã³ã³ãã¤ã«ããå ´åã¯ããªã¹ãã«ããå¿è¦ã¯ããã¾ããã

ã³ã³ãã¤ã«ãããã¢ã¸ã¥ã¼ã«ã®ååãè¿ãã¾ãã

æ¢å­ã®ã¢ã¸ã¥ã¼ã«ããªã³ã³ãã¤ã«ãããå ´åã¯ãä»£ããã«`r/1`ã
ãã§ãã¯ãã¦ã¿ã¦ãã ããã

## ä¾

    iex> c ["foo.ex", "bar.ex"], "ebin"
    [Foo, Bar]

    iex> c "baz.ex"
    [Baz]

 `string`ããPIDãä½æãã¾ãã

## ä¾

    iex> pid("0.21.32")
    #PID<0.21.32>

 ãã®é¢æ°ã¸å¼æ°ã¨ãã¦æ¸¡ããã3ã¤ã®éè² æ´æ°ããPIDã
ä½æãã¾ãã

## ä¾

    iex> pid(0, 21, 32)
    #PID<0.21.32>
    iex> pid(0, 64, 2048)
    #PID<0.64.2048>

 æå®ããã¢ã¸ã¥ã¼ã«ã®beamã³ã¼ãããã¼ããªã¹ãã¸ããã­ã¤ãã¾ãã

ãã®é¢æ°ã¯ãã­ã¼ã«ã«ã«ä»ã®ãã¼ãã§èµ°ãããããã³ã³ãã¤ã«ã¾ãã¯
æ´æ°ãããã³ã¼ããããå ´åã®éçºã¨ãããã°ã«ä¾¿å©ã§ãã

ãã¼ããªã¹ãã®ããã©ã«ãã¯å¨ã¦ã®æ¥ç¶ããããã¼ãã§ãã

ã¢ã¸ã¥ã¼ã«ã®ãªãã¸ã§ã¯ãã³ã¼ãï¼ããªãã¡ãâ.beamâãã¡ã¤ã«ï¼ãã­ã¼ã«ã«ã«ã¿ã¤ãããªãå ´åã¯
`{:error, :nofile}`ãè¿ãã¾ãã

## ä¾

    iex> nl(HelloWorld)
    {:ok, [{:node1@easthost, :loaded, HelloWorld},
           {:node1@westhost, :loaded, HelloWorld}]}

    iex> nl(NoSuchModuleExists)
    {:error, :nofile}

 `path` ãã¡ã¤ã«ã®åå®¹ãã·ã§ã«ã«ç´æ¥å¥åãããã®ããã«
è©ä¾¡ãã¾ãã

`path` ã¯ãªãã©ã«æå­åã§ãªããã°ãªãã¾ããã`path` ã¯`Path.expand/1` ã
ä½¿ã£ã¦èªåçã«å±éããã¾ãã

## ä¾

    # ~/file.exs
    value = 13

    # ã·ã§ã«ã«ããã¦
    iex(1)> import_file "~/file.exs"
    13
    iex(2)> value
    13

 ã·ã§ã«ã¸éãããå¨ã¦ã®ã¡ãã»ã¼ã¸ããã©ãã·ã¥ãã¦è¡¨ç¤ºãã¾ãã
 æå®ããã¢ã¸ã¥ã¼ã«ã®beamã³ã¼ããã­ã¼ããã¾ãã(ã¾ããã­ã¼ãåã«ã¯
ä»¥åã®å¤ããã¼ã¸ã§ã³ãæ­£ãããã¼ã¸ããããã¨ãä¿è¨¼ãã¾ã)ã

ãã®é¢æ°ã¯ããã¡ã¤ã«ã·ã¹ãã ã§ã¢ã¸ã¥ã¼ã«ã®ãã¤ãã³ã¼ãã
æ´æ°ããããã¨ãç¥ã£ã¦ãã¦ãVMã«ã­ã¼ãããããã«æããã
æã«ä¾¿å©ã§ãã
 æå®ããé ã®ãã¼ã¿åã«é¢ããæå ±ãè¡¨ç¤ºãã¾ãã

## ä¾

    iex> i(1..5)

æ¬¡ã®ããã«è¡¨ç¤ºããã¾ã:

    Term
      1..5
    Data type
      Range
    Description
      This is a struct. Structs are maps with a __struct__ key.
    Reference modules
      Range, Map

 ç¾å¨ã®ä½æ¥­ãã£ã¬ã¯ããªãè¡¨ç¤ºãã¾ãã
 `IEx.Helpers`ã®ãã­ã¥ã¡ã³ããè¡¨ç¤ºãã¾ãã
 æå®ããã³ã¼ã«ããã¯é¢æ°ã®ãã­ã¥ã¡ã³ããè¡¨ç¤ºãã¾ãã

ã¾ããã¢ã¸ã¥ã¼ã«ã®ã¿ãå¼æ°ã«ãããã¨ãã§ãããã®å ´åã
å©ç¨å¯è½ãªãã¹ã¦ã®behaviourã³ã¼ã«ããã¯ãè¡¨ç¤ºãã¾ãã

## ä¾

    iex> b(Mix.Task.run/1)
    iex> b(Mix.Task.run)
    iex> b(GenServer)
 æå®ããã¢ã¸ã¥ã¼ã«ã¾ãã¯é¢æ°/ã¢ãªãã£çµã®ãã­ã¥ã¡ã³ãã
è¡¨ç¤ºãã¾ãã

## ä¾

    iex> h(Enum)

ã¾ãã`fun/arity`ã¾ãã¯`module.fun/arity`ã®å½¢å¼ã®é¢æ°ã
åãä»ãã¾ããä¾ãã°: 

    iex> h receive/1
    iex> h Enum.all?/2
    iex> h Enum.all?

 æå®ããã¢ã¸ã¥ã¼ã«ã¾ãã¯é¢æ°/ã¢ãªãã£çµã®specãè¡¨ç¤ºãã¾ãã

## ä¾

    iex> s(Enum)
    iex> s(Enum.all?)
    iex> s(Enum.all?/2)
    iex> s(is_atom)
    iex> s(is_atom/1)

 æå®ã®ã¢ã¸ã¥ã¼ã«ã¾ãã¯é¢æ°/ã¢ãªãã£çµã®åãè¡¨ç¤ºãã¾ãã

## ä¾

    iex> t(Enum)
    @type t() :: Enumerable.t()
    @type element() :: any()
    @type index() :: integer()
    @type default() :: any()

    iex> t(Enum.t/0)
    @type t() :: Enumerable.t()

    iex> t(Enum.t)
    @type t() :: Enumerable.t()

 ãã£ã¬ã¯ããªåå®¹ã®ç°¡åãªãªã¹ããæä¾ãã¾ãã

`path`ããã¡ã¤ã«ãæãã¦ããå ´åã¯ããã®ãã«ãã¹ãè¡¨ç¤ºãã¾ãã
 `module`ããªã³ã³ãã¤ã«ãã¦ãªã­ã¼ããã¾ãã

`module`ã¨åããã¡ã¤ã«ã«å®ç¾©ããã¦ããå¨ã¦ã®ã¢ã¸ã¥ã¼ã«ã
ãªã³ã³ãã¤ã«ããªã­ã¼ãããããã¨ã«æ³¨æãã¦ãã ããã

ãã®é¢æ°ã¯éçºã¨ãããã°ç®çã§ä½¿ç¨ããããã¨ãæå³ãã¦ã¾ãã
è£½åã³ã¼ãã§ã¯ãã®é¢æ°ã¯ä½¿ããªãã§ãã ããã

## ã¤ã³ã¡ã¢ãªã»ãªã­ã¼ãã£ã³ã°

IExã§ã¢ã¸ã¥ã¼ã«ããªã­ã¼ãããæãã¢ã¸ã¥ã¼ã«ã½ã¼ã¹ã³ã¼ãã
ãªã³ã³ãã¤ã«ããã¡ã¢ãªã®åå®¹ãæ´æ°ãã¾ãã
ã¢ã¸ã¥ã¼ã«ã®æåã®å®ç¾©ãæ¸ããã¦ãããã£ã¹ã¯ä¸ã®ãªãªã¸ãã«ã®
`.beam`ãã¡ã¤ã«ãå¤æ´ããããã¨ã¯ããã¾ããã

typespecsã¨docsã¯ã.beamãã¡ã¤ã«ããã­ã¼ããããã®ã§
(ãããã¯å¿è¦ããªããããã¡ã¢ãªã«ã¯ã­ã¼ãããã¾ãã)ã
ã¢ã¸ã¥ã¼ã«ããªã­ã¼ããã¦ãããããã¯ãªã­ã¼ãããã¾ããã
 ç¾å¨ã®Mixã¢ããªã±ã¼ã·ã§ã³ãåã³ã³ãã¤ã«ãã¾ãã

ãã®ãã«ãã¯IExãããã¨ãã°`iex -S mix`ã®ããã«ã
Mixãã­ã¸ã§ã¯ããä¼´ã£ã¦éå§ãããå ´åã«ã®ã¿åä½ãã¾ãã
ã³ã³ãã¤ã«å¾ã«ã¢ããªã±ã¼ã·ã§ã³ã¯åã¹ã¿ã¼ããã¾ããã
ããã¯ãã³ã¼ãã¯æ´æ°ããããç¶æã¯é©åãªã³ã¼ãå¤æ´callbackã
çµãªããããç¨¼åä¸­ã ã£ããã­ã»ã¹ã¯ã¯ã©ãã·ã¥ããå¯è½æ§ã
ãããã¨ãæå³ãã¾ãããããã«ãã¦ããç£è¦ããªã¼ã¯ãã®éå®³ã«
æ°ã¥ãããµã¼ãããªã¹ã¿ã¼ãããã¯ãã§ãã

ä¸ã¤ã®ã¢ã¸ã¥ã¼ã«ããªã­ã¼ããããå ´åã¯ãä»£ããã«
`r ModuleName`ã®ä½¿ç¨ãæ¤è¨ãã¦ãã ããã

ãã®é¢æ°ã¯éçºã¾ãã¯ãããã°ç®çã§ä½¿ç¨ããããã¨ãæå³ãã¦ã¾ãã
è£½åã³ã¼ãã§ã¯ä½¿ç¨ããªãã§ãã ããã
 æ°ããã·ã§ã«ãã­ã»ã¹ãéå§ãããã¨ã§ç¾å¨ã®ã·ã§ã«ãåçæãã¾ãã

æåããã¨`true`ãè¿ãã¾ãã
 å±¥æ­´ã®`n`çªç®ã®å¼ã®å¤ãè¿ãã¾ãã

`n`ã«ã¯è² å¤ãæå®ã§ãã¾ãããã®å ´åãç¾å¨ã®å¼ããç¸å¯¾ãã
è©²å½ã®å¼ã®å¤ãè¿ãã¾ãããã¨ãã°ã`v(-2)`ã¯ãæå¾ã«è©ä¾¡ããã
å¼ã®åã«è©ä¾¡ãããå¼ã®å¤ãè¿ãã¾ããç¹ã«ã`v(-1)`ã¯æå¾ã«
è©ä¾¡ããå¼ã®çµæãè¿ãã¾ããã¾ãã`v(0)`ãåãã§ãã

## ä¾

    iex(1)> "hello" <> " world"
    "hello world"
    iex(2)> 40 + 2
    42
    iex(3)> v(-2)
    "hello world"
    iex(4)> v(2)
    42
    iex(5)> v()
    42

 `import_file`ã¨åãã§ãããå©ç¨å¯è½ãªãã¡ã¤ã«ã®ã¿ã¤ã³ãã¼ããã¾ãã

ããã©ã«ãã§ã¯ã`import_file/1` ã¯æå®ãããã¡ã¤ã«ãå­å¨ããªã
å ´åå¤±æãã¾ãããããã`import_file/1`ã¯ã³ã³ãã¤ã«æã«å±éããã
ã®ã§ããã¡ã¤ã«ãæ¡ä»¶ä»ãã§ã¤ã³ãã¼ããããã¨ã¯ã§ãã¾ããããã¯ã­ã¯
å¸¸ã«å±éãããããã§ãã

    #  ~/.iex.exs ãå­å¨ããªãã¨ããã¯ File.Error ãçºçãã¾ãã
    if ("~/.iex.exs" |> Path.expand |> File.exists?) do
      import_file "~/.iex.exs"
    end

 ã¤ã³ã¿ã©ã¯ãã£ãElixirã¸ãããããããã¯Elixirã·ã§ã«ããã£ã¨æ¥½ã
ãããããã«å¤ãã®ãã«ãã¼ãæä¾ãã¦ãã`IEx.Helpers`ã¢ã¸ã¥ã¼ã«ã®
ãã­ã¥ã¡ã³ãã§ãã

ãã®ã¡ãã»ã¼ã¸ã¯ãéå¸¸ `h/0`(ããã¯å¼æ°ã®æ°ã0åã¨ãããã¨ãç¤ºãã¦ãã¾ã)
ã§åç§ããããã«ãã¼`h()`ãèµ·åãããã¨ã«ããè¡¨ç¤ºããããã®ã§ãã

Elixirã®ä»»æã®ã¢ã¸ã¥ã¼ã«ãé¢æ°ã®ãã­ã¥ã¡ã³ããè¡¨ç¤ºããã«ã¯
`h/1`é¢æ°ãä½¿ãã¾ã:

    iex> h Enum
    iex> h Enum.map
    iex> h Enum.reverse/1

shellã®ä¸­ã«ããå ´åã¯ãä»»æã®å¤ã®åé¨æå ±ãè¦ãããã«`i/1`é¢æ°ãä½¿ããã¨ã
ã§ãã¾ã:

    iex> i "hello"

ä»ã«ãæ²¢å±±ã®ãã«ãã¼ãå©ç¨ã§ãã¾ã:

  * `b/1`           - ä¸ããããã¢ã¸ã¥ã¼ã«ã®callback info ã¨ docsãè¡¨ç¤ºãã¾ã
  * `c/1`           - ãã¡ã¤ã«ãã³ã³ãã¤ã«ãã¦ã«ã¬ã³ããã£ã¬ã¯ããªã«ç½®ãã¾ã
  * `c/2`           - ãã¡ã¤ã«ãã³ã³ãã¤ã«ãã¦æå®ã®ãã¹ã«ç½®ãã¾ã
  * `cd/1`          - ã«ã¬ã³ããã£ã¬ã¯ããªãå¤æ´ãã¾ã
  * `clear/0`       - ã¹ã¯ãªã¼ã³ãã¯ãªã¢ãã¾ã
  * `flush/0`       - ã·ã§ã«ã¸éä¿¡ãããã¹ã¦ã®ã¡ãã»ã¼ã¸ããã©ãã·ã¥ãã¾ã
  * `h/0`           - ãã®ãã«ãã¡ãã»ã¼ã¸ãè¡¨ç¤ºãã¾ã
  * `h/1`           - ä¸ããããã¢ã¸ã¥ã¼ã«ãé¢æ°ããã¯ã­ã®ãã«ããè¡¨ç¤ºãã¾ã
  * `i/1`           - ä¸ããããé ã®ãã¼ã¿ã¿ã¤ãã«é¢ããæå ±ãè¡¨ç¤ºãã¾ã
  * `import_file/1` - ä¸ãããããã¡ã¤ã«ãã·ã§ã«ã®ã³ã³ãã­ã¹ãã§è©ä¾¡ãã¾ã
  * `l/1`           - ä¸ããããã¢ã¸ã¥ã¼ã«ã®beamã³ã¼ããã­ã¼ããã¾ã
  * `ls/0`          - ã«ã¬ã³ããã£ã¬ã¯ããªã®åå®¹ããªã¹ããã¾ã
  * `ls/1`          - æå®ããããã£ã¬ã¯ããªã®åå®¹ããªã¹ããã¾ã
  * `nl/2`          - ä¸ããããbeamã³ã¼ãããã¼ãã®ãªã¹ãã¸ããã­ã¤ãã¾ã
  * `pid/1`         - æå­åããPIDãä½æãã¾ã
  * `pid/3`         - æ¸¡ããã3ã¤ã®æ´æ°å¼æ°ã§PIDãä½æãã¾ã
  * `pwd/0`         - ã«ã¬ã³ãã¯ã¼ã­ã³ã°ãã£ã¬ã¯ããªãè¡¨ç¤ºãã¾ã
  * `r/1`           - ä¸ããããã¢ã¸ã¥ã¼ã«ã®ã½ã¼ã¹ãã¡ã¤ã«ãåã³ã³ãã¤ã«ãã¾ã
  * `recompile/0`   - ç¾å¨ã®ãã­ã¸ã§ã¯ããåã³ã³ãã¤ã«ãã¾ã
  * `respawn/0`     - ç¾å¨ã®ã·ã§ã«ãåçæãã¾ã
  * `s/1`           - Specæå ±ãè¡¨ç¤ºãã¾ã
  * `t/1`           - åæå ±ãè¡¨ç¤ºãã¾ã
  * `v/0`           - å±¥æ­´ã®ææ°ã®å¤ãåãåºãã¾ã
  * `v/1`           - å±¥æ­´ã®nçªç®ã®å¤ãåãåºãã¾ã

ããããã¹ã¦ã®é¢æ°ã®ãã«ãã¯`h/1`ãä½¿ã£ã¦ã³ãã³ãã©ã¤ã³ãã
ç´æ¥èª¿ã¹ããã¨ãã§ãã¾ããæ¬¡ã®ããã«ã§ã:

    iex> h(v/0)

IExå¨è¬ã«ã¤ãã¦ãã£ã¨å­¦ã¶ããã«ã¯ã`h(IEx)`ã¨ã¿ã¤ããã¦ãã ããã
 