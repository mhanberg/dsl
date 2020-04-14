defmodule Temple.Engine do
  @behaviour Phoenix.Template.Engine

  @moduledoc """
  Temple provides a templating engine for use in Phoenix web applications.

  You can configure your application to use Temple templates by adding the following configuration.

  ```elixir
  # config.exs
  config :phoenix, :template_engines, exs: Temple.Engine

  # config/dev.exs
  config :your_app, YourAppWeb.Endpoint,
    live_reload: [
      patterns: [
        ~r"lib/your_app_web/templates/.*(exs)$"
      ]
    ]

  # your_app_web.ex
  def view do
    quote location: :keep do
      # ...
      use Temple # Replaces the call to import Phoenix.HTML
    end
  end
  ```

  ## Usage

  Temple templates use the `.exs` extension, because they are written with pure Elixir!

  `assigns` (@conn, etc) are handled the same as normal `Phoenix.HTML.Engine` templates.

  Note: The `Temple.temple/1` macro is _not_ needed for Temple templates due to the engine taking care of that for you.

  ```
  # app.html.exs
  html lang: "en" do
    head do
      meta charset: "utf-8"
      meta http_equiv: "X-UA-Compatible", content: "IE=edge"
      meta name: "viewport", content: "width=device-width, initial-scale=1.0"
      title "YourApp · Phoenix Framework"

      link rel: "stylesheet", href: Routes.static_path(@conn, "/css/app.css")
    end

    body do
      header do
        section class: "container" do
          nav role: "navigation" do
            ul do
              li do: a("Get Started", href: "https://hexdocs.pm/phoenix/overview.html")
            end
          end

          a href: "http://phoenixframework.org/", class: "phx-logo" do
            img src: Routes.static_path(@conn, "/images/phoenix.png"),
                alt: "Phoenix Framework Logo"
          end
        end
      end

      main role: "main", class: "container" do
        p get_flash(@conn, :info), class: "alert alert-info", role: "alert"
        p get_flash(@conn, :error), class: "alert alert-danger", role: "alert"

        partial render(@view_module, @view_template, assigns)
      end

      script type: "text/javascript", src: Routes.static_path(@conn, "/js/app.js")
    end
  end
  ```
  """

  def compile(path, _name) do
    require Temple

    template = path |> File.read!() |> Code.string_to_quoted!(file: path)

    ast =
      quote do
        unquote(template)
      end

    Temple.temple(ast)
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, file: path, line: 1)
  end
end
