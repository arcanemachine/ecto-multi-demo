defmodule EctoMultiDemo.Repo do
  use Ecto.Repo,
    otp_app: :ecto_multi_demo,
    adapter: Ecto.Adapters.Postgres
end
