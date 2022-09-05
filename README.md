# Filtering Form example

The starting point for this example is the app used in the **Search** lecture from the **Rails** module.

The goal is to have a filtering form for the `Movies#index` that:

* Uses [Ransack](https://github.com/activerecord-hackery/ransack) for searching.
* Uses [Hotwire's Turbo Frames](https://turbo.hotwired.dev/handbook/frames) to speed up the navigation.

## Add search form to `Movies#index`

1. Add `ransack` to the `Gemfile` & `bundle install`
2. Use it in the controller
    ```ruby
    # app/controllers/movies_controller.rb
      def index
        @q = Movie.includes(:director).ransack(params[:q])
        @movies = @q.result(distinct: true)
      end
    ```
3. Add the form to the view
    ```erb
    <%# app/views/movies/index.html.erb %>
      <%= search_form_for @q do |f| %>
        <div class="form-row">
          <div class="form-group">
            <%= f.label :title %>
            <%= f.search_field :title_cont,
                               class: "form-control",
                               autocomplete: "off" %>
          </div>
        </div>
        <div class="form-group row">
          <%= f.label :year %>
          <div class="col">
            <%= f.search_field :year_gteq,
                               class: "form-control",
                               autocomplete: "off" %>
          </div>
          <div class="col">
            <%= f.search_field :year_lteq,
                               class: "form-control",
                               autocomplete: "off" %>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <%= f.label "Director's name" %>
            <%= f.search_field :director_first_name_or_director_last_name_cont,
                               class: "form-control",
                               autocomplete: "off" %>
          </div>
        </div>
        <%= f.submit %>
      <% end %>
    ```
