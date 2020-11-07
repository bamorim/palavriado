defmodule Palavriado.MixProject do
  use Mix.Project

  def project do
    [
      app: :palavriado,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:gen_stage, "~> 1.0"},
      {:flow, "~> 1.0"}
    ]
  end
end
