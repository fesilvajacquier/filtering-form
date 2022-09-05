# Filtering Form example

The starting point for this example is the app used in the **Search** lecture from the **Rails** module.

The goal is to have a filtering form for the `Movies#index` that:

* Uses [Ransack](https://github.com/activerecord-hackery/ransack) for searching.
* Uses [Hotwire's Turbo Frames](https://turbo.hotwired.dev/handbook/frames) to speed up the navigation.
