defmodule WebsocketsTerminal.Router do
  use Phoenix.Router
  use Phoenix.Router.Socket, mount: "/ws"

  plug Plug.Static, at: "/static", from: :websockets_terminal
  get "/", WebsocketsTerminal.Controllers.Pages, :index, as: :page

  channel "shell", WebsocketsTerminal.Channels.Shell
end
