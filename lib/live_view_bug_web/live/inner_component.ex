defmodule LiveViewBugWeb.InnerComponent do
  use LiveViewBugWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <p> Vsn: <%= @data[:vsn] %></p>
      <p> Query: <%= @data[:query] %></p>
    </div>
    """
  end
end
