defmodule LiveViewBugWeb.PageLive do
  use LiveViewBugWeb, :live_view

  alias LiveViewBugWeb.PageComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component @socket, PageComponent, id: :page_component %>
    """
  end
end
