defmodule ExMarketerWeb.KeywordControllerTest do
  use ExMarketerWeb.ConnCase, async: true

  describe "given the keyword that existing in the database" do
    test "GET /keywords", %{conn: conn} do
      insert(:keyword, keyword: "Keyword 1", status: "created")
      insert(:keyword, keyword: "Keyword 2", status: "in_progress")
      insert(:keyword, keyword: "Keyword 3", status: "failed")
      insert(:keyword, keyword: "Keyword 4", status: "successed")

      conn = get(conn, Routes.keyword_path(conn, :index))

      assert html_response(conn, 200) =~ "Keyword 1 - #{gettext("created")}"
      assert html_response(conn, 200) =~ "Keyword 2 - #{gettext("in_progress")}"
      assert html_response(conn, 200) =~ "Keyword 3 - #{gettext("failed")}"
      assert html_response(conn, 200) =~ "Keyword 4 - #{gettext("successed")}"
      assert html_response(conn, 200) =~ "class=\"card card-keyword card-keyword--created\""
      assert html_response(conn, 200) =~ "class=\"card card-keyword card-keyword--in_progress\""
      assert html_response(conn, 200) =~ "class=\"card card-keyword card-keyword--failed\""
      assert html_response(conn, 200) =~ "class=\"card card-keyword card-keyword--successed\""
      assert html_response(conn, 200) =~ gettext("view_details")
      assert html_response(conn, 200) =~ gettext("view_page")
    end

    test "GET /keywords/:id", %{conn: conn} do
      successed_keyword = insert(:keyword, keyword: "Example keyword", status: "successed")
      in_progress_keyword = insert(:keyword, status: "in_progress")
      failed_keyword = insert(:keyword, status: "failed")
      created_keyword = insert(:keyword, status: "created")

      conn_1 = get(conn, Routes.keyword_path(conn, :show, successed_keyword.id))
      conn_2 = get(conn, Routes.keyword_path(conn, :show, in_progress_keyword.id))
      conn_3 = get(conn, Routes.keyword_path(conn, :show, failed_keyword.id))
      conn_4 = get(conn, Routes.keyword_path(conn, :show, created_keyword.id))

      assert html_response(conn_1, 200) =~ "Example keyword"
      assert html_response(conn_1, 200) =~ "class=\"keyword-details\""
      assert html_response(conn_2, 404) =~ "Not Found"
      assert html_response(conn_3, 404) =~ "Not Found"
      assert html_response(conn_4, 404) =~ "Not Found"
    end
  end

  describe "given no keyword in the database" do
    test "GET /keywords", %{conn: conn} do
      conn = get(conn, Routes.keyword_path(conn, :index))

      assert html_response(conn, 200) =~ gettext("empty_data")
    end

    test "GET /keywords/:id", %{conn: conn} do
      conn = get(conn, Routes.keyword_path(conn, :show, 22))

      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  test "GET /keywords/new", %{conn: conn} do
    conn = get(conn, Routes.keyword_path(conn, :new))

    assert html_response(conn, 200) =~ gettext("upload")
  end

  describe "given valid attribute" do
    test "POST /keywords", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixture/template.csv", filename: "template.csv"}

      conn = post(conn, Routes.keyword_path(conn, :create), %{keyword: %{file: upload}})

      assert get_flash(conn, :info) === gettext("upload_success")
      assert redirected_to(conn) === Routes.keyword_path(conn, :index)
    end
  end

  describe "given invalid attribute" do
    test "POST /keywords", %{conn: conn} do
      conn = post(conn, Routes.keyword_path(conn, :create), %{keyword: %{file: nil}})

      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end
end