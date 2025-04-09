defmodule NomifyWeb.PageControllerTest do
  use NomifyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Nomify"
  end
end
