defmodule Banana.Mixfile do
  use Mix.Project

  def project do
    [app: :banana,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {Banana, []},
      applications: [:logger]
    ]
  end

  defp deps do
    [
      {:poolboy, ">= 1.5.1"}
    ]
  end
end
