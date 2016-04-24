defmodule Stacker do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Stacker.Server, ["little", "stuart", 90])      
    ]

    opts = [strategy: :one_for_one, name: Stacker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
