defmodule Apps.TrelloClone.Web.Live.Todo.Components.List do
  use Phoenix.LiveComponent

  alias Noozo.Repo
  alias Apps.TrelloClone.Contexts.Todo

  import Ecto.Query, warn: false

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="list" phx-hook="Draggable" draggable="true" phx-value-draggable_id="<%= @list.id %>" phx-value-draggable_type="list" phx-value-list_id="<%= @list.id %>">
      <div phx-hook="DropContainer">
        <div class="menu">
          <%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.ListMenu, id: "list_menu_#{@list.id}", list: @list %>
        </div>
        <div class="title">
          <%= if @editing do %>
            <form phx-target="<%= @myself %>" phx-submit="update_title">
              <input type="text" name="title" phx-hook="Focus" data-component="<%= @id %>" value="<%= @list.title %>"></input>
            </form>
          <% else %>
            <span class="badge badge-secondary" phx-click="toggle_list" phx-value-list_id="<%= @list.id %>" phx-value-board_id="<%= @list.board_id %>">
              <%= if @list.open do %>-<% else %>+<% end %>
            </span>
            &nbsp;
            <span phx-click="start_editing" phx-target="<%= @myself %>"><%= @list.title %></span>
            &nbsp;
            <span class="badge badge-info"><%= length(@list.items) %></span>
          <% end %>
        </div>
        <div class="items">
          <%= if @list.open do %>
            <%= for item <- @list.items |> Enum.sort_by(&(&1.inserted_at)) do %>
              <%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.Item, id: item.id %>
            <% end %>
            <%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.ItemCreator, id: "item_creator_#{@list.id}", list: @list %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  # Converts list_id in assigns into list, by smartly identifying all
  # components in the same page and running a single query to get all lists
  # instead of N+1'ing
  @impl true
  def preload(list_of_assigns) do
    list_of_ids = Enum.map(list_of_assigns, &(&1.id))

    lists =
      from(
        list in Todo.List,
        where: list.id in ^list_of_ids,
        order_by: [desc: :order],
        select: {list.id, list},
        left_join: item in assoc(list, :items),
        preload: [items: item]
      )
      |> Repo.all()
      |> Map.new()

    Enum.map(list_of_assigns, fn assigns ->
      Map.put(assigns, :list, lists[assigns.id])
    end)
  end

  @impl true
  def update(%{id: id, list: list} = _assigns, socket) do
    {:ok, assign(socket, id: id, list: list, editing: false)}
  end

  @impl true
  def handle_event("start_editing", _event, socket) do
    {:noreply, assign(socket, list: socket.assigns.list, editing: true)}
  end

  @impl true
  def handle_event("cancel", _event, socket) do
    {:noreply, assign(socket, list: socket.assigns.list, editing: false)}
  end

  @impl true
  def handle_event("update_title", %{"title" => new_title} = _event, socket) do
    {:ok, list} = Todo.update_list(socket.assigns.list, %{title: new_title})
    {:noreply, assign(socket, list: list, editing: false)}
  end
end
