. .env.sh
mix l10n.xgettext --elixir deps/elixir/lib/elixir --eex deps/elixir/lib/eex --iex deps/elixir/lib/iex --logger deps/elixir/lib/logger --mix deps/elixir/lib/mix --ex-unit deps/elixir/lib/ex_unit
mix l10n.msginit
mix l10n.msgmerge --update
