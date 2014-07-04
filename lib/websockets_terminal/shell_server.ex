defmodule WebsocketsTerminal.ShellServer do
  alias Porcelain.Process, as: Proc

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def eval(server, command) do
    GenServer.cast(server, {:eval, command})
  end

  def init(:ok) do
    proc = Porcelain.spawn("bash", ["--noediting", "-i"], in: :receive, out: {:send, self})
    {:ok, proc}
  end

  def handle_cast({:eval, command}, proc) do
    Proc.send_input(proc, "#{command}\n")
    {:noreply, proc}
  end

  def handle_info({_, :data, data}, proc) do
    IO.inspect(data)
    Phoenix.Channel.broadcast "shell", "shell", "stdout", %{data: Base.encode64(data)}
    {:noreply, proc}
  end

  def handle_info(noclue, proc) do
    IO.puts "unhandled info"
    IO.inspect noclue
    {:noreply, proc}
  end
end
