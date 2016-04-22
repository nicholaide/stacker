defmodule Stacker.Server do
  use GenServer # this handles all the callbacks
    
  def handle_call(:pop, _from, [head | tail]) do
    { :reply, head, tail }
  end
  
  def handle_call(:pop, _from, []) do
    { :reply, nil, [] }
  end
  
  def handle_cast({:push, new_number}, [head | tail]) do
    { :noreply, [new_number] ++ [head | tail] }
  end
    
end