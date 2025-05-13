defmodule Nomify do
  @moduledoc """
  A document review process to empowering teams to collaborate,  review, and approve documents.

  ## Sub-Domains

  For information on each sub-domain, see:

  - `Nomify.Directory`: Handles the organization and categorization of documents within the system.
  - `Nomify.Documents`: Manages the lifecycle of documents, including creation, review, and approval processes.
  - `Nomify.Teams`: Facilitates collaboration by managing team members and their roles in the document review process.

  ## Ecto ERD

  ![Ecto ERD](./assets/erd.png) [View Larger Image](./assets/erd.png)
  """

  @doc false
  def record do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query, warn: false
      import Nomify.Result
    end
  end

  @doc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
