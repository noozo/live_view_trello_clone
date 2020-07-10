defmodule Apps.TrelloClone.Web.Live.Todo.Components.ItemCreator do
  use Phoenix.LiveComponent

  alias Apps.TrelloClone.Contexts.Todo

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="new-item">
      <%= if @creating do %>
        <div class="row">
          <div class="col">
            <form phx-submit="create_item" phx-target="<%= @myself %>">
              <input type="hidden" name="list_id" value="<%= @list.id %>" />
              <div class='control-group'>
                <input type="text" name="new_item" placeholder="Enter item title..." size="5" phx-hook="Focus" data-component="<%= @id %>" />
              </div>
              <div class='control-group'>
                <button class="btn btn-success btn-sm"><i class="material-icons">check</i></button>
              </div>
            </form>
          </div>
          <div class="col-md-auto">
            <form phx-submit="cancel" phx-target="<%= @myself %>">
              <button class="btn btn-danger btn-sm cancel"><i class="material-icons">cancel</i></button>
            </form>
          </div>
        </div>
      <% else %>
        <form phx-submit="input_title" phx-target="<%= @myself %>">
          <button class="new-item"><i class="material-icons">add</i> Add another item</button>
        </form>
      <% end %>
      </div>
    """
  end

  @impl true
  def update(%{id: id, list: list} = _assigns, socket) do
    {:ok, assign(socket, id: id, list: list, creating: false)}
  end

  @impl true
  def handle_event("input_title", _event, socket) do
    {:noreply, assign(socket, list: socket.assigns.list, creating: true)}
  end

  @impl true
  def handle_event("cancel", _event, socket) do
    {:noreply, assign(socket, list: socket.assigns.list, creating: false)}
  end

  ###################### PubSub Events ######################

  @impl true
  def handle_event("create_item", %{"new_item" => title, "list_id" => list_id} = _event, socket) do
    {:ok, _new_item} = Todo.create_item(%{title: title, list_id: list_id})
    {:noreply, socket}
  end
end
