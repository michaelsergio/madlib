defmodule MadlibTest do
  use ExUnit.Case
  doctest Madlib

  test "the truth" do
    assert 1 + 1 == 2
  end

  # 'test' is sugar for def
  test "str eq" do
    assert "a" == "a"
  end

  # test "load file" do
  #   assert Madlib.Parser.load_file() == {[], []}
  # end

  test "split category list" do
    split = Madlib.Parser.split_csv_to_items("one, two, three\n")
    assert ["one", "two", "three"] == split

    assert [] == Madlib.Parser.split_csv_to_items("")
  end

  test "split category name" do
    split = Madlib.Parser.split_category_name("hello:a:bc")
    assert "hello" == hd(split)
    assert ["a:bc"] == tl(split)

    assert "" == hd(Madlib.Parser.split_category_name("hello|abc"))

    assert "" == hd(Madlib.Parser.split_category_name("\n"))
    assert "" == hd(Madlib.Parser.split_category_name(""))
  end

  test "category - new" do
    cat = Madlib.Parser.category_new("hello: a, b, c")
    assert cat.name == "hello"
    assert cat.items == ["a", "b", "c"]

    cat_empty_2 = Madlib.Parser.category_new("Category:")
    assert cat_empty_2.name == "Category"
    assert cat_empty_2.items == []

    cat_empty = Madlib.Parser.category_new("")
    assert cat_empty.name == ""
    assert cat_empty.items == []
  end

  test "category - list" do
    list = [ 
      %Madlib.Category{ name: "Noun", items: ["person", "place", "thing"]},
      %Madlib.Category{ name: "Verb", items: ["run", "walk", "sing"]},
    ]
    assert Madlib.list_categories(list) == ["Noun", "Verb"]
  end
end
