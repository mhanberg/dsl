# ![](temple.png)

[![Actions Status](https://github.com/mhanberg/temple/workflows/CI/badge.svg)](https://github.com/mhanberg/temple/actions)
[![Hex.pm](https://img.shields.io/hexpm/v/temple.svg)](https://hex.pm/packages/temple)
[![Slack](https://img.shields.io/badge/chat-Slack-blue)](https://elixir-lang.slack.com/messages/CMH6MA4UD)

> You are looking at the README for the master branch. The README for the latest stable release is located [here](https://github.com/mhanberg/temple/tree/v0.5.0).

Temple is a DSL for writing HTML using Elixir.

You're probably here because you want to use Temple to write Phoenix templates, which is why Temple includes a [Phoenix template engine](#phoenix-templates).

## Installation

Add `temple` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:temple, "~> 0.6.0-alpha.0"}]
end
```

## Usage

Using Temple is a as simple as using the DSL inside of an `temple/1` block. This returns an EEx string at compile time.

See the [documentation](https://hexdocs.pm/temple/Temple.Html.html) for more details.

```elixir
use Temple

temple do
  h2 do: "todos"

  ul class: "list" do
    for item <- @items do
      li class: "item" do
        div class: "checkbox" do
          div class: "bullet hidden"
        end

        div do: item
      end
    end
  end

  script do: """
  function toggleCheck({currentTarget}) {
    currentTarget.children[0].children[0].classList.toggle("hidden");
  }

  let items = document.querySelectorAll("li");

  Array.from(items).forEach(checkbox => checkbox.addEventListener("click", toggleCheck));
  """
end
```

### Phoenix templates

Add the templating engine to your Phoenix configuration.

```elixir
# config.exs
config :phoenix, :template_engines,
  exs: Temple.Engine
  # or for LiveView support
  exs: Temple.LiveViewEngine

# config/dev.exs
config :your_app, YourAppWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"lib/myapp_web/(live|views)/.*(ex|exs)$",
      ~r"lib/myapp_web/templates/.*(eex|exs)$"
    ]
  ]
```

```elixir
# app.html.exs

html lang: "en" do
  head do
    meta charset: "utf-8"
    meta http_equiv: "X-UA-Compatible", content: "IE=edge"
    meta name: "viewport", content: "width=device-width, initial-scale=1.0"
    title do: "YourApp · Phoenix Framework"

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
      p class: "alert alert-info", role: "alert", compact: true, do: get_flash(@conn, :info)
      p class: "alert alert-danger", role: "alert", compact: true, do: get_flash(@conn, :error)

      render @view_module, @view_template, assigns
    end

    script type: "text/javascript", src: Routes.static_path(@conn, "/js/app.js")
  end
end
```

### Tasks

#### temple.gen.layout

Generates the app layout.

#### temple.gen.html

Generates the templates for a resource.

### Formatter

To include Temple's formatter configuration, add `:temple` to your `.formatter.exs`.

```elixir
[
  import_deps: [:temple],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
]
```
