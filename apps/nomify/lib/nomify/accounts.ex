defmodule Nomify.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Nomify.Repo

  alias Nomify.Accounts.{Scope, User, UserNotifier, UserToken}
  alias Nomify.Attrs

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  @spec get_user_by_email(String.t()) :: User.t() | nil
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  @spec get_user_by_email_and_password(String.t(), String.t()) :: User.t() | nil
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(integer()) :: User.t()
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec register_user(Attrs.t()) :: {:ok, User.t()} | {:error, Changeset.t(User.t())}
  def register_user(attrs) do
    %User{}
    |> User.email_changeset(attrs)
    |> Repo.insert()
  end

  ## Settings

  @doc """
  Checks whether the user is in sudo mode.

  The user is in sudo mode when the last authentication was done no further
  than 20 minutes ago. The limit can be given as second argument in minutes.
  """
  @spec sudo_mode?(User.t() | nil, integer()) :: boolean()
  def sudo_mode?(user, minutes \\ -20)

  def sudo_mode?(%User{authenticated_at: ts}, minutes) when is_struct(ts, NaiveDateTime) do
    NaiveDateTime.after?(ts, NaiveDateTime.utc_now() |> NaiveDateTime.add(minutes, :minute))
  end

  def sudo_mode?(_user, _minutes), do: false

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  See `Nomify.Accounts.User.email_changeset/3` for a list of supported options.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user_email(User.t(), Attrs.t(), keyword()) :: Changeset.t(User.t())
  def change_user_email(user, attrs \\ %{}, opts \\ []) do
    User.email_changeset(user, attrs, opts)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  """
  @spec update_user_email(User.t(), String.t()) :: :ok | :error
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset = User.email_changeset(user, %{email: email})

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, [context]))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  See `Nomify.Accounts.User.password_changeset/3` for a list of supported options.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  @spec change_user_password(User.t(), Attrs.t(), keyword()) :: Changeset.t(User.t())
  def change_user_password(user, attrs \\ %{}, opts \\ []) do
    User.password_changeset(user, attrs, opts)
  end

  @doc """
  Updates the user password.

  Returns the updated user, as well as a list of expired tokens.

  ## Examples

      iex> update_user_password(user, %{password: ...})
      {:ok, %User{}, [...]}

      iex> update_user_password(user, %{password: "too short"})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user_password(User.t(), Attrs.t()) ::
          {:ok, User.t(), [UserToken.t()]} | {:error, Changeset.t(User.t())}
  def update_user_password(user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> update_user_and_delete_all_tokens()
    |> case do
      {:ok, user, expired_tokens} -> {:ok, user, expired_tokens}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  @spec generate_user_session_token(User.t()) :: binary()
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  @spec get_user_by_session_token(binary()) :: User.t() | nil
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Gets the user with the given magic link token.
  """
  @spec get_user_by_magic_link_token(String.t()) :: User.t() | nil
  def get_user_by_magic_link_token(token) do
    with {:ok, query} <- UserToken.verify_magic_link_token_query(token),
         {user, _token} <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Logs the user in by magic link.

  There are three cases to consider:

  1. The user has already confirmed their email. They are logged in
     and the magic link is expired.

  2. The user has not confirmed their email and no password is set.
     In this case, the user gets confirmed, logged in, and all tokens -
     including session ones - are expired. In theory, no other tokens
     exist but we delete all of them for best security practices.

  3. The user has not confirmed their email but a password is set.
     This cannot happen in the default implementation but may be the
     source of security pitfalls. See the "Mixing magic link and password registration" section of
     `mix help phx.gen.auth`.
  """
  @spec login_user_by_magic_link(String.t()) ::
          {:ok, User.t(), [UserToken.t()]} | {:error, :not_found}
  def login_user_by_magic_link(token) do
    {:ok, query} = UserToken.verify_magic_link_token_query(token)

    case Repo.one(query) do
      # Prevent session fixation attacks by disallowing magic links for unconfirmed users with password
      {%User{confirmed_at: nil, hashed_password: hash}, _token} when not is_nil(hash) ->
        raise """
        magic link log in is not allowed for unconfirmed users with a password set!

        This cannot happen with the default implementation, which indicates that you
        might have adapted the code to a different use case. Please make sure to read the
        "Mixing magic link and password registration" section of `mix help phx.gen.auth`.
        """

      {%User{confirmed_at: nil} = user, _token} ->
        user
        |> User.confirm_changeset()
        |> update_user_and_delete_all_tokens()

      {user, token} ->
        Repo.delete!(token)
        {:ok, user, []}

      nil ->
        {:error, :not_found}
    end
  end

  @doc ~S"""
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_user_update_email_instructions(user, current_email, &url(~p"/user/settings/confirm-email/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  @spec deliver_user_update_email_instructions(
          User.t(),
          String.t(),
          (String.t() -> String.t())
        ) :: {:ok, Swoosh.Email.t()} | {:error, term()}
  def deliver_user_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc ~S"""
  Delivers the magic link login instructions to the given user.
  """
  @spec deliver_login_instructions(User.t(), (String.t() -> String.t())) ::
          {:ok, Swoosh.Email.t()} | {:error, term()}
  def deliver_login_instructions(%User{} = user, magic_link_url_fun)
      when is_function(magic_link_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "login")
    Repo.insert!(user_token)
    UserNotifier.deliver_login_instructions(user, magic_link_url_fun.(encoded_token))
  end

  @doc """
  Deletes the signed token with the given context.
  """
  @spec delete_user_session_token(binary()) :: :ok
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end

  ## Token helper

  @spec update_user_and_delete_all_tokens(Changeset.t(User.t())) ::
          {:ok, User.t(), [UserToken.t()]} | {:error, term(), term(), term()}
  defp update_user_and_delete_all_tokens(changeset) do
    %{data: %User{} = user} = changeset

    with {:ok, %{user: user, tokens_to_expire: expired_tokens}} <-
           Ecto.Multi.new()
           |> Ecto.Multi.update(:user, changeset)
           |> Ecto.Multi.all(:tokens_to_expire, UserToken.by_user_and_contexts_query(user, :all))
           |> Ecto.Multi.delete_all(:tokens, fn %{tokens_to_expire: tokens_to_expire} ->
             UserToken.delete_all_query(tokens_to_expire)
           end)
           |> Repo.transaction() do
      {:ok, user, expired_tokens}
    end
  end

  @spec test_scope() :: Scope.t()
  def test_scope do
    %Scope{user: %User{id: 1}}
  end
end
