defmodule Apps.TrelloClone.Web.Live.Todo.Components.ListCreator do
  use Phoenix.LiveComponent

  alias Apps.TrelloClone.Contexts.Todo

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="new-list list">
      <%= if @creating do %>
        <div class="row">
          <div class="col">
            <form phx-submit="create_list" phx-target="<%= @myself %>">
              <input type="hidden" name="board_id" value="<%= @board.id %>" />
              <div class='control-group'>
                <input type="text" name="new_list" placeholder="Enter list title..." size="5" phx-hook="Focus" data-component="<%= @id %>" />
              </div>
              <div class='control-group'>
                <button class="btn btn-success btn-sm"><i class="material-icons">check</i></button>
              </div>
            </form>
          </div>
          <div class="col-md-auto">
            <form phx-submit="cancel" phx-target="<%= @myself %>">
              <button class="btn-danger btn-sm cancel"><i class="material-icons">cancel</i></button>
            </form>
          </div>
        </div>
      <% else %>
        <form phx-submit="input_title" phx-target="<%= @myself %>">
          <button class="new-list"><i class="material-icons">add</i> Add another list</button>
        </form>
      <% end %>
      </div>
    """
  end

  @impl true
  def update(%{id: id, board: board} = _assigns, socket) do
    {:ok, assign(socket, id: id, board: board, creating: false)}
  end

  @impl true
  def handle_event("input_title", _event, socket) do
    {:noreply, assign(socket, board: socket.assigns.board, creating: true)}
  end

  @impl true
  def handle_event("cancel", _event, socket) do
    {:noreply, assign(socket, board: socket.assigns.board, creating: false)}
  end

  ###################### PubSub Events ######################

  @impl true
  def handle_event("create_list", %{"new_list" => title} = _event, socket) do
    {:ok, _new_list} = Todo.create_list(%{title: title, board_id: socket.assigns.board.id})
    {:noreply, socket}
  end
end
