defmodule Stacker.Server do
  use GenServer # this handles all the callbacks
  
  ####
  # External API
  
  def start_link( [head | tail] ) do
    GenServer.start_link(__MODULE__, [head | tail], name: __MODULE__)
  end
  
  def pop do
    GenServer.call __MODULE__, :pop    
  end
  
  def push(new_item) do
    GenServer.cast __MODULE__, {:push, new_item}
  end
  
  ####
  # GenServer implementation  
    
  def handle_call(:pop, _from, [head | tail]) do
    { :reply, head, tail }
  end
  
  def handle_call(:pop, _from, []) do
    {:stop, "bad weather", :reply, 0}
    #{ :reply, nil, [] }
  end
  
  def handle_cast({:push, new_item}, [head | tail]) do
    { :noreply, [new_item] ++ [head | tail] }
  end
  
  def terminate(reason, :reply, state) do
    IO.puts "The reason was #{reason} "
    IO.puts "and the state of the nation is #{state}"
    IO.puts "there could be a reply: #{:reply}"
  end
  
  def terminate(reason, state) do
    IO.puts "The reason was #{reason} "
    IO.puts "and the state of the nation is #{state}"
  end  
    
end