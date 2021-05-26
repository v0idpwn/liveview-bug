defmodule LiveViewBugWeb.PageComponent do
  use LiveViewBugWeb, :live_component

  alias LiveViewBugWeb.ModalComponent

  @impl true
  def render(assigns) do
    ~L"""
    <%= if @modal_content do %>
      <%= live_component @socket, ModalComponent, 
        id: :my_modal,
        title: "My modal",
        vsn: @modal_content[:vsn],
        query: @modal_content[:query],
        return_to: (fn -> close_modal(__MODULE__, @id) end)
      %>
    <% end %>
    <section class="phx-hero">
      <p>Package search</p>
      <form phx-change="suggest" phx-submit="search" phx-target="<%= @myself %>">
        <input type="text" name="q" value="<%= @query %>" placeholder="Live dependency search" list="results" autocomplete="off"/>
        <datalist id="results">
          <%= for {app, _vsn} <- @results do %>
            <option value="<%= app %>"><%= app %></option>
          <% end %>
        </datalist>
        <button type="submit" phx-disable-with="Searching...">Spawn modal</button>
      </form>
    </section>
    """
  end

  @impl true
  def update(_params, socket) do
    IO.inspect(socket, label: :before_update)

    {:ok, assign(socket, query: "", results: %{}, modal_content: nil, id: :page_component)}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, assign(socket, modal_content: %{query: query, vsn: vsn})}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not LiveViewBugWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end

  def close_modal(module, id) do
    send_update(module, id: id, close_modal: true)
  end
end
