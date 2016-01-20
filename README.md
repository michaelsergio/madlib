# Madlib
A program that spews out the most common words in English.
It's your job to translate them into #{LANGUAGE_STUDYING}.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add madlib to your list of dependencies in `mix.exs`:

        def deps do
          [{:madlib, "~> 0.0.1"}]
        end

  2. Ensure madlib is started before your application:

        def application do
          [applications: [:madlib]]
        end

## TODO

* Add a web gui.
* Add more sentence types.
* Clean up the vocab list.
