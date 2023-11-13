defmodule EctoMultiDemo.Repo do
  import Ecto.Query

  use Ecto.Repo,
    otp_app: :ecto_multi_demo,
    adapter: Ecto.Adapters.Postgres

  def count(queryable) do
    from(q in queryable, select: count(q.id)) |> __MODULE__.one()
  end
end
