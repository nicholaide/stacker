defmodule Stacker do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    {:ok, _pid} = Stacker.Supervisor.start_link(["cat", "muse", 9])
  end
end
