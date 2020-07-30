defmodule ExMarketerWeb.Accounts.LoginTest do
  use ExMarketerWeb.FeatureCase, async: true

  feature "Login", %{session: session} do
    user = insert(:user)

    session
    |> login(user.email, valid_user_password())
    |> assert_has(Query.css(".app-layout"))
    |> assert_has(Query.text(user.email))
  end

  @sessions 3
  feature "get notify when the other people login", %{sessions: [session_1, session_2, session_3]} do
    user_1 = insert(:user)
    user_2 = insert(:user)
    user_3 = insert(:user)

    session_1
    |> login(user_1.email, valid_user_password())

    session_2
    |> login(user_2.email, valid_user_password())

    session_3
    |> login(user_3.email, valid_user_password())

    # TODO: Test the notificate message

    session_1
    |> assert_has(Query.css(".notification .alert"))

    session_2
    |> assert_has(Query.css(".notification .alert"))

    session_3
    |> refute_has(Query.css(".notification .alert"))
  end
end
