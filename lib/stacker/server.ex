defmodule Stacker.Server do
  use GenServer # this handles all the callbacks
  
  ####
  # External API
  
  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end
  
  def pop do
    GenServer.call __MODULE__, :pop    
  end
  
  def push(new_item) do
    GenServer.cast __MODULE__, {:push, new_item}
  end
  
  ####
  # GenServer implementation  
  
  def init(stash_pid) do
    [ head | tail ] = Stacker.Stash.get_value stash_pid
    { :ok, {[head|tail], stash_pid} }
  end
    
  def handle_call(:pop, _from, {[head | tail], stash_pid} ) do
    { :reply, head, {tail, stash_pid} }
  end
  
  def handle_call(:pop, _from, {[], stash_pid} ) do
    #{:stop, "bad weather", :reply,  {[], stash_pid}}
    raise "Empty stack to pop"    
  end
  
  def handle_cast({:push, new_item}, {list, stash_pid} ) do
    { :noreply, {[new_item | list], stash_pid} }
  end
  
  def terminate(_reason, {value, stash_pid} ) do
    IO.puts "The reason was not using {:stop}"  
    Stacker.Stash.save_value stash_pid, value
      
  end  
    
end