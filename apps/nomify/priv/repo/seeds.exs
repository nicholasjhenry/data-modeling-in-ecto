# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Nomify.Repo.insert!(%Nomify.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Nomify.Accounts

{:ok, user} = Accounts.register_user(%{email: "admin@example.com"})

{:ok, _user, _expired_tokens} =
  Accounts.update_user_password(user, %{password: "adminadminadmin"})
