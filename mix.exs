defmodule Ambassador.MixProject do
  use Mix.Project

  def project do
    [
      app: :ambassador,
      version: "1.0.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      source_url: "https://github.com/strangemachines/ambassador",
      homepage_url: "https://hexdocs.pm/ambassador",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  defp mod do
    if Mix.env() == :prod do
      {Ambassador, []}
    else
      []
    end
  end

  def application do
    [
      mod: mod(),
      extra_applications: [:logger]
    ]
  end

  defp description do
    "A microservice to handle transactional and form-based emails with different by providers."
  end

  defp package do
    [
      name: :ambassador,
      files: ~w(mix.exs lib .formatter.exs README.md LICENSE),
      maintainers: ["Jacopo Cascioli"],
      licenses: ["GPL-3.0-or-later"],
      links: %{"GitHub" => "https://github.com/strangemachines/ambassador"}
    ]
  end

  defp deps do
    [
      {:confex, "~> 3.4"},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.9", only: [:dev, :test], runtime: false},
      {:dummy, "~> 1.1", only: :test},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:jason, "~> 1.1"},
      {:plug, "~> 1.0"},
      {:plug_cowboy, "~> 1.0"},
      {:tesla, "~> 1.3"},
      {:token_auth, "~> 1.1"}
    ]
  end
end
