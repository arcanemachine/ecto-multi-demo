defmodule EctoMultiDemoWeb.DogView do
  use EctoMultiDemoWeb, :view
  alias EctoMultiDemoWeb.DogView

  def render("index.json", %{dogs: dogs}) do
    %{data: render_many(dogs, DogView, "dog.json")}
  end

  def render("show.json", %{dog: dog}) do
    %{data: render_one(dog, DogView, "dog.json")}
  end

  def render("dog.json", %{dog: dog}) do
    %{
      id: dog.id,
      name: dog.name
    }
  end
end
