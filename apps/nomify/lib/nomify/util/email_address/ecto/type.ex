defmodule Nomify.Util.EmailAddress.Ecto.Type do
  use Ecto.Type

  alias Nomify.Util.EmailAddress

  @impl true
  def type, do: :email_address

  @impl true
  def cast(str) do
    EmailAddress.parse(str)
  end

  @impl true
  def dump(email_address) when is_binary(email_address) do
    {:ok, email_address}
  end

  @impl true
  def load(email_address) when is_binary(email_address) do
    {:ok, email_address}
  end
end
