defmodule Apps.TrelloClone.Web.Live.Todo.Components.ItemModal do
  @moduledoc """
  Show a modal for a single item
  """
  use Phoenix.LiveComponent

  alias Apps.TrelloClone.Contexts.Todo

  @impl true
  def render(assigns) do
    ~L"""
    <div class="modal fade show" id="<%= @id %>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="display:block">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.ItemModal.Title, id: :item_title, item: @item %>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close" phx-click="item_clicked" phx-value-draggable_id="">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.ItemLabel, id: :label, item: @item %>
            <div class="item-content">
              <h6><small>Content</small></h6>
              <%= @item.content %>
            </div>
            <hr/>
            <small>
              <a href="#" class="alert-link text-danger" data-confirm="Are you sure?"
                phx-click="delete_item"
                phx-target="<%= @myself %>">Delete this item</a>.
            </small>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal" phx-click="item_clicked" phx-value-draggable_id="">Close</button>
          </div>
        </div>
      </div>
    </div>
    <div class="modal-backdrop fade show"></div>
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
