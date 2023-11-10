defmodule EctoMultiDemoWeb.PageController do
  use EctoMultiDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
