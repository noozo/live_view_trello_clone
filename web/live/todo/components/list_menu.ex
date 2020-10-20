defmodule Apps.TrelloClone.Web.Live.Todo.Components.ListMenu do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="dropdown">
      <button class="tag dropdown-toggle" type="button"
              id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true"
              aria-expanded="false">
        ...
      </button>
      <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
        <a href="#" class="dropdown-item" data-confirm="Are you sure?"
                  phx-click="delete_list" phx-value-list_id="<%= @list.id %>"
                  phx-value-board_id="<%= @list.board_id %>">
          Delete
        </a>
      </div>
    </div>
    """
  end

  def update(%{id: id, list: list} = _assigns, socket) do
    {:ok, assign(socket, id: id, list: list)}
  end
end
