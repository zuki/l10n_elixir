Þ          Ü   %         0  u  1  ß   §       1     O  R  n  ¢  Æ  
  É   Ø  º  ¢  è   ]    F    ]  (  {  ú   ¤        U  6!    #  ¯  %    ¼&  ò   Ê*  ¤  ½+    b0  5  z4  I  °5  ¿  ú6  Z  º8  Ó   :  ¥  é:    <  ´  ?  Ó  SA  [  'D  ]  E  v  áM    XO  þ	  ëP  õ  êZ  (  à^  Â   	`  ^  Ì`  Á  +d  Y  íe  ~  Gh    Æm  î  àn  å  Ït  °  µz                        	                                        
                                                               Appends a path to the end of the Erlang VM code path list.

This is the list of directories the Erlang VM uses for
finding module code.

The path is expanded with `Path.expand/1` before being appended.
If this path does not exist, an error is returned.

## Examples

    Code.append_path(".") #=> true

    Code.append_path("/does_not_exist") #=> {:error, :bad_directory}

 Compiles the given string.

Returns a list of tuples where the first element is the module name
and the second one is its byte code (as a binary).

For compiling many files at once, check `Kernel.ParallelCompiler.files/2`.
 Compiles the quoted expression.

Returns a list of tuples where the first element is the module name and
the second one is its byte code (as a binary).
 Converts the given string to its quoted form.

It returns the ast if it succeeds,
raises an exception otherwise. The exception is a `TokenMissingError`
in case a token is missing (usually because the expression is incomplete),
`SyntaxError` otherwise.

Check `string_to_quoted/2` for options information.
 Converts the given string to its quoted form.

Returns `{:ok, quoted_form}`
if it succeeds, `{:error, {line, error, token}}` otherwise.

## Options

  * `:file` - the filename to be used in stacktraces
    and the file reported in the `__ENV__/0` macro

  * `:line` - the line reported in the `__ENV__/0` macro

  * `:existing_atoms_only` - when `true`, raises an error
    when non-existing atoms are found by the tokenizer

## Macro.to_string/2

The opposite of converting a string to its quoted form is
`Macro.to_string/2`, which converts a quoted form to a string/binary
representation.
 Deletes a path from the Erlang VM code path list. This is the list of
directories the Erlang VM uses for finding module code.

The path is expanded with `Path.expand/1` before being deleted. If the
path does not exist it returns `false`.

## Examples

    Code.prepend_path(".")
    Code.delete_path(".") #=> true

    Code.delete_path("/does_not_exist") #=> false

 Ensures the given module is compiled and loaded.

If the module is already loaded, it works as no-op. If the module was
not loaded yet, it checks if it needs to be compiled first and then
tries to load it.

If it succeeds loading the module, it returns `{:module, module}`.
If not, returns `{:error, reason}` with the error reason.

Check `ensure_loaded/1` for more information on module loading
and when to use `ensure_loaded/1` or `ensure_compiled/1`.
 Ensures the given module is compiled and loaded.

Similar to `ensure_compiled/1`, but returns `true` if the module
is already loaded or was successfully loaded and compiled.
Returns `false` otherwise.
 Ensures the given module is loaded.

If the module is already loaded, this works as no-op. If the module
was not yet loaded, it tries to load it.

If it succeeds loading the module, it returns `{:module, module}`.
If not, returns `{:error, reason}` with the error reason.

## Code loading on the Erlang VM

Erlang has two modes to load code: interactive and embedded.

By default, the Erlang VM runs in interactive mode, where modules
are loaded as needed. In embedded mode the opposite happens, as all
modules need to be loaded upfront or explicitly.

Therefore, this function is used to check if a module is loaded
before using it and allows one to react accordingly. For example, the `URI`
module uses this function to check if a specific parser exists for a given
URI scheme.

## Code.ensure_compiled/1

Elixir also contains an `ensure_compiled/1` function that is a
superset of `ensure_loaded/1`.

Since Elixir's compilation happens in parallel, in some situations
you may need to use a module that was not yet compiled, therefore
it can't even be loaded.

`ensure_compiled/1` halts the current process until the
module we are depending on is available.

In most cases, `ensure_loaded/1` is enough. `ensure_compiled/1`
must be used in rare cases, usually involving macros that need to
invoke a module for callback information.

## Examples

    iex> Code.ensure_loaded(Atom)
    {:module, Atom}

    iex> Code.ensure_loaded(DoesNotExist)
    {:error, :nofile}

 Ensures the given module is loaded.

Similar to `ensure_loaded/1`, but returns `true` if the module
is already loaded or was successfully loaded. Returns `false`
otherwise.

## Examples

    iex> Code.ensure_loaded?(Atom)
    true

 Evals the given file.

Accepts `relative_to` as an argument to tell where the file is located.

While `load_file` loads a file and returns the loaded modules and their
byte code, `eval_file` simply evaluates the file contents and returns the
evaluation result and its bindings.
 Evaluates the contents given by `string`.

The `binding` argument is a keyword list of variable bindings.
The `opts` argument is a keyword list of environment options.

## Options

Options can be:

  * `:file` - the file to be considered in the evaluation
  * `:line` - the line on which the script starts

Additionally, the following scope values can be configured:

  * `:aliases` - a list of tuples with the alias and its target

  * `:requires` - a list of modules required

  * `:functions` - a list of tuples where the first element is a module
    and the second a list of imported function names and arity; the list
    of function names and arity must be sorted

  * `:macros` - a list of tuples where the first element is a module
    and the second a list of imported macro names and arity; the list
    of function names and arity must be sorted

Notice that setting any of the values above overrides Elixir's default
values. For example, setting `:requires` to `[]`, will no longer
automatically require the `Kernel` module; in the same way setting
`:macros` will no longer auto-import `Kernel` macros like `if/2`, `case/2`,
etc.

Returns a tuple of the form `{value, binding}`,
where `value` is the value returned from evaluating `string`.
If an error occurs while evaluating `string` an exception will be raised.

`binding` is a keyword list with the value of all variable bindings
after evaluating `string`. The binding key is usually an atom, but it
may be a tuple for variables defined in a different context.

## Examples

    iex> Code.eval_string("a + b", [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line)
    {3, [a: 1, b: 2]}

    iex> Code.eval_string("c = a + b", [a: 1, b: 2], __ENV__)
    {3, [a: 1, b: 2, c: 3]}

    iex> Code.eval_string("a = a + b", [a: 1, b: 2])
    {3, [a: 3, b: 2]}

For convenience, you can pass `__ENV__/0` as the `opts` argument and
all imports, requires and aliases defined in the current environment
will be automatically carried over:

    iex> Code.eval_string("a + b", [a: 1, b: 2], __ENV__)
    {3, [a: 1, b: 2]}

 Evaluates the quoted contents.

**Warning**: Calling this function inside a macro is considered bad
practice as it will attempt to evaluate runtime values at compile time.
Macro arguments are typically transformed by unquoting them into the
returned quoted expressions (instead of evaluated).

See `eval_string/3` for a description of bindings and options.

## Examples

    iex> contents = quote(do: var!(a) + var!(b))
    iex> Code.eval_quoted(contents, [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line)
    {3, [a: 1, b: 2]}

For convenience, you can pass `__ENV__/0` as the `opts` argument and
all options will be automatically extracted from the current environment:

    iex> contents = quote(do: var!(a) + var!(b))
    iex> Code.eval_quoted(contents, [a: 1, b: 2], __ENV__)
    {3, [a: 1, b: 2]}

 Gets the compilation options from the code server.

Check `compiler_options/1` for more information.

## Examples

    Code.compiler_options
    #=> %{debug_info: true, docs: true,
          warnings_as_errors: false, ignore_module_conflict: false}

 Lists all loaded files.

## Examples

    Code.require_file("../eex/test/eex_test.exs")
    List.first(Code.loaded_files) =~ "eex_test.exs" #=> true

 Loads the given file.

Accepts `relative_to` as an argument to tell where the file is located.
If the file was already required/loaded, loads it again.

It returns a list of tuples `{ModuleName, <<byte_code>>}`, one tuple for
each module defined in the file.

Notice that if `load_file` is invoked by different processes concurrently,
the target file will be loaded concurrently many times. Check `require_file/2`
if you don't want a file to be loaded concurrently.

## Examples

    Code.load_file("eex_test.exs", "../eex/test") |> List.first
    #=> {EExTest.Compiled, <<70, 79, 82, 49, ...>>}

 Prepends a path to the beginning of the Erlang VM code path list.

This is the list of directories the Erlang VM uses for finding
module code.

The path is expanded with `Path.expand/1` before being prepended.
If this path does not exist, an error is returned.

## Examples

    Code.prepend_path(".") #=> true

    Code.prepend_path("/does_not_exist") #=> {:error, :bad_directory}

 Removes files from the loaded files list.

The modules defined in the file are not removed;
calling this function only removes them from the list,
allowing them to be required again.

## Examples

    # Load EEx test code, unload file, check for functions still available
    Code.load_file("../eex/test/eex_test.exs")
    Code.unload_files(Code.loaded_files)
    function_exported?(EExTest.Compiled, :before_compile, 0) #=> true

 Requires the given `file`.

Accepts `relative_to` as an argument to tell where the file is located.
The return value is the same as that of `load_file/2`. If the file was already
required/loaded, doesn't do anything and returns `nil`.

Notice that if `require_file` is invoked by different processes concurrently,
the first process to invoke `require_file` acquires a lock and the remaining
ones will block until the file is available. I.e. if `require_file` is called
N times with a given file, it will be loaded only once. The first process to
call `require_file` will get the list of loaded modules, others will get `nil`.

Check `load_file/2` if you want a file to be loaded multiple times. See also
`unload_files/1`

## Examples

If the code is already loaded, it returns `nil`:

    Code.require_file("eex_test.exs", "../eex/test") #=> nil

If the code is not loaded yet, it returns the same as `load_file/2`:

    Code.require_file("eex_test.exs", "../eex/test") |> List.first
    #=> {EExTest.Compiled, <<70, 79, 82, 49, ...>>}

 Returns a list with the available compiler options.

See `Code.compiler_options/1` for more info.

## Examples

    iex> Code.available_compiler_options
    [:docs, :debug_info, :ignore_module_conflict, :relative_paths, :warnings_as_errors]

 Returns the docs for the given module.

When given a module name, it finds its BEAM code and reads the docs from it.

When given a path to a .beam file, it will load the docs directly from that
file.

The return value depends on the `kind` value:

  * `:docs` - list of all docstrings attached to functions and macros
    using the `@doc` attribute

  * `:moduledoc` - tuple `{<line>, <doc>}` where `line` is the line on
    which module definition starts and `doc` is the string
    attached to the module using the `@moduledoc` attribute

  * `:callback_docs` - list of all docstrings attached to
    `@callbacks` using the `@doc` attribute

  * `:type_docs` - list of all docstrings attached to
    `@type` callbacks using the `@typedoc` attribute

  * `:all` - a keyword list with `:docs` and `:moduledoc`, `:callback_docs`,
    and `:type_docs`.

If the module cannot be found, it returns `nil`.

## Examples

    # Get the module documentation
    iex> {_line, text} = Code.get_docs(Atom, :moduledoc)
    iex> String.split(text, "\n") |> Enum.at(0)
    "Convenience functions for working with atoms."

    # Module doesn't exist
    iex> Code.get_docs(ModuleNotGood, :all)
    nil

 Sets compilation options.

These options are global since they are stored by Elixir's Code Server.

Available options are:

  * `:docs` - when `true`, retain documentation in the compiled module,
    `true` by default

  * `:debug_info` - when `true`, retain debug information in the compiled
    module; this allows a developer to reconstruct the original source
    code, `false` by default

  * `:ignore_module_conflict` - when `true`, override modules that were
    already defined without raising errors, `false` by default

  * `:relative_paths` - when `true`, use relative paths in quoted nodes,
    warnings and errors generated by the compiler, `true` by default.
    Note disabling this option won't affect runtime warnings and errors.

  * `:warnings_as_errors` - causes compilation to fail when warnings are
    generated

It returns the new list of compiler options.

## Examples

    Code.compiler_options(debug_info: true)
    #=> %{debug_info: true, docs: true,
          warnings_as_errors: false, ignore_module_conflict: false}

 Utilities for managing code compilation, code evaluation and code loading.

This module complements Erlang's [`:code` module](http://www.erlang.org/doc/man/code.html)
to add behaviour which is specific to Elixir. Almost all of the functions in this module
have global side effects on the behaviour of Elixir.
 Project-Id-Version: elixir 1.4.0
PO-Revision-Date: 2017-01-25 12:22+0900
Last-Translator: Keiji Suzuki <EMAIL@ADDRESS>
Language-Team: Japanese
Language: ja
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
POT-Creation-Date: 
X-Generator: Poedit 1.8.11
 Erlang VMã³ã¼ããã¹ãªã¹ãã®æå¾ã«ãã¹ãè¿½å ãã¾ãã

ããã¯Erlang VMãã¢ã¸ã¥ã¼ã«ã³ã¼ããæ¢ãããã«ä½¿ç¨ãã
ãã£ã¬ã¯ããªã®ãªã¹ãã§ãã

ãã¹ã¯è¿½å ãããåã«`Path.expand/1` ã§å±éããã¾ãã
ãã®ãã¹ãå­å¨ããªãå ´åã¯ã¨ã©ã¼ãè¿ããã¾ãã

## ä¾

    Code.append_path(".") #=> true

    Code.append_path("/does_not_exist") #=> {:error, :bad_directory}

 æå®ããæå­åãã³ã³ãã¤ã«ãã¾ãã

ã¿ãã«ã®ãªã¹ããè¿ãã¾ããã¿ãã«ã®æåã®è¦ç´ ã¯ã¢ã¸ã¥ã¼ã«åã§
2çªç®ã®è¦ç´ ã¯ãã®ãã¤ãã³ã¼ãï¼ãã¤ããªï¼ã§ãã

è¤æ°ã®ãã¡ã¤ã«ãåæã«ã³ã³ãã¤ã«ããã«ã¯`Kernel.ParallelCompiler.files/2`ããã§ãã¯ãã¦ãã ããã
 quoteãããå¼ãã³ã³ãã¤ã«ãã¾ãã

ã¿ãã«ã®ãªã¹ããè¿ãã¾ããã¿ãã«ã®æåã®è¦ç´ ã¯ã¢ã¸ã¥ã¼ã«åã§
2çªç®ã®è¦ç´ ã¯ãã®ãã¤ãã³ã¼ãï¼ãã¤ããªï¼ã§ãã
 æå®ããæå­åãquoteãããå½¢å¼ã«å¤æãã¾ãã

æåããå ´åã¯ASTãè¿ãã¾ãã
ããã§ãªãå ´åã¯ãä¾å¤ãçºçãã¾ããtokenãæ¬ ãã¦ããå ´åã®
ä¾å¤ã¯`TokenMissingError`ã§ãï¼éå¸¸ãå¼ãä¸å®å¨ãªå ´åã§ãï¼ã
ããä»¥å¤ã®ä¾å¤ã¯`SyntaxError`ã§ãã

ãªãã·ã§ã³ã«é¢ããæå ±ã¯`string_to_quoted/2`ããã§ãã¯ãã¦ãã ããã
 æå®ããæå­åãquoteãããå½¢å¼ã«å¤æãã¾ãã

æåããå ´åã¯ã`{:ok, quoted_form}`ãè¿ãã¾ãã
ããã§ãªãå ´åã¯ã`{:error, {line, error, token}}`ãè¿ãã¾ãã

## ãªãã·ã§ã³

  * `:file` - ã¹ã¿ãã¯ãã¬ã¼ã¹ã§ä½¿ç¨ããããã¡ã¤ã«åã¨
    `__ENV__/0`ãã¯ã­ã§å ±åããããã¡ã¤ã«

  * `:line` - `__ENV__/0` ãã¯ã­ã§å ±åãããè¡

  * `:existing_atoms_only` - `true`ã®å ´åããã¼ã¯ãã¤ã¶ã¼ã
    å­å¨ããªãã¢ãã ãçºè¦ããå ´åã¨ã©ã¼ãã¯ã£ãããã¾ã

## Macro.to_string/2

æå­åããquateããããããå½¢å¼ã¸ã®å¤æã®éã`Macro.to_string/2`ã§ãã
ããã¯quateããããããå½¢å¼ãæå­å/ãã¤ããªè¡¨ç¾ã«
å¤æãã¾ãã
 Erlang VMã³ã¼ããã¹ãªã¹ããããã¹ãåé¤ãã¾ããããã¯Erlang VMã
ã¢ã¸ã¥ã¼ã«ã³ã¼ããæ¢ãããã«ä½¿ç¨ãããã£ã¬ã¯ããªã®ãªã¹ãã§ãã

ãã¹ã¯è¿½å ãããåã«`Path.expand/1` ã§å±éããã¾ãã
ãã¹ãå­å¨ããªãå ´åã¯`false`ãè¿ãã¾ãã

## ä¾

    Code.prepend_path(".")
    Code.delete_path(".") #=> true

    Code.delete_path("/does_not_exist") #=> false

 æå®ããã¢ã¸ã¥ã¼ã«ãã³ã³ãã¤ã«ãããã­ã¼ãããã¦ãããã¨ãä¿è¨¼ãã¾ãã

ã¢ã¸ã¥ã¼ã«ããã§ã«ã­ã¼ãããã¦ããå ´åã¯ãno-opã¨ãã¦ä½ç¨ãã¾ãã
ã¢ã¸ã¥ã¼ã«ãã¾ã ã­ã¼ãããã¦ããªãå ´åã¯ãã¾ãã³ã³ãã¤ã«ãå¿è¦ã§ããã
ãã§ãã¯ãããã®å¾ã­ã¼ããè©¦ã¿ã¾ãã

ã¢ã¸ã¥ã¼ã«ã®ã­ã¼ãã«æåããå ´åã¯ã`{:module, module}`ãè¿ãã¾ãã
å¤±æããå ´åã¯ãã¨ã©ã¼ã®çç±ãæ·»ãã¦`{:error, reason}` ãè¿ãã¾ãã

ã¢ã¸ã¥ã¼ã«ã®ã­ã¼ãã£ã³ã°ã`ensure_loaded/1`ã¾ãã¯`ensure_compiled/1`ã
ä½¿ãéã®è©³ããæå ±ã¯`ensure_loaded/1` ããã§ãã¯ãã¦ãã ããã
 æå®ããã¢ã¸ã¥ã¼ã«ãã³ã³ãã¤ã«ãããã­ã¼ãããã¦ãããã¨ãä¿è¨¼ãã¾ãã

`ensure_compiled/1`ã¨åãã§ãããã¢ã¸ã¥ã¼ã«ããã§ã«ã­ã¼ãããã¦ããã
ã¾ãã¯ãã­ã¼ããã¦ã³ã³ãã¤ã«ã«æåããå ´åã¯ã`true`ãè¿ãã¾ãã
ããã§ãªãå ´åã¯`false`ãè¿ãã¾ãã

 æå®ããã¢ã¸ã¥ã¼ã«ãã­ã¼ãããã¦ãããã¨ãä¿è¨¼ãã¾ãã

ã¢ã¸ã¥ã¼ã«ããã§ã«ã­ã¼ãããã¦ããå ´åã¯ãno-opã¨ãã¦ä½ç¨ãã¾ãã
ã¢ã¸ã¥ã¼ã«ãã¾ã ã­ã¼ãããã¦ããªãå ´åã¯ãã­ã¼ããè©¦ã¿ã¾ãã

ã¢ã¸ã¥ã¼ã«ã®ã­ã¼ãã«æåããå ´åã¯ã`{:module, module}`ãè¿ãã¾ãã
å¤±æããå ´åã¯ãã¨ã©ã¼ã®çç±ãæ·»ãã¦`{:error, reason}` ãè¿ãã¾ãã

## Erlang VMã§ã®ã³ã¼ãã®ã­ã¼ãã£ã³ã°

Erlangã¯ã³ã¼ãã®ã­ã¼ãã«é¢ãã¦2ã¤ã®ã¢ã¼ããæã£ã¦ãã¾ã: ã¤ã³ã¿ã©ã¯ãã£ãã¨ã¨ã³ããããã§ãã

ããã©ã«ãã§ã¯ãErlang VMã¯ã¤ã³ã¿ã©ã¯ãã£ãã¢ã¼ãã§åä½ããã¢ ã¸ã¥ã¼ã«ã¯
å¿è¦ã«å¿ãã¦ã­ã¼ãããã¾ããã¨ã³ããããã¢ã¼ãã§ã¯ããã®åå¯¾ã§ãããã¹ã¦ã®
ã¢ã¸ã¥ã¼ã«ã¯äºåã«ãã¾ãã¯æç¤ºçã«ã­ã¼ããããå¿è¦ãããã¾ãã

ãã®ãããã¢ã¸ã¥ã¼ã«ãä½¿ãåã«ãããã­ã¼ãããã¦ããããã§ãã¯ããããã«ãã®
é¢æ°ãä½¿ç¨ããã¾ãããã¨ãã°ã`URI`ã¢ã¸ã¥ã¼ã«ã¯ãã®é¢æ°ãä½¿ã£ã¦ãæå®ãã
URIã¹ã­ã¼ã ã«å¯¾å¿ããç¹å®ã®ãã¼ãµã¼ãå­å¨ããããã§ãã¯ãã¦ãã¾ãã

## Code.ensure_compiled/1

Elixirã¯`ensure_loaded/1`ã®ã¹ã¼ãã¼ã»ããã§ãã`ensure_compiled/1`é¢æ°ã
æã£ã¦ãã¾ãã

Elixirã®ã³ã³ãã¤ã«ã¯ä¸¦åã§è¡ãããã®ã§ãç¶æ³ã«ãã£ã¦ã¯ã¾ã ã³ã³ãã¤ã«ããã¦ãããã
ã­ã¼ãã§ããªãã¢ã¸ã¥ã¼ã«ãå¿è¦ã«ãªãå ´åãããã¾ãã

`ensure_compiled/1`ã¯ä¾å­ãã¦ããã¢ã¸ã¥ã¼ã«ãå©ç¨å¯è½ã«ãªãã¾ã§ã«ã¬ã³ããã­ã»ã¹ã
åæ­¢ãã¾ãã

ã»ã¨ãã©ã®å ´åã`ensure_loaded/1` ã§ååã§ãã`ensure_compiled/1`ã¯
éå¸¸ãã³ã¼ã«ããã¯æå ±ã®ããã«ã¢ã¸ã¥ã¼ã«ãèµ·åããå¿è¦ããããã¯ã­ã®èµ·åãªã©ã®
ç¨ãªã±ã¼ã¹ã§ä½¿ç¨ãããªããã°ãªãã¾ããã

## ä¾

    iex> Code.ensure_loaded(Atom)
    {:module, Atom}

    iex> Code.ensure_loaded(DoesNotExist)
    {:error, :nofile}

 æå®ããã¢ã¸ã¥ã¼ã«ãã­ã¼ãããã¦ãããã¨ãä¿è¨¼ãã¾ãã

`ensure_loaded/1`ã¨åãã§ãããã¢ã¸ã¥ã¼ã«ããã§ã«ã­ã¼ãããã¦ããã
ã¾ãã¯ãã­ã¼ããã¦ã³ã³ãã¤ã«ã«æåããå ´åã¯ã`true`ãè¿ãã¾ãã
ããã§ãªãå ´åã¯`false`ãè¿ãã¾ãã

## ä¾

    iex> Code.ensure_loaded?(Atom)
    true

 æå®ãããã¡ã¤ã«ãè©ä¾¡ãã¾ãã

ãã¡ã¤ã«ãã©ãã«ç½®ããã¦ããããç¥ãããå¼æ°ã¨ãã¦`relative_to`ãåãä»ãã¾ãã

`load_file`ã¯ãã¡ã¤ã«ãã­ã¼ããã¦ãã­ã¼ãããã¢ã¸ã¥ã¼ã«ã¨ãã®ãã¤ãã³ã¼ãã
è¿ãã¾ããã`eval_file`ã¯åã«ãã¡ã¤ã«åå®¹ãè©ä¾¡ããè©ä¾¡çµæã¨ãã®ãã¤ã³ãã£ã³ã°ã
è¿ãã¾ãã
 `string`ã¨ãã¦æå®ãããã³ã³ãã³ããè©ä¾¡ãã¾ãã

`binding`å¼æ°ã¯å¤æ°ãã¤ã³ãã£ã³ã°ã®ã­ã¼ã¯ã¼ããªã¹ãã§ãã
`opts`å¼æ°ã¯ç°å¢ãªãã·ã§ã³ã®ã­ã¼ã¯ã¼ããªã¹ãã§ãã

## ãªãã·ã§ã³

ãªãã·ã§ã³ã«ã¯ä»¥ä¸ãæå®ã§ãã¾ã:

  * `:file` - è©ä¾¡ã®éã«èæ®ããããã¡ã¤ã«
  * `:line` - ã¹ã¯ãªãããå§ã¾ãè¡

ããã«ãæ¬¡ã®ã¹ã³ã¼ãå¤ãæ§æã§ãã¾ãã

 * `:aliases` - ã¨ã¤ãªã¢ã¹ã¨ãã®å¯¾è±¡ãæã¤ã¿ãã«ã®ãªã¹ã

  * `:requires` - å¿è¦ãªã¢ã¸ã¥ã¼ã«ã®ãªã¹ã

  * `:functions` - ç¬¬1è¦ç´ ãã¢ã¸ã¥ã¼ã«ãç¬¬2è¦ç´ ãã¤ã³ãã¼ããããé¢æ°åã¨ã¢ãªãã£ã®
    ãªã¹ãã§ããã¿ãã«ã®ãªã¹ããé¢æ°åã¨ã¢ãªãã£ã®ãªã¹ãã¯
    ã½ã¼ãæ¸ã¿ã§ãªããã°ãªããªã

  * `:macros` - ç¬¬1è¦ç´ ãã¢ã¸ã¥ã¼ã«ãç¬¬2è¦ç´ ãã¤ã³ãã¼ãããããã¯ã­åã¨ã¢ãªãã£ã®
    ãªã¹ãã§ããã¿ãã«ã®ãªã¹ãããã¯ã­åã¨ã¢ãªãã£ã®ãªã¹ãã¯
    ã½ã¼ãæ¸ã¿ã§ãªããã°ãªããªã

ä¸è¨ã®å¤ã®è¨­å®ã«ãããElixirã®ããã©ã«ãå¤ãä¸æ¸ããããã¨ã«æ³¨æãã¦ ãã ããã
ãã¨ãã°ã`:requires`ã`[]`ã«è¨­å®ããã¨Kernelã¢ã¸ã¥ã¼ ã«ãèªåçã«require
ãããªããªãã¾ããåãããã«`:macros`ãè¨­å®ããã¨ã`if/2`ã`case/2`ãªã©ã®
`Kernel`ãã¯ã­ãèªåçã«ã¤ã³ãã¼ããããªã
ãªãã¾ãã

 `{value, binding}`å½¢å¼ã®ã¿ãã«ãè¿ãã¾ããããã§`value`ã¯`string`ã®è©ä¾¡ã«ãã
è¿ãããå¤ã§ãã`string`ã®è©ä¾¡ä¸­ã«ã¨ã©ã¼ãçºçããå ´åã¯ãä¾å¤ãçºçãã¾ãã

`binding`ã¯ã`string`è©ä¾¡å¾ã®ãã¹ã¦ã®å¤æ°ãã¤ã³ãã£ã³ã°ã®å¤ãæã¤
ã­ã¼ã¯ã¼ããªã¹ãã§ãããã¤ã³ãã£ã³ã°ã­ã¼ã¯éå¸¸ã¢ãã ã§ãããç°ãªãã³ã³ãã­ã¹ãã§
å®ç¾©ãããå¤æ°ã®ã¿ãã«ã§ããå ´åãããã¾ãã
## Examples

    iex> Code.eval_string("a + b", [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line)
    {3, [a: 1, b: 2]}

    iex> Code.eval_string("c = a + b", [a: 1, b: 2], __ENV__)
    {3, [a: 1, b: 2, c: 3]}

    iex> Code.eval_string("a = a + b", [a: 1, b: 2])
    {3, [a: 3, b: 2]}

ä¾¿å©ãªããã«ã`opts`å¼æ°ã¨ãã¦`__ENV__/0`ãæ¸¡ããã¨ãã§ãã¾ãã
ããããã¨ãç¾å¨ã®ç°å¢ã§å®ç¾©ããããã¹ã¦ã®import, require, aliaseã
èªåçã«å¼ãç¶ãã¾ãã

    iex> Code.eval_string("a + b", [a: 1, b: 2], __ENV__)
    {3, [a: 1, b: 2]}

 quoteãããã³ã³ãã³ããè©ä¾¡ãã¾ãã

**è­¦å**: ãã¯ã­åã§ã®ãã®é¢æ°ã®å¼ã³åºãã¯æªãè¡ãã ã¨èãããã¾ãã
ããã¯ã³ã³ãã¤ã«æã«å®è¡æã®å¤ãè©ä¾¡ãããã¨ãããã¨ã ããã§ãã
ãã¯ã­ã®å¼æ°ã¯ãéå¸¸ããããunquoteãããã¨ã«ããï¼è©ä¾¡ãããã®ã¯ãªãï¼
è¿ãå¤ã§ããquoteãããå¼ã«å¤æããã¾ãã

ãã¤ã³ãã£ã³ã°ã¨ãªãã·ã§ã³ã®èª¬æã«ã¤ãã¦ã¯`eval_string/3`ãåç§ãã¦ãã ããã

## ä¾

    iex> contents = quote(do: var!(a) + var!(b))
    iex> Code.eval_quoted(contents, [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line)
    {3, [a: 1, b: 2]}

ä¾¿å©ãªããã«ã`opts`å¼æ°ã¨ãã¦`__ENV__/0`ãæ¸¡ããã¨ãã§ãã¾ããããããã¨
ãã¹ã¦ã®ãªãã·ã§ã³ãç¾å¨ã®ç°å¢ããèªåçã«æ½åºããã¾ãã

    iex> contents = quote(do: var!(a) + var!(b))
    iex> Code.eval_quoted(contents, [a: 1, b: 2], __ENV__)
    {3, [a: 1, b: 2]}

 ã³ã¼ããµã¼ãããã³ã³ãã¤ã«ãªãã·ã§ã³ãåå¾ãã¾ãã

è©³ç´°ãªæå ±ã¯`compiler_options/1`ããã§ãã¯ãã¦ãã ããã

## ä¾

    Code.compiler_options
    #=> %{debug_info: true, docs: true,
          warnings_as_errors: false, ignore_module_conflict: false}

 ã­ã¼ãããã¦ãããã¹ã¦ã®ãã¡ã¤ã«ããªã¹ããã¾ãã

## ä¾

    Code.require_file("../eex/test/eex_test.exs")
    List.first(Code.loaded_files) =~ "eex_test.exs" #=> true

 æå®ãããã¡ã¤ã«ãã­ã¼ããã¾ãã

ãã¡ã¤ã«ãã©ãã«ç½®ããã¦ããããç¥ãããå¼æ°ã¨ãã¦`relative_to`ãåãä»ãã¾ãã
ãã¡ã¤ã«ããã§ã«requireã¾ãã¯ã­ã¼ãããã¦ããå ´åã¯ãååº¦ã­ã¼ããã¾ãã

ã¿ãã«`{ModuleName, <<byte_code>>}`,ã®ãªã¹ããè¿ãã¾ãã
ãã®ãã¡ã¤ã«ã§å®ç¾©ããã¦ããã¢ã¸ã¥ã¼ã«ãã¨ã«ã¿ãã«ãä½æããã¾ãã

`load_file`ãç°ãªããã­ã»ã¹ã§ä¸¦è¡ãã¦å®è¡ãããå ´åãå¯¾è±¡ã¨ãªããã¡ã¤ã«ã¯
ä¸¦è¡ãã¦ä½åº¦ãã­ã¼ãããããã¨ã«æ³¨æãã¦ãã ããããã¡ã¤ã«ãä¸¦è¡ãã¦
ã­ã¼ãããããªãå ´åã¯ã`require_file/2`ããã§ãã¯ãã¦ãã ããã

## ä¾

    Code.load_file("eex_test.exs", "../eex/test") |> List.first
    #=> {EExTest.Compiled, <<70, 79, 82, 49, ...>>}

 Erlang VMã³ã¼ããã¹ãªã¹ãã®åé ­ã«pathãè¿½å ãã¾ãã

ããã¯Erlang VMãã¢ã¸ã¥ã¼ã«ã³ã¼ããæ¢ãããã«ä½¿ç¨ãã
ãã£ã¬ã¯ããªã®ãªã¹ãã§ãã

ãã¹ã¯è¿½å ãããåã«`Path.expand/1 `ã§å±éããã¾ãã
ãã®ãã¹ãå­å¨ããªãå ´åã¯ã¨ã©ã¼ãè¿ããã¾ãã

## ä¾

    Code.prepend_path(".") #=> true

    Code.prepend_path("/does_not_exist") #=> {:error, :bad_directory}



 ã­ã¼ãæ¸ã¿ãã¡ã¤ã«ãªã¹ããããã¡ã¤ã«ãåé¤ãã¾ãã

ãã¡ã¤ã«åã§å®ç¾©ããã¦ããã¢ã¸ã¥ã¼ã«ã¯åé¤ããã¾ããã
ãã®é¢æ°ã®å¼ã³åºãã¯ãªã¹ããããã¡ã¤ã«ãåé¤ããã ãã§ã
ããããåã³requireã§ããããã«ãã¾ãã
## ä¾

    # EEx ãã¹ãã³ã¼ããã­ã¼ããããã¡ã¤ã«ãã¢ã³ã­ã¼ãããé¢æ°ãã¾ã å©ç¨ã§ããããã§ãã¯ãã
    Code.load_file("../eex/test/eex_test.exs")
    Code.unload_files(Code.loaded_files)
    function_exported?(EExTest.Compiled, :before_compile, 0) #=> true

 æå®ãã`file`ãrequireãã¾ãã

ãã¡ã¤ã«ãç½®ãããä½ç½®ãç¥ãããããã®å¼æ°ã¨ãã¦ã`relative_to`ãåãä»ãã¾ãã
è¿ãå¤ã¯`load_file/2`ã¨åãã§ãããã¡ã¤ã«ãæ¢ã«requirã¾ãã¯ã­ã¼ãããã¦ãã
å ´åã¯ãä½ããã`nil`ãè¿ãã¾ãã

`require_file`ãç°ãªããã­ã»ã¹ã§ä¸¦è¡ãã¦å®è¡ãããå ´åãæåã®ãã­ã»ã¹ã¯
`require_file`ãå®è¡ããããã«ã­ãã¯ãè¦æ±ããä»ã®ãã­ã»ã¹ã¯ãã¡ã¤ã«ãå©ç¨
å¯è½ã«ãªãã¾ã§ãã­ãã¯ããã¾ããããªãã¡ã`require_file`ãæå®ãããã¡ã¤ã«ã§
Nåå¼ã³åºãããå ´åããã¡ã¤ã«ã¯1åããã­ã¼ãããã¾ããã`require_file`ãå¼ã³åºãæåã®
ãã­ã»ã¹ã¯ã­ã¼ããããã¢ã¸ã¥ã¼ã«ã®ãªã¹ããååãããã®ä»ã®ãã­ã»ã¹ã¯`nil`ãååãã¾ãã

ãã¡ã¤ã«ãè¤æ°åã­ã¼ããããå ´åã¯ã`load_file/2`ããã§ãã¯ãã¦ãã ãããã¾ãã
`unload_files/1`ãåç§ãã¦ãã ããã

## ä¾

ã³ã¼ãããã§ã«ã­ã¼ãããã¦ããå ´åã¯`nil`ãè¿ãã¾ã:

    Code.require_file("eex_test.exs", "../eex/test") #=> nil

ã³ã¼ããã¾ã ã­ã¼ãããã¦ããªãå ´åã¯ã`load_file/2`ã¨åããã®ãè¿ãã¾ã:

    Code.require_file("eex_test.exs", "../eex/test") |> List.first
    #=> {EExTest.Compiled, <<70, 79, 82, 49, ...>>}

 å©ç¨å¯è½ãªã³ã³ãã¤ã©ãªãã·ã§ã³ã®ãªã¹ããè¿ãã¾ãã

è©³ç´°ã¯`Code.compiler_options/1`ãåç§ãã¦ãã ããã

## ä¾

    iex> Code.available_compiler_options
    [:docs, :debug_info, :ignore_module_conflict, :relative_paths, :warnings_as_errors]

 æå®ããã¢ã¸ã¥ã¼ã«ã®ãã­ã¥ã¡ã³ããè¿ãã¾ãã

ã¢ã¸ã¥ã¼ã«åãæå®ãããå ´åã¯ããã®BEAMã³ã¼ããæ¢ãã¦ãã­ã¥ã¡ã³ããèª­ã¿è¾¼ã¿ã¾ãã

.beamãã¡ã¤ã«ã®ãã¹ãæå®ãããå ´åã¯ããã®ãã¡ã¤ã«ããç´æ¥ãã­ã¥ã¡ã³ãã
ã­ã¼ããã¾ãã

è¿ãå¤ã¯`kind`å¤ã«ããã¾ãã

  * `:docs` - `@doc`å±æ§ãä½¿ã£ã¦é¢æ°ããã¯ã­ã«ã²ãä»ãããããã¹ã¦ã®ãã­ã¥ã¡ã³ã
    æå­åã®ãªã¹ã

  * `:moduledoc` - ã¿ãã« `{<line>, <doc>}`ãããã§ã`line`ã¯ã¢ã¸ã¥ã¼ã«å®ç¾©ã
    éå§ããè¡ã§ããã`doc`ã¯`@moduledoc`å±æ§ãä½¿ã£ã¦ã¢ã¸ã¥ã¼ã«ã«ã²ãä»ãããã
    æå­åã§ã

  * `:callback_docs` - `@doc`å±æ§ãä½¿ã£ã¦`@callbacks` ã«ã²ãä»ãããã
    ãã¹ã¦ã®ãã­ã¥ã¡ã³ãæå­åã®ãªã¹ã

  * `:type_docs` -  `@typedoc`å±æ§ãä½¿ã£ã¦`@type`ã³ã¼ã«ããã¯ ã«ã²ãä»ãããã
    ãã¹ã¦ã®ãã­ã¥ã¡ã³ãæå­åã®ãªã¹ã

  * `:all` - `:docs`ã¨`:moduledoc`ã`:callback_docs`
    `:type_docs`ãæã¤ã­ã¼ã¯ã¼ããªã¹ã

ã¢ã¸ã¥ã¼ã«ãè¦ã¤ãããã¨ãã§ããªãã£ãå ´åã¯ã`nil`ãè¿ãã¾ãã

## ä¾

    # Get the module documentation
    iex> {_line, text} = Code.get_docs(Atom, :moduledoc)
    iex> String.split(text, "\n") |> Enum.at(0)
    "Convenience functions for working with atoms."

    # ã¢ã¸ã¥ã¼ã«ãå­å¨ããªã
    iex> Code.get_docs(ModuleNotGood, :all)
    nil

 ã³ã³ãã¤ã«ãªãã·ã§ã³ãè¨­å®ãã¾ãã

ãããã®ãªãã·ã§ã³ã¯Elixirã®ã³ã¼ããµã¼ãã«ä¿ç®¡ãããã®ã§ã°ã­ã¼ãã«ã§ãã

å©ç¨å¯è½ãªãªãã·ã§ã³ã¯æ¬¡ã®éã:

  * `:docs` - `true`ã®å ´åãã³ã³ãã¤ã«ãããã¢ã¸ã¥ã¼ã«ã«ãã­ã¥ã¡ã³ããä¿æãã¾ãã
    ããã©ã«ãã¯`true`ã§ã

  * `:debug_info` - `true`ã®å ´åãã³ã³ãã¤ã«ãããã¢ã¸ã¥ã¼ã«ã«ãããã°æå ±ãä¿æãã¾ãã
    ããã«ããéçºèã¯ãªãªã¸ãã«ã®ã½ã¼ã¹ã³ã¼ããåæ§ç¯ãããã¨ãã§ãã¾ãã
    ããã©ã«ãã¯`false`ã§ã

  * `:ignore_module_conflict` - `true`ã®å ´åããã§ã«å®ç¾©å·®rã¦ããã¢ã¸ã¥ã¼ã«ãã¨ã©ã¼ã
    çºçãããã¨ãªãä¸æ¸ããã¾ããããã©ã«ãã¯`false`ã§ã

  * `:relative_paths` - `true`ã®å ´åãwhen `true`, quoteããããã¼ããã³ã³ãã¤ã©ã«ãã
    çæãããè­¦åãã¨ã©ã¼ã®ä¸­ã§ç¸å¯¾ãã¹ãä½¿ç¨ãã¾ããããã©ã«ãã¯`true`ã§ã
    ãã®ãªãã·ã§ã³ãç¡å¹ã«ãã¦ãå®è¡æã®è­¦åãã¨ã©ã¼ã«ã¯å½±é¿ãä¸ããªããã¨ã«æ³¨æãã¦ãã ããã

  * `:warnings_as_errors` - è­¦åãçºçãããéã«ã³ã³ãã¤ã©ã
    å¤±æããã¾ãã

æ°ããã³ã³ãã¤ã©ãªãã·ã§ã³ã®ãªã¹ããè¿ãã¾ãã

## ä¾

    Code.compiler_options(debug_info: true)
    #=> %{debug_info: true, docs: true,
          warnings_as_errors: false, ignore_module_conflict: false}

 ã³ã¼ãã®ã³ã³ãã¤ã«ãã³ã¼ãã®è©ä¾¡ãã³ã¼ãã®ã­ã¼ããç®¡çããã¦ã¼ãã£ãªãã£ã§ãã

ãã®ã¢ã¸ã¥ã¼ã«ã¯Erlangã® [`:code` module](http://www.erlang.org/doc/man/code.html)ã
è£å®ãããã®ã§ãElixirã«åºæã®ãµãã¾ããè¿½å ãã¾ãããã®ã¢ã¸ã¥ã¼ã«ã®ã»ã¨ãã©ãã¹ã¦ã®é¢æ°ã¯
Elixirã®ãµãã¾ãã«ããã¦ã°ã­ã¼ãã«ãªå¯ä½ç¨ãæã£ã¦ãã¾ãã
 