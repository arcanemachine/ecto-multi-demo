defmodule EctoMultiDemoWeb.DogController do
  use EctoMultiDemoWeb, :controller

  alias EctoMultiDemo.Dogs
  alias EctoMultiDemo.Dogs.Dog

  action_fallback EctoMultiDemoWeb.FallbackController

  def index(conn, _params) do
    dogs = Dogs.list_dogs()
    render(conn, "index.json", dogs: dogs)
  end

  def create(conn, %{"dog" => dog_params}) do
    with {:ok, %Dog{} = dog} <- Dogs.create_dog(dog_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.dog_path(conn, :show, dog))
      |> render("show.json", dog: dog)
    end
  end

  def show(conn, %{"id" => id}) do
    dog = Dogs.get_dog!(id)
    render(conn, "show.json", dog: dog)
  end

  def update(conn, %{"id" => id, "dog" => dog_params}) do
    dog = Dogs.get_dog!(id)

    with {:ok, %Dog{} = dog} <- Dogs.update_dog(dog, dog_params) do
      render(conn, "show.json", dog: dog)
    end
  end

  def delete(conn, %{"id" => id}) do
    dog = Dogs.get_dog!(id)

    with {:ok, %Dog{}} <- Dogs.delete_dog(dog) do
      send_resp(conn, :no_content, "")
    end
  end
end
