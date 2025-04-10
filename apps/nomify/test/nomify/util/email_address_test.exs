defmodule Nomify.Util.EmailAddressTest do
  use ExUnit.Case

  alias Nomify.Util.EmailAddress

  describe "parsing a string" do
    test "valid email address" do
      assert {:ok, "foo.bar@example.com"} = EmailAddress.parse("foo.bar@example.com")
    end

    test "nil value" do
      assert :error = EmailAddress.parse(nil)
    end

    test "empty string" do
      assert :error = EmailAddress.parse("")
    end

    test "blank string" do
      assert :error = EmailAddress.parse(" ")
    end

    test "missing '.' char" do
      assert :error = EmailAddress.parse("foo@examplecom")
    end

    test "missing '@' char" do
      assert :error = EmailAddress.parse("fooexample.com")
    end

    test "'.' last char" do
      assert :error = EmailAddress.parse("foo@example.")
    end

    test "no gap between '@' and '.' chars" do
      assert :error = EmailAddress.parse("foo@.com")
    end

    test "last '.' char before '&' char" do
      assert :error = EmailAddress.parse("foo.bar@examplecom")
    end

    test "before '@' char, first char must be a letter, digit or '_'" do
      assert :error = EmailAddress.parse("*foo.bar@example.com")
      assert {:ok, _value} = EmailAddress.parse("1foo.bar@example.com")
      assert {:ok, _value} = EmailAddress.parse("_foo.bar@example.com")
    end

    test "between '@' and last '.'chars, first char must be a letter, digit or '_'" do
      assert :error = EmailAddress.parse("foo.bar@*example.com")
      assert {:ok, _value} = EmailAddress.parse("foo.bar@1example.com")
      assert {:ok, _value} = EmailAddress.parse("foo.bar@_example.com")
    end

    test "after last '.' char, first char must be a letter, digit or '_'" do
      assert :error = EmailAddress.parse("foo.bar@example.*com")
      assert {:ok, _value} = EmailAddress.parse("foo.bar@example.1com")
      assert {:ok, _value} = EmailAddress.parse("foo.bar@example._com")
    end
  end
end
