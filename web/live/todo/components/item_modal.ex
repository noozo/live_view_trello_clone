defmodule Apps.TrelloClone.Web.Live.Todo.Components.ItemModal do
  @moduledoc """
  Show a modal for a single item
  """
  use Phoenix.LiveComponent

  alias Apps.TrelloClone.Contexts.Todo

  @impl true
  # def render(assigns) do
  #   ~L"""
  #   <div class="modal is-active" id="<%= @id %>" tabindex="-1" role="dialog" aria-labelledby="<%= @id %>" aria-hidden="true">
  #     <div class="modal-background" data-dismiss="modal" phx-click="item_clicked" phx-value-draggable_id=""></div>
  #     <div class="modal-card">
  #       <header class="modal-card-head">
  #         <h3 class="modal-card-title"><%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.ItemModal.Title, id: :item_title, item: @item %></h3>
  #         <button class="delete" data-dismiss="modal" phx-click="item_clicked" phx-value-draggable_id=""></button>
  #       </header>
  #       <section class="modal-card-body">
  #         <%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.ItemLabel, id: :label, item: @item %>
  #         <div class="item-content">
  #           <%= @item.content %>
  #         </div>
  #         <hr/>
  #         <small>
  #           <a href="#" class="alert-link text-danger" data-confirm="Are you sure?"
  #             phx-click="delete_item"
  #             phx-target="<%= @myself %>">Delete this item</a>.
  #         </small>
  #       </section>
  #       <footer class="modal-card-foot">
  #         <button type="button" class="modal-close is-large" data-dismiss="modal" phx-click="item_clicked" phx-value-draggable_id="">Close</button>
  #       </footer>
  #     </div>
  #   </div>
  #   """
  # end



  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="z-10 inset-0 overflow-y-auto"
            :class="{'fixed': modalOpen, 'hidden': !modalOpen}">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 transition-opacity"
            x-show="modalOpen"
            x-transition:enter="ease-out duration-300"
            x-transition:enter-start="opacity-0"
            x-transition:enter-end="opacity-100"
            x-transition:leave="ease-in duration-200"
            x-transition:leave-start="opacity-100"
            x-transition:leave-end="opacity-0"
             aria-hidden="true">
          <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
        </div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
              x-show="modalOpen"
              x-transition:enter="ease-out duration-300"
              x-transition:enter-start="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
              x-transition:enter-end="opacity-100 translate-y-0 sm:scale-100"
              x-transition:leave="ease-in duration-200"
              x-transition:leave-start="opacity-100 translate-y-0 sm:scale-100"
              x-transition:leave-end="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
            role="dialog" aria-modal="true" aria-labelledby="modal-headline">
          <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div class="sm:flex sm:items-start">
              <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                <!-- Heroicon name: exclamation -->
                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
              </div>
              <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-headline">
                  <%= live_component @socket, Apps.TrelloClone.Web.Live.Todo.Components.ItemModal.Title, id: :item_title, item: @item %>
                </h3>
                <button class="btn bg-red-200" data-dismiss="modal" phx-click="item_clicked" phx-value-draggable_id="">X</button>
                <div class="mt-2">
                  <p class="text-sm text-gray-500">

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

                  </p>
                </div>
              </div>
            </div>
          </div>
          <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
            <button type="button" class="btn" data-dismiss="modal" phx-click="item_clicked" phx-value-draggable_id="">Close</button>
          </div>
        </div>
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
