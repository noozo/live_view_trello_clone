# live_view_trello_clone
A Phoenix LiveView Trello "clone". It contains a small subset of Trello, mostly for training and learning purposes. MIT Licence.

Example routing:

```
    scope "/todo", Todo do
      live "/boards/new", Board.CreateView
      live "/boards/:id/edit", Board.EditView, id: :id
      live "/boards/:id", Board.ShowView, id: :id
      live "/", Board.IndexView
    end
```
