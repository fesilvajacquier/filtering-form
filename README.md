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

## Use Turbo Frames

1. Move the movies' list to a partial so that it can be used from the `Movies#index` action and the soon to be added `Movies#filter` action.

    ```erb
    <%# app/views/movies/index.html.erb %>
        <div class="col-sm-8">
          <%= render "movies_list" %>
        </div>
    ```

2. Add `filter_movies_path` route

    ```ruby
    # config/routes.rb
      resources :movies, only: :index do
        collection do
          get :filter
        end
      end
    ```

3. Add the `MoviesController#filter` action that renders the partial created previously.

    ```ruby
      def filter
        @q = Movie.includes(:director).ransack(params[:q])
        @movies = @q.result(distinct: true)
        render(partial: "movies_list")
      end
    ```

4. At `app/views/movies/index.html.erb` change the form's `url`, set the `data-turbo-frame` & set the `turbo_frame_tag` at the `movies_list` partial.

    ```erb
    <%# app/views/movies/index.html.erb %>
      <div class="row justify-content-center">
        <div class="col-sm-4">
          <%= search_form_for @q,
                              url: filter_movies_path,
                              data: {
                                turbo_frame: "search"
                              } do |f| %>
            <%# ... %>
          <% end %>
        </div>
        <div class="col-sm-8">
          <%= render "movies_list" %>
        </div>
      </div>
    ```

    ```erb
    <%# app/views/movies/_movies_list.html.erb %>
    <%= turbo_frame_tag "search", target: "_top" do %>
      <div id="movies">
        <% @movies.each do |movie| %>
          <h4><%= movie.title %></h4>
          <span><%= movie.year %></span>
          <span><%= movie.director.full_name %></span>
          <p><%= movie.synopsis %></p>
        <% end %>
      </div>
    <% end %>
    ```

Note that the url is not modified in each request. This is a major drawback as it breaks the principle[^1] that the url identifies exactly what you retrieve from the server.
By adding `data: { turbo_action: "advance" }` the browser would behave as if a new request was made (url change & add record to the navigation history. See [docs](https://turbo.hotwired.dev/handbook/frames#promoting-a-frame-navigation-to-a-page-visit)).
But as we are using a second route and action to retrieve the frame we want to update using this API would bring a similar problem as the url would represent just the partial (ie: `/movies/filter?q[title_cont]=bat&q[year_gteq]=&q[year_lteq]=&q[director_first_name_or_director_last_name_cont]=&commit=Search`). Which again produces a difference between the url and what we are actually getting. If we were to refresh the page or share the url with someone else we would get just the partial and not the whole view.

Considering this, later on we will explore the alternative of not using **Turbo Frames**.

[^1]: This is [URL design guidelines](https://www.forgov.qld.gov.au/information-and-communication-technology/communication-and-publishing/website-and-digital-publishing/website-standards-guidelines-and-templates/url-design-guidelines/principles-all-web-pages) express quite well the message I am trying to convey.

    ```
    Principle 6: Addressable

    * URLs should be easily stored either as a bookmark, included in an email, added to another site as a hyperlink or indexed by a search engine.
    * Stored URLs should allow users to return to view the same content at a later date.
    * Every useful page (every resource) should have a unique URL which must display in the address bar. This means the POST method should not be used to display results; instead users should be redirected after a POST submission to ' unique URL that contains the results.
    ```
