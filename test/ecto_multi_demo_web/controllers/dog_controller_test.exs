defmodule EctoMultiDemoWeb.DogControllerTest do
  use EctoMultiDemoWeb.ConnCase

  import EctoMultiDemo.DogsFixtures

  alias EctoMultiDemo.Dogs.Dog

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all dogs", %{conn: conn} do
      conn = get(conn, Routes.dog_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create dog" do
    test "renders dog when data is valid", %{conn: conn} do
      conn = post(conn, Routes.dog_path(conn, :create), dog: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.dog_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.dog_path(conn, :create), dog: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update dog" do
    setup [:create_dog]

    test "renders dog when data is valid", %{conn: conn, dog: %Dog{id: id} = dog} do
      conn = put(conn, Routes.dog_path(conn, :update, dog), dog: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.dog_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, dog: dog} do
      conn = put(conn, Routes.dog_path(conn, :update, dog), dog: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete dog" do
    setup [:create_dog]

    test "deletes chosen dog", %{conn: conn, dog: dog} do
      conn = delete(conn, Routes.dog_path(conn, :delete, dog))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.dog_path(conn, :show, dog))
      end
    end
  end

  defp create_dog(_) do
    dog = dog_fixture()
    %{dog: dog}
  end
end
