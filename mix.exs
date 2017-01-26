defmodule L10nElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :l10n_elixir,
      version: "0.0.4",
      compilers: Mix.compilers ++ [:po],
      source_url: "https://github.com/elixir-lang/elixir",
      exgettext: [ extra: Extrans ],
      aliases: aliases(),
      docs: fn() -> docs() end,
      deps: deps(),
      switches: [eex: :string, elixir: :string, ex_unit: :string,
        iex: :string, logger: :string, mix: :string],
    ]
  end

  def abs_path(s) when is_list(s) do
    Path.join([File.cwd! | s])
  end

  def abs_path(s) do
    Path.join(File.cwd!, s)
  end

  def make_source_ref(source_dir) do
    gitdir = Path.join(source_dir, ".git")
    {shead, 0} = System.cmd("git", ["--git-dir", gitdir,
                                    "rev-parse", "HEAD"])
    shead = String.rstrip(shead)
    {stag, 0} = System.cmd("git", ["--git-dir", gitdir,
                                   "tag", "--points-at", shead])
    stag = String.rstrip(stag)
    case stag do
      nil -> shead
      "" -> shead
      _ -> stag
    end
  end

  def docs do
    Keyword.put(subapp_docs({"elixir", "Elixir", "Kernel"}),
       :extras, [
                  "pages/Behaviours.md",
                  "pages/Guards.md",
                  "pages/Naming Conventions.md",
                  "pages/Operators.md",
                  "pages/Typespecs.md",
                  "pages/Writing Documentation.md"
                ]
    )
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:exgettext]]
  end
  defp aliases do
    [docs_all: &docs_all/1]
  end

  def docs_all(opts \\ []) do
    apps = [{"eex", "EEx", "EEx"}, {"ex_unit", "ExUnit", "ExUnit"}, {"iex", "IEx", "IEx"}, {"logger", "Logger", "Logger"}, {"mix", "Mix", "Mix"}]

    subapp = List.first(opts)
    if subapp do
      case List.keyfind(apps, subapp, 0) do
      {app, proj, main} ->
        make_doc({app, proj, main})
      _ ->
        IO.puts "Invalid name: #{subapp}"
      end
    else
      Enum.map apps, &(make_doc(&1))
    end
  end

  defp subapp_docs({app, proj, main}) do
    source_dir = "deps/elixir"
    sref = if (File.exists?(source_dir)) do
         make_source_ref(source_dir)
       else
         nil
       end
    version_path = Path.join(source_dir, "VERSION")
    {:ok, version} = if File.exists?(version_path) do
                   File.read(version_path)
                 else
                   {:ok, nil}
                 end
    Code.append_path("_build/dev/lib/ex_doc/ebin")
    Code.append_path("_build/dev/lib/exgettext/ebin")
    sr = abs_path([source_dir, "lib/#{app}/ebin"])

    [
       project: proj,
       app: app,
       version: version,
       formatter: Exgettext.HTML,
       source_root: abs_path("deps/elixir"),
       logo: "logo.png",
       logo_url: "http://elixir-lang.org/docs/logo.png",
       source_beam: sr,
       source_ref: sref,
       output: "doc/#{version}/#{app}",
       main: main,
       deps: deps()
    ]
  end

  defp make_doc({app, proj, main}) do
    docs = subapp_docs({app, proj, main})
    b = String.to_atom(app)
    lang = Regex.replace(~r/(..).*/, System.get_env("LANG"), "\\1")

    l10napp =
      [
         name: b,
         compilers: Mix.compilers ++ [:po],
         exgettext: [ extra: Extrans ],
         version: Keyword.get(docs, :version),
         source_url: "https://github.com/elixir-lang/elixir",
         docs: docs,
         lang: lang
      ]

    case Application.load(b) do
      :ok -> :ok
      {:error, {:already_loaded, _m}} -> :ok
    end
#      IO.inspect [{b, Application.spec(b)}]
    b = Application.spec(b)
      |> Keyword.get(:modules)
      |> hd
      |> Module.concat(nil)
    l10napp = update_in(l10napp,
                        [:docs, :source_root],
                        fn(_) ->
                          d = Path.dirname(b.__info__(:compile)[:source])
                          r = Path.join([d, "..", "..", ".."])
                          |> Path.expand
                          # IO.inspect [r: r]
                          r
                        end)
#    IO.inspect [l10napp: l10napp]
#    exit(:normal)
    fmt(l10napp)
    Mix.Tasks.Docs.run([], l10napp)
  end

  defp fmt(config) do
    app = config[:docs][:app]
    lang = config[:lang]
    pofiles = Exgettext.Util.pofiles(app, lang)
    mofile = Path.join([Exgettext.Runtime.basedir(:l10n_elixir), "lang", "#{lang}", "l10n_#{app}.exmo"])
    Mix.shell.info("msgfmt for #{app}")
    dir = Path.dirname(mofile)
    :ok = File.mkdir_p(dir)
    :ok = Exgettext.Tool.msgfmt(pofiles, mofile)
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:elixir, github: "elixir-lang/elixir", tag: "v1.4.0"}, # tag: "v1.2.0"},
     {:ex_doc, "~> 0.14.5"},
     {:earmark, "~> 1.0.0"},
     {:exgettext, git: "git@bitbucket.org:zuki_ebetsu/exgettext.git"},
     {:extrans, git: "git@bitbucket.org:zuki_ebetsu/extrans.git"}
#     {:exgettext, path: "../exgettext"},
#     {:extrans, path: "../extrans"}
    ]
  end
end
