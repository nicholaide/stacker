defmodule Stacker.Supervisor do
  use Supervisor
  def start_link([ head | tail] ) do
    result = {:ok, sup } = Supervisor.start_link(__MODULE__, [[head | tail] ]) # this calls the init callback
    start_workers(sup, [head | tail])
    result
  end
  def start_workers(sup, [head | tail]) do
    # Start the stash worker
    {:ok, stash} = 
      Supervisor.start_child(sup, worker(Stacker.Stash,[ [head | tail]] ) )
    # and then the subsupervisor for the actual Stacker server
    Supervisor.start_child(sup, supervisor(Stacker.Subsupervisor, [stash]))
  end
  def init(_) do
    supervise [], strategy: :one_for_one
  end
end # end module
# this is the overall supervisor

