defmodule Apps.TrelloClone.Web.Live.Todo.Components.ItemModal do
  @moduledoc """
  Show a modal for a single item
  """
  use Phoenix.LiveComponent

  alias Apps.TrelloClone.Contexts.Todo

  @impl true
  def render(assigns) do
    ~L"""
    <div class="modal is-active" id="<%= @id %>" tabindex="-1" role="dialog" aria-labelledby="<%= @id %>" aria-hidden="true">
      <div class="modal-background" data-dismiss="modal" phx-click="item_clicked" phx-value-draggable_id=""></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <h3 class="modal-card-title"><%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.ItemModal.Title, id: :item_title, item: @item %></h3>
          <button class="delete" data-dismiss="modal" phx-click="item_clicked" phx-value-draggable_id=""></button>
        </header>
        <section class="modal-card-body">
          <%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.ItemLabel, id: :label, item: @item %>
          <div class="item-content">
            <%= @item.content %>
          </div>
          <hr/>
          <small>
            <a href="#" class="alert-link text-danger" data-confirm="Are you sure?"
              phx-click="delete_item"
              phx-target="<%= @myself %>">Delete this item</a>.
          </small>
        </section>
        <footer class="modal-card-foot">
          <button type="button" class="modal-close is-large" data-dismiss="modal" phx-click="item_clicked" phx-value-draggable_id="">Close</button>
        </footer>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{id: id, item: item} = _assigns, socket) do
    {:ok, assign(socket, id: id, item: item)}
  end

  @impl true
  def handle_event("delete_item", _event, socket) do
    {:ok, _item} = Todo.delete_item(socket.assigns.item)
    {:noreply, socket}
  end
end
