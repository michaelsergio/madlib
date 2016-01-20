# madlib.ex
# To use: iex madlib.ex
#         c("madlib.ex")
#         ModuleName.hello
defmodule Madlib do

  defmodule Category do
    defstruct name: "", items: []
  end

  def dump_all_categories_and_items(category_list) do
    Enum.each category_list, fn cat ->
      IO.puts(String.upcase(cat.name))
      IO.puts(Enum.join(cat.items, ", "))
      IO.puts("")
    end
  end

  def dump_categories(category_list) do
    IO.puts(Enum.join(Enum.map(category_list, fn(c) -> c.name end), ", "))
  end

  def list_categories(category_list) do
    Enum.map(category_list, fn(c) -> c.name end)
  end

  def category_list_to_map(category_list) do
    map = Enum.reduce category_list, %{},  fn cat, acc ->
      Map.put(acc, cat.name, cat.items)
    end
  end

  def get_rand(map_lists, key) do
    items = map_lists[key]
    Enum.random(items)
  end

  def simple_sentence(category_map) do 
    adjective = get_rand(category_map, "Adjectives")
    animal = get_rand(category_map, "Animal")
    verb = get_rand(category_map, "Verbs")
    possessive = get_rand(category_map, "Possessive")
    "The #{adjective} #{animal} wants to #{verb} to #{possessive}"
  end

  def simple_question(category_map) do 
    pronoun = get_rand(category_map, "Pronouns")
    auxverb = get_rand(category_map, "AuxVerb")
    verb = get_rand(category_map, "Verbs")
    adjective = get_rand(category_map, "Adjectives")
    location = get_rand(category_map, "Location")
    time = get_rand(category_map, "TimeRel")
    "#{auxverb} #{pronoun} #{verb} at the #{location} #{time}?"
  end

  defmodule Parser do
    # We have a file containing
    # category:itemscsv

    # splits into [category | rest strings]
    def split_category_name(str) do
      split = String.split(String.lstrip(str), ":", parts: 2)
      #split = String.split(str, ":", parts: 2)
      [head | tail] = split
      if tail == [] do
        # Empty second part means no : found, return only name "" 
        [ "" | [head] ]
      else 
        split
      end
    end


    def load_file() do
      path = "/Users/msergio/code/elixir/madlib/list_en.txt"
      readwordlist(path) |> Enum.to_list
    end

    def split_csv_to_items(str) do
      split = String.split(str, ",") |> Enum.map(fn x -> String.strip(x) end)
      if split == [""] do 
        []
      else
        split
      end
    end

    def category_new(str) do 
      [category_name | item_str]  = split_category_name(str)
      name = category_name
      items = item_str |> hd |> split_csv_to_items
      %Category{name: name, items: items}
    end

    def readwordlist(path) do
      case File.open(path) do
        {:error, reason} -> IO.puts "Error opening #{path}: #{reason}"
        {:ok, file} ->
          stream = IO.stream(file, :line)
                    |> Stream.filter(&(!String.starts_with?(&1, "#")))
                    |> Stream.map(&(category_new(&1)))
      end
    end 
  end

  def main(args) do
    path = "/Users/msergio/code/elixir/madlib/list_en.txt"
    categories = Parser.readwordlist(path) 
    categories = Enum.to_list(categories)
    # Debug
    # dump_all_categories_and_items(categories)
    # IO.puts("Categories:")
    # dump_categories(categories)
    # IO.puts("")

    cat_map = category_list_to_map(categories)

    # IO.puts(Enum.join(Map.keys(cat_map), ","))
    # items = cat_map["Animal"]
    # if items == nil do
    #   IO.puts("Nothing found")
    # else
    #   IO.puts(Enum.random(items))
    # end
    IO.puts(simple_sentence(cat_map))
    IO.puts(simple_question(cat_map))
  end

end
