# defmodule Stackerer.Server do
#   use GenServer # this handles all the callbacks
#   
#   ####
#   # External API
#   
#   def start_link(stash_pid) do
#     GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
#   end
#   
#   def pop do
#     GenServer.call __MODULE__, :pop    
#   end
#   
#   def push(new_item) do
#     GenServer.cast __MODULE__, {:push, new_item}
#   end
#   
#   ####
#   # GenServer implementation  
#   
#   def init(stash_pid) do
#     [ head | tail ] = Stackerer.Stash.get_value stash_pid
#     { :ok, {[head|tail], stash_pid} }
#   end
#     
#   def handle_call(:pop, _from, {[head | tail], stash_pid} ) do
#     { :reply, head, {tail, stash_pid} }
#   end
#   
#   def handle_call(:pop, _from, {[], stash_pid} ) do
#     #{:stop, "bad weather", :reply,  {[], stash_pid}}
#     raise "Empty Stacker to pop"    
#   end
#   
#   def handle_cast({:push, new_item}, {list, stash_pid} ) do
#     { :noreply, {[new_item | list], stash_pid} }
#   end
#   
#   def terminate(_reason, {value, stash_pid} ) do
#     IO.puts "The reason was not using {:stop}"  
#     Stackerer.Stash.save_value stash_pid, value
#       
#   end  
#     
# end


defmodule Stacker.Server do

  use GenServer

  #####
  # Extermal API

  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def push(element) do
    GenServer.cast __MODULE__, {:push, element}
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  #####
  # GenServer implementation

  def init(stash_pid) do
    list = Stacker.Stash.get_value stash_pid
    { :ok, {list, stash_pid} }
  end

  def handle_call(:pop, _from, {[], stash_pid}) do
    raise "Popping empty"
    { :reply, nil, {[], stash_pid} }    
  end

  def handle_call(:pop, _from, {list, stash_pid}) do
    [ head | tail ] = list
    { :reply, head, {tail, stash_pid} }
  end

  def handle_cast({:push, element}, {list, stash_pid}) do
    #bug(element)
    new_list = [ element | list ]
    { :noreply, {new_list, stash_pid} }
  end



  def terminate(_reason, {list, stash_pid}) do
    Stacker.Stash.save_value stash_pid, list
  end

  # If you push "fail", it causes the worker to terminate.
  # Now you can observe how state is stashed away on
  # causing the worker to "unexpectedly" terminate
  defp bug("fail") do raise "Invalid push value 'fail'" end
  defp bug(_) do end

end