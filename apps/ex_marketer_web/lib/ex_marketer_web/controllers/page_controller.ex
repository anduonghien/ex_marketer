defmodule ExMarketerWeb.PageController do
  use ExMarketerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end