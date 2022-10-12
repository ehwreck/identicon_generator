defmodule IdenticonGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :identicon_generator,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: "A CLI application that generates GitHub-like Identicons.",
      package: package(),
      deps: deps(),
      source_url: "https://github.com/ehwreck/identicon_generator"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:crypto, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # add :egd as a dependency by removing the # and running mix deps.get
      # {:egd, github: "erlang/egd"},
      {:ex_doc, "~> 0.12"}
    ]
  end

  defp package do
    [
      licenses: ["GPL-3.0-only"],
      links: %{"GitHub" => "https://github.com/ehwreck/identicon_generator"}
    ]
  end
end
