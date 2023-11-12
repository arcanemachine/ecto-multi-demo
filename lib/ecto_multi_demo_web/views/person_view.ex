defmodule EctoMultiDemoWeb.PersonView do
  use EctoMultiDemoWeb, :view
  alias EctoMultiDemoWeb.PersonView

  def render("index.json", %{persons: persons}) do
    %{data: render_many(persons, PersonView, "person.json")}
  end

  def render("show.json", %{person: person}) do
    %{data: render_one(person, PersonView, "person.json")}
  end

  def render("person.json", %{person: person}) do
    %{
      id: person.id,
      name: person.name
    }
  end
end
