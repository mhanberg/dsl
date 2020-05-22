defmodule TempleDemoWeb.TempleFeatureTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature
  alias TempleDemoWeb.Router.Helpers, as: Routes
  alias TempleDemoWeb.Endpoint, as: E

  feature "renders the homepage", %{session: session} do
    session
    |> visit("/")
    |> assert_text("Welcome to Phoenix!")
  end

  describe "/posts/new" do
    feature "can create a new post", %{session: session} do
      session
      |> visit(Routes.post_path(E, :index))
      |> click(Query.link("New Post"))
      |> fill_in(Query.text_field("Title"), with: "Temple is awesome!")
      |> fill_in(Query.text_field("Body"), with: "In this post I will show you how to use Temple")
      |> find(Query.select("post_published_at_year"), fn s ->
        s |> click(Query.option("2020"))
      end)
      |> find(Query.select("post_published_at_month"), fn s ->
        s |> click(Query.option("May"))
      end)
      |> find(Query.select("post_published_at_day"), fn s ->
        s |> click(Query.option("21"))
      end)
      |> fill_in(Query.text_field("Author"), with: "Mitchelob Ultra")
      |> click(Query.button("Save"))
      |> assert_text("Post created successfully.")
    end
  end
end
