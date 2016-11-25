defmodule Infuse.Mixfile do
  use Mix.Project

  def project do
    [app: :infuse,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy, :plug],
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
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"},
     {:dir_walker, "~> 0.0.6"},
     {:ex_doc, "~> 0.14", only: :dev}]
  end

  defp description do
    """
    A simple web framework that serves from the filesystem using Simplates!
    """
  end
  
  defp package do
    [# These are the default files included in the package
    name: :infuse,
    files: ["lib", "www", "mix.exs", "README.md", "LICENSE.md"],
    maintainers: ["Luke Strickland"],
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/clone1018/infuse",
      "Docs" => "http://clone1018.github.io/infuse/"}]
  end
end