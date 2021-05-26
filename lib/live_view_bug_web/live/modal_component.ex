defmodule LiveViewBugWeb.ModalComponent do
  use LiveViewBugWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="phx-modal" id="<%= @id %>" phx-key="escape" phx-page-loading="" phx-target="<%= @myself %>" phx-window-keydown="close">
      <div class="phx-modal-content">
        <div class="card">
          <div class="card-header">
            <%= @title %>
            <div class="card-header-actions">
              <%= if is_function(@return_to) do %>
                <button class="button" phx-click="close" phx-target="<%= @myself %>">close</button>
              <% else %>
                <%= live_patch to: @return_to, class: "card-header-action btn-minimize" do %>
                  <i class="icon-close"></i>
                <% end %>
              <% end %>
            </div>
          </div>
          <div class="card-body">
          <div>
            <p> Vsn: <%= @vsn %></p>
            <p> Query: <%= @query %></p>
          </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    return_to = socket.assigns.return_to

    if is_function(return_to) do
      return_to.()

      {:noreply, socket}
    else
      {:noreply, push_patch(socket, to: socket.assigns.return_to)}
    end
  end
end
