defmodule Infuse.Mixfile do
  use Mix.Project

  def project do
    [
      app: :infuse,
      version: "0.3.5",
      elixir: "~> 1.4",
      description: description(),
      package: package(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      deps: deps(),
      source_url: "https://github.com/LawfulGood/infuse",
      homepage_url: "http://infuse.lawfulgood.co",
      docs: docs()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger],
     mod: {Infuse, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:simplates, "~> 0.5.0"},
     {:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.4.3"},
     {:file_system, "~> 0.1.3"},
     {:mime, "~> 1.1"},
     {:ex_doc, "~> 0.14", only: :dev},
     {:excoveralls, "~> 0.5", only: :test},
     {:csv, "~> 1.4.2", only: :test}]
  end

  defp description do
    """
    A simple web framework that serves from the filesystem using Simplates!
    """
  end

  defp docs do
    [
      logo: "logo.png",
      main: "overview",
      groups_for_extras: groups_for_extras(),
      extra_section: "GUIDES",
      extras: extras()
    ]
  end

  defp extras do
    [
      "guides/overview.md",
      "guides/simplates.md"
    ]
  end

  defp groups_for_extras do
    [
    ]
  end

  defp package do
    [# These are the default files included in the package
    name: :infuse,
    files: ["src", "lib", "mix.exs", "README.md", "LICENSE.md"],
    maintainers: ["Luke Strickland"],
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/LawfulGood/infuse",
      "Docs" => "https://lawfulgood.co/infuse/"}]
  end
end
