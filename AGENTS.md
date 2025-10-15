This is a web application written using the Phoenix web framework.

<!-- usage-rules-start -->
<!-- usage-rules-header -->
# Usage Rules

**IMPORTANT**: Consult these usage rules early and often when working with the packages listed below.
Before attempting to use any of these packages or to discover if you should use them, review their
usage rules to understand the correct patterns, conventions, and best practices.
<!-- usage-rules-header-end -->

<!-- nomify:elixir-start -->
## nomify:elixir usage
## Elixir guidelines

- Elixir lists **do not support index based access via the access syntax**

  **Never do this (invalid)**:

      i = 0
      mylist = ["blue", "green"]
      mylist[i]

  Instead, **always** use `Enum.at`, pattern matching, or `List` for index based list access, ie:

      i = 0
      mylist = ["blue", "green"]
      Enum.at(mylist, i)

- Elixir supports `if/else` but **does NOT support `if/else if` or `if/elsif`. **Never use `else if` or `elseif` in Elixir**, **always** use `cond` or `case` for multiple conditionals.

  **Never do this (invalid)**:

      <%= if condition do %>
        ...
      <% else if other_condition %>
        ...
      <% end %>

  Instead **always** do this:

      <%= cond do %>
        <% condition -> %>
          ...
        <% condition2 -> %>
          ...
        <% true -> %>
          ...
      <% end %>

- Elixir variables are immutable, but can be rebound, so for block expressions like `if`, `case`, `cond`, etc
  you *must* bind the result of the expression to a variable if you want to use it and you CANNOT rebind the result inside the expression, ie:

      # INVALID: we are rebinding inside the `if` and the result never gets assigned
      if connected?(socket) do
        socket = assign(socket, :val, val)
      end

      # VALID: we rebind the result of the `if` to a new variable
      socket =
        if connected?(socket) do
          assign(socket, :val, val)
        end

- Use `with` for chaining operations that return `{:ok, _}` or `{:error, _}`
- **Never** nest multiple modules in the same file as it can cause cyclic dependencies and compilation errors
- **Never** use map access syntax (`changeset[:field]`) on structs as they do not implement the Access behaviour by default. For regular structs, you **must** access the fields directly, such as `my_struct.field` or use higher level APIs that are available on the struct if they exist, `Ecto.Changeset.get_field/2` for changesets
- Elixir's standard library has everything necessary for date and time manipulation. Familiarize yourself with the common `Time`, `Date`, `DateTime`, and `Calendar` interfaces by accessing their documentation as necessary. **Never** install additional dependencies unless asked or for date/time parsing (which you can use the `date_time_parser` package)
- Don't use `String.to_atom/1` on user input (memory leak risk)
- Predicate function names should not start with `is_` and should end in a question mark. Names like `is_thing` should be reserved for guards
- Elixir's builtin OTP primitives like `DynamicSupervisor` and `Registry`, require names in the child spec, such as `{DynamicSupervisor, name: MyApp.MyDynamicSup}`, then you can use `DynamicSupervisor.start_child(MyApp.MyDynamicSup, child_spec)`
- Use `Task.async_stream(collection, callback, options)` for concurrent enumeration with back-pressure. The majority of times you will want to pass `timeout: :infinity` as option

## Mix guidelines

- Read the docs and options before using tasks (by using `mix help task_name`)
- To debug test failures, run tests in a specific file with `mix test test/my_test.exs` or run all previously failed tests with `mix test --failed`
- `mix deps.clean --all` is **almost never needed**. **Avoid** using it unless you have good reason

<!-- nomify:elixir-end -->
<!-- nomify:phoenix-start -->
## nomify:phoenix usage
## Phoenix guidelines

- Remember Phoenix router `scope` blocks include an optional alias which is prefixed for all routes within the scope. **Always** be mindful of this when creating routes within a scope to avoid duplicate module prefixes.

- You **never** need to create your own `alias` for route definitions! The `scope` provides the alias, ie:

      scope "/admin", AppWeb.Admin do
        pipe_through :browser

        live "/users", UserLive, :index
      end

  the UserLive route would point to the `AppWeb.Admin.UserLive` module

- `Phoenix.View` no longer is needed or included with Phoenix, don't use it

## Ecto Guidelines

- **Always** preload Ecto associations in queries when they'll be accessed in templates, ie a message that needs to reference the `message.user.email`
- Remember `import Ecto.Query` and other supporting modules when you write `seeds.exs`
- `Ecto.Schema` fields always use the `:string` type, even for `:text`, columns, ie: `field :name, :string`
- `Ecto.Changeset.validate_number/2` **DOES NOT SUPPORT the `:allow_nil` option**. By default, Ecto validations only run if a change for the given field exists and the change value is not nil, so such as option is never needed
- You **must** use `Ecto.Changeset.get_field(changeset, :field)` to access changeset fields
- Fields which are set programatically, such as `user_id`, must not be listed in `cast` calls or similar for security purposes. Instead they must be explicitly set when creating the struct

## Phoenix HTML guidelines

- Phoenix templates **always** use `~H` or .html.heex files (known as HEEx), **never** use `~E`
- **Always** use the imported `Phoenix.Component.form/1` and `Phoenix.Component.inputs_for/1` function to build forms. **Never** use `Phoenix.HTML.form_for` or `Phoenix.HTML.inputs_for` as they are outdated
- When building forms **always** use the already imported `Phoenix.Component.to_form/2` (`assign(socket, form: to_form(...))` and `<.form for={@form} id="msg-form">`), then access those forms in the template via `@form[:field]`
- **Always** add unique DOM IDs to key elements (like forms, buttons, etc) when writing templates, these IDs can later be used in tests (`<.form for={@form} id="product-form">`)
- For "app wide" template imports, you can import/alias into the `my_app_web.ex`'s `html_helpers` block, so they will be available to all LiveViews, LiveComponent's, and all modules that do `use MyAppWeb, :html` (replace "my_app" by the actual app name)

- HEEx require special tag annotation if you want to insert literal curly's like `{` or `}`. If you want to show a textual code snippet on the page in a `<pre>` or `<code>` block you *must* annotate the parent tag with `phx-no-curly-interpolation`:

      <code phx-no-curly-interpolation>
        let obj = {key: "val"}
      </code>

  Within `phx-no-curly-interpolation` annotated tags, you can use `{` and `}` without escaping them, and dynamic Elixir expressions can still be used with `<%= ... %>` syntax

- HEEx class attrs support lists, but you must **always** use list `[...]` syntax. You can use the class list syntax to conditionally add classes, **always do this for multiple class values**:

      <a class={[
        "px-2 text-white",
        @some_flag && "py-5",
        if(@other_condition, do: "border-red-500", else: "border-blue-100"),
        ...
      ]}>Text</a>

  and **always** wrap `if`'s inside `{...}` expressions with parens, like done above (`if(@other_condition, do: "...", else: "...")`)

  and **never** do this, since it's invalid (note the missing `[` and `]`):

      <a class={
        "px-2 text-white",
        @some_flag && "py-5"
      }> ...
      => Raises compile syntax error on invalid HEEx attr syntax

- **Never** use `<% Enum.each %>` or non-for comprehensions for generating template content, instead **always** use `<%= for item <- @collection do %>`
- HEEx HTML comments use `<%!-- comment --%>`. **Always** use the HEEx HTML comment syntax for template comments (`<%!-- comment --%>`)
- HEEx allows interpolation via `{...}` and `<%= ... %>`, but the `<%= %>` **only** works within tag bodies. **Always** use the `{...}` syntax for interpolation within tag attributes, and for interpolation of values within tag bodies. **Always** interpolate block constructs (if, cond, case, for) within tag bodies using `<%= ... %>`.

  **Always** do this:

      <div id={@id}>
        {@my_assign}
        <%= if @some_block_condition do %>
          {@another_assign}
        <% end %>
      </div>

  and **Never** do this – the program will terminate with a syntax error:

      <%!-- THIS IS INVALID NEVER EVER DO THIS --%>
      <div id="<%= @invalid_interpolation %>">
        {if @invalid_block_construct do}
        {end}
      </div>

## Phoenix LiveView guidelines

- **Never** use the deprecated `live_redirect` and `live_patch` functions, instead **always** use the `<.link navigate={href}>` and  `<.link patch={href}>` in templates, and `push_navigate` and `push_patch` functions LiveViews
- **Avoid LiveComponent's** unless you have a strong, specific need for them
- LiveViews should be named like `AppWeb.WeatherLive`, with a `Live` suffix. When you go to add LiveView routes to the router, the default `:browser` scope is **already aliased** with the `AppWeb` module, so you can just do `live "/weather", WeatherLive`
- Remember anytime you use `phx-hook="MyHook"` and that js hook manages its own DOM, you **must** also set the `phx-update="ignore"` attribute
- **Never** write embedded `<script>` tags in HEEx. Instead always write your scripts and hooks in the `assets/js` directory and integrate them with the `assets/js/app.js` file

### LiveView streams

- **Always** use LiveView streams for collections for assigning regular lists to avoid memory ballooning and runtime termination with the following operations:
  - basic append of N items - `stream(socket, :messages, [new_msg])`
  - resetting stream with new items - `stream(socket, :messages, [new_msg], reset: true)` (e.g. for filtering items)
  - prepend to stream - `stream(socket, :messages, [new_msg], at: -1)`
  - deleting items - `stream_delete(socket, :messages, msg)`

- When using the `stream/3` interfaces in the LiveView, the LiveView template must 1) always set `phx-update="stream"` on the parent element, with a DOM id on the parent element like `id="messages"` and 2) consume the `@streams.stream_name` collection and use the id as the DOM id for each child. For a call like `stream(socket, :messages, [new_msg])` in the LiveView, the template would be:

      <div id="messages" phx-update="stream">
        <div :for={{id, msg} <- @streams.messages} id={id}>
          {msg.text}
        </div>
      </div>

- LiveView streams are *not* enumerable, so you cannot use `Enum.filter/2` or `Enum.reject/2` on them. Instead, if you want to filter, prune, or refresh a list of items on the UI, you **must refetch the data and re-stream the entire stream collection, passing reset: true**:

      def handle_event("filter", %{"filter" => filter}, socket) do
        # re-fetch the messages based on the filter
        messages = list_messages(filter)

        {:noreply,
        socket
        |> assign(:messages_empty?, messages == [])
        # reset the stream with the new messages
        |> stream(:messages, messages, reset: true)}
      end

- LiveView streams *do not support counting or empty states*. If you need to display a count, you must track it using a separate assign. For empty states, you can use Tailwind classes:

      <div id="tasks" phx-update="stream">
        <div class="hidden only:block">No tasks yet</div>
        <div :for={{id, task} <- @stream.tasks} id={id}>
          {task.name}
        </div>
      </div>

  The above only works if the empty state is the only HTML block alongside the stream for-comprehension.

- **Never** use the deprecated `phx-update="append"` or `phx-update="prepend"` for collections

### LiveView tests

- `Phoenix.LiveViewTest` module and `LazyHTML` (included) for making your assertions
- Form tests are driven by `Phoenix.LiveViewTest`'s `render_submit/2` and `render_change/2` functions
- Come up with a step-by-step test plan that splits major test cases into small, isolated files. You may start with simpler tests that verify content exists, gradually add interaction tests
- **Always reference the key element IDs you added in the LiveView templates in your tests** for `Phoenix.LiveViewTest` functions like `element/2`, `has_element/2`, selectors, etc
- **Never** tests again raw HTML, **always** use `element/2`, `has_element/2`, and similar: `assert has_element?(view, "#my-form")`
- Instead of relying on testing text content, which can change, favor testing for the presence of key elements
- Focus on testing outcomes rather than implementation details
- Be aware that `Phoenix.Component` functions like `<.form>` might produce different HTML than expected. Test against the output HTML structure, not your mental model of what you expect it to be
- When facing test failures with element selectors, add debug statements to print the actual HTML, but use `LazyHTML` selectors to limit the output, ie:

      html = render(view)
      document = LazyHTML.from_fragment(html)
      matches = LazyHTML.filter(document, "your-complex-selector")
      IO.inspect(matches, label: "Matches")

### Form handling

#### Creating a form from params

If you want to create a form based on `handle_event` params:

    def handle_event("submitted", params, socket) do
      {:noreply, assign(socket, form: to_form(params))}
    end

When you pass a map to `to_form/1`, it assumes said map contains the form params, which are expected to have string keys.

You can also specify a name to nest the params:

    def handle_event("submitted", %{"user" => user_params}, socket) do
      {:noreply, assign(socket, form: to_form(user_params, as: :user))}
    end

#### Creating a form from changesets

When using changesets, the underlying data, form params, and errors are retrieved from it. The `:as` option is automatically computed too. E.g. if you have a user schema:

    defmodule MyApp.Users.User do
      use Ecto.Schema
      ...
    end

And then you create a changeset that you pass to `to_form`:

    %MyApp.Users.User{}
    |> Ecto.Changeset.change()
    |> to_form()

Once the form is submitted, the params will be available under `%{"user" => user_params}`.

In the template, the form form assign can be passed to the `<.form>` function component:

    <.form for={@form} id="todo-form" phx-change="validate" phx-submit="save">
      <.input field={@form[:field]} type="text" />
    </.form>

Always give the form an explicit, unique DOM ID, like `id="todo-form"`.

#### Avoiding form errors

**Always** use a form assigned via `to_form/2` in the LiveView, and the `<.input>` component in the template. In the template **always access forms this**:

    <%!-- ALWAYS do this (valid) --%>
    <.form for={@form} id="my-form">
      <.input field={@form[:field]} type="text" />
    </.form>

And **never** do this:

    <%!-- NEVER do this (invalid) --%>
    <.form for={@changeset} id="my-form">
      <.input field={@changeset[:field]} type="text" />
    </.form>

- You are FORBIDDEN from accessing the changeset in the template as it will cause errors
- **Never** use `<.form let={f} ...>` in the template, instead **always use `<.form for={@form} ...>`**, then drive all form references from the form assign as in `@form[:field]`. The UI should **always** be driven by a `to_form/2` assigned in the LiveView module that is derived from a changeset

## Project guidelines

- Use `mix precommit` alias when you are done with all changes and fix any pending issues
- Use the already included and available `:req` (`Req`) library for HTTP requests, **avoid** `:httpoison`, `:tesla`, and `:httpc`. Req is included by default and is the preferred HTTP client for Phoenix apps

### Phoenix v1.8 guidelines

- **Always** begin your LiveView templates with `<Layouts.app flash={@flash} ...>` which wraps all inner content
- The `MyAppWeb.Layouts` module is aliased in the `my_app_web.ex` file, so you can use it without needing to alias it again
- Anytime you run into errors with no `current_scope` assign:
  - You failed to follow the Authenticated Routes guidelines, or you failed to pass `current_scope` to `<Layouts.app>`
  - **Always** fix the `current_scope` error by moving your routes to the proper `live_session` and ensure you pass `current_scope` as needed
- Phoenix v1.8 moved the `<.flash_group>` component to the `Layouts` module. You are **forbidden** from calling `<.flash_group>` outside of the `layouts.ex` module
- Out of the box, `core_components.ex` imports an `<.icon name="hero-x-mark" class="w-5 h-5"/>` component for for hero icons. **Always** use the `<.icon>` component for icons, **never** use `Heroicons` modules or similar
- **Always** use the imported `<.input>` component for form inputs from `core_components.ex` when available. `<.input>` is imported and using it will will save steps and prevent errors
- If you override the default input classes (`<.input class="myclass px-2 py-1 rounded-lg">)`) class with your own values, no default classes are inherited, so your
custom classes must fully style the input

### JS and CSS guidelines

- **Use Tailwind CSS classes and custom CSS rules** to create polished, responsive, and visually stunning interfaces.
- Tailwindcss v4 **no longer needs a tailwind.config.js** and uses a new import syntax in `app.css`:

      @import "tailwindcss" source(none);
      @source "../css";
      @source "../js";
      @source "../../lib/my_app_web";

- **Always use and maintain this import syntax** in the app.css file for projects generated with `phx.new`
- **Never** use `@apply` when writing raw css
- **Always** manually write your own tailwind-based components instead of using daisyUI for a unique, world-class design
- Out of the box **only the app.js and app.css bundles are supported**
  - You cannot reference an external vendor'd script `src` or link `href` in the layouts
  - You must import the vendor deps into app.js and app.css to use them
  - **Never write inline <script>custom js</script> tags within templates**

### UI/UX & design guidelines

- **Produce world-class UI designs** with a focus on usability, aesthetics, and modern design principles
- Implement **subtle micro-interactions** (e.g., button hover effects, and smooth transitions)
- Ensure **clean typography, spacing, and layout balance** for a refined, premium look
- Focus on **delightful details** like hover effects, loading states, and smooth page transitions

## Authentication

- **Always** handle authentication flow at the router level with proper redirects
- **Always** be mindful of where to place routes. `phx.gen.auth` creates multiple router plugs and `live_session` scopes:
  - A `live_session :current_user` scope - For routes that need the current user but don't require authentication
  - A `live_session :require_authenticated_user` scope - For routes that require authentication
  - In both cases, a `@current_scope` is assigned to the Plug connection and LiveView socket
- **Always let the user know in which router scopes, `live_session`, and pipeline you are placing the route, AND SAY WHY**
- `phx.gen.auth` assigns the `current_scope` assign - it **does not assign the `current_user` assign**.
- To derive/access `current_user`, **always use the `current_scope.user` assign**, never use **`@current_user`** in templates or LiveViews
- **Never** duplicate `live_session` names. A `live_session :current_user` can only be defined __once__ in the router, so all routes for the `live_session :current_user`  must be grouped in a single block
- Anytime you hit `current_scope` errors or the logged in session isn't displaying the right content, **always double check the router and ensure you are using the correct `live_session` described below**

### Routes that require authentication

LiveViews that require login should **always be placed inside the __existing__ `live_session :require_authenticated_user` block**:

    scope "/", AppWeb do
      pipe_through [:browser, :require_authenticated_user]

      live_session :require_authenticated_user,
        on_mount: [{AppWeb.UserAuth, :ensure_authenticated}] do
        # phx.gen.auth generated routes
        live "/users/settings", UserSettingsLive, :edit
        live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
        # our own routes that require logged in user
        live "/", MyLiveThatRequiresAuth, :index
      end
    end

### Routes that work with or without authentication

LiveViews that can work with or without authentication, **always use the __existing__ `:current_user` scope**, ie:

    scope "/", MyAppWeb do
      pipe_through [:browser]

      live_session :current_user,
        on_mount: [{MyAppWeb.UserAuth, :mount_current_scope}] do
        # our own routes that work with or without authentication
        live "/", PublicLive
      end
    end

<!-- nomify:phoenix-end -->
<!-- igniter-start -->
## igniter usage
_A code generation and project patching framework_

[igniter usage rules](deps/igniter/usage-rules.md)
<!-- igniter-end -->
<!-- usage_rules-start -->
## usage_rules usage
_A dev tool for Elixir projects to gather LLM usage rules from dependencies_

## Using Usage Rules

Many packages have usage rules, which you should *thoroughly* consult before taking any
action. These usage rules contain guidelines and rules *directly from the package authors*.
They are your best source of knowledge for making decisions.

## Modules & functions in the current app and dependencies

When looking for docs for modules & functions that are dependencies of the current project,
or for Elixir itself, use `mix usage_rules.docs`

```
# Search a whole module
mix usage_rules.docs Enum

# Search a specific function
mix usage_rules.docs Enum.zip

# Search a specific function & arity
mix usage_rules.docs Enum.zip/1
```


## Searching Documentation

You should also consult the documentation of any tools you are using, early and often. The best
way to accomplish this is to use the `usage_rules.search_docs` mix task. Once you have
found what you are looking for, use the links in the search results to get more detail. For example:

```
# Search docs for all packages in the current application, including Elixir
mix usage_rules.search_docs Enum.zip

# Search docs for specific packages
mix usage_rules.search_docs Req.get -p req

# Search docs for multi-word queries
mix usage_rules.search_docs "making requests" -p req

# Search only in titles (useful for finding specific functions/modules)
mix usage_rules.search_docs "Enum.zip" --query-by title
```


<!-- usage_rules-end -->
<!-- usage_rules:elixir-start -->
## usage_rules:elixir usage
# Elixir Core Usage Rules

## Pattern Matching
- Use pattern matching over conditional logic when possible
- Prefer to match on function heads instead of using `if`/`else` or `case` in function bodies

## Error Handling
- Use `{:ok, result}` and `{:error, reason}` tuples for operations that can fail
- Avoid raising exceptions for control flow
- Use `with` for chaining operations that return `{:ok, _}` or `{:error, _}`

## Common Mistakes to Avoid
- Elixir has no `return` statement, nor early returns. The last expression in a block is always returned.
- Don't use `Enum` functions on large collections when `Stream` is more appropriate
- Avoid nested `case` statements - refactor to a single `case`, `with` or separate functions
- Don't use `String.to_atom/1` on user input (memory leak risk)
- Lists and enumerables cannot be indexed with brackets. Use pattern matching or `Enum` functions
- Prefer `Enum` functions like `Enum.reduce` over recursion
- When recursion is necessary, prefer to use pattern matching in function heads for base case detection
- Using the process dictionary is typically a sign of unidiomatic code
- Only use macros if explicitly requested
- There are many useful standard library functions, prefer to use them where possible

## Function Design
- Use guard clauses: `when is_binary(name) and byte_size(name) > 0`
- Prefer multiple function clauses over complex conditional logic
- Name functions descriptively: `calculate_total_price/2` not `calc/2`
- Predicate function names should not start with `is` and should end in a question mark.
- Names like `is_thing` should be reserved for guards

## Data Structures
- Use structs over maps when the shape is known: `defstruct [:name, :age]`
- Prefer keyword lists for options: `[timeout: 5000, retries: 3]`
- Use maps for dynamic key-value data
- Prefer to prepend to lists `[new | list]` not `list ++ [new]`

## Mix Tasks

- Use `mix help` to list available mix tasks
- Use `mix help task_name` to get docs for an individual task
- Read the docs and options fully before using tasks

## Testing
- Run tests in a specific file with `mix test test/my_test.exs` and a specific test with the line number `mix test path/to/test.exs:123`
- Limit the number of failed tests with `mix test --max-failures n`
- Use `@tag` to tag specific tests, and `mix test --only tag` to run only those tests
- Use `assert_raise` for testing expected exceptions: `assert_raise ArgumentError, fn -> invalid_function() end`
- Use `mix help test` to for full documentation on running tests

## Debugging

- Use `dbg/1` to print values while debugging. This will display the formatted value and other relevant information in the console.

<!-- usage_rules:elixir-end -->
<!-- usage_rules:otp-start -->
## usage_rules:otp usage
# OTP Usage Rules

## GenServer Best Practices
- Keep state simple and serializable
- Handle all expected messages explicitly
- Use `handle_continue/2` for post-init work
- Implement proper cleanup in `terminate/2` when necessary

## Process Communication
- Use `GenServer.call/3` for synchronous requests expecting replies
- Use `GenServer.cast/2` for fire-and-forget messages.
- When in doubt, us `call` over `cast`, to ensure back-pressure
- Set appropriate timeouts for `call/3` operations

## Fault Tolerance
- Set up processes such that they can handle crashing and being restarted by supervisors
- Use `:max_restarts` and `:max_seconds` to prevent restart loops

## Task and Async
- Use `Task.Supervisor` for better fault tolerance
- Handle task failures with `Task.yield/2` or `Task.shutdown/2`
- Set appropriate task timeouts
- Use `Task.async_stream/3` for concurrent enumeration with back-pressure

<!-- usage_rules:otp-end -->
<!-- essential_ecto:adr-start -->
## essential_ecto:adr usage
## Architecture Decision Records (ADR)

**Title** These documents have names that are short noun phrases. For example, "ADR 1: Deployment on Ruby on Rails 3.0.10" or "ADR 9: LDAP for Multitenant Integration"

**Context** This section describes the forces at play, including technological, political, social, and project local. These forces are probably in tension, and should be called out as such. The language in this section is value-neutral. It is simply describing facts.

**Decision** This section describes our response to these forces. It is stated in full sentences, with active voice. "We will …"

**Status** A decision may be "proposed" if the project stakeholders haven't agreed with it yet, or "accepted" once it is agreed. If a later ADR changes or reverses a decision, it may be marked as "deprecated" or "superseded" with a reference to its replacement.

**Consequences** This section describes the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences, but all of them affect the team and project in the future.

<!-- essential_ecto:adr-end -->
<!-- essential_ecto:association_patterns-start -->
## essential_ecto:association_patterns usage
## Association Patterns

Asssocations must be documented with one of the following patterns:

**Actor - Role**

Use to model the participation of a person, organization, place, or thing in a context.

- An _actor_ knows about zero to many _roles_, but typically takes on only or of each kind.
- A _role_ represents a unique view of its _actor_ with a context. The _role_ depends on its _actor_ and cannot exist without it.

**OuterPlace - Place**

Use to model a hierarchy of locations where events happen.

- An _outer place_ is the container for zero or more _places_.
- A _place_ knows at most one o_uter place_. The _place's_ location depends on the location of its _outer place_.

**Item - SpecificItem**

Use to model a thing that exists in several distinct variations.

- An _item_ is the common description for zero to many _specific items_.
- A _specific item_ knows and depends on one _item_. The _specific item's_ property values distinguish it from other _specific items_ described by the same _item_.

**Assembly - Part**

Use to model an ensemble of things.

- An _assembly_ has one or more _parts_. Its _parts_ determine its properties, and the _assembly_ cannot exist without them.
- A _part_ belongs to at most one _assembly_ at a time. The _part_ can exist on its own.

**Container - Content**

Use to model a receptacle for things.

- A _container_ holds zero or more _content_ objects. Unlike an _assembly_, it can be empty.
- A _content_ object can be in at most one _container_ at a time. The _content_ object can exist on its own.

**Group - Member**

Use to model a classification of things.

- A _group_ contains zero or more _members_. _Groups_ are used to classify objects.
- A _member_, unlike a _part_ or _content_ objects, can belong to more than one _group_.

**Role - Transaction**

Use to record participants in events.

- A _transaction_ knows one _role_, the doer of its interaction.
- A _role_ knows about zero or more _transactions_. The _role_ provides a contextual description of the person, organization, thing, or place involved in the _transaction_.

**Place - Transaction**

Use to record where an event happens.

- A _transaction_ occurs at one _place_.
- A _place_ knows about zero to many _transactions_. The _transactions_ record the history of interactions at the _place_.

**SpecificItem - Transaction**

Use to record an event involving a single thing.

- A _transaction_ knows about on _specific item_.
- A _specific item_ can be involved in zero to many _transactions._ The _transactions_ record the _specific item's_ history or interactions.

**CompositeTransaction - LineItem**

Use to record an event involving more than one thing.

- A _composite transaction_ must contain at least one _line item_.
- A _line item_ knows only one _composite transaction_. The _line item_ depends on the _composite transaction_ and cannot exist without it.

**SpecificItem - LineItem**

Use to record the particular involvement of a thing in an event involving multiple things.

- A _specific item_ can be involved in zero to many _line items_.
- A _line item_ knows exactly one _specific item_. The _line item_ captures details about the _specific item's_ interaction a _composite transaction_.

**Transaction - FollowupTransaction**

Use to record an event that occurs only after a previous event.

- A _transaction_ knows about some number of _follow-up transactions_.
- A follow-up transaction_ follows and depends on exactly one previous _transaction_.

Association documentation must be formatted as a list of bullet points using the following template:

```TEMPLATE
`{association_name}` ({association pattern}): {documentation}
```

<!-- essential_ecto:association_patterns-end -->
<!-- essential_ecto:record-definition-start -->
## essential_ecto:record-definition usage
## Record Definition

Define the module as a business term following these guidelines:

## The Kick-Off of a Definition

Guideline 1. The Definition of a Term Should Start with a Noun.
Guideline 2. The Kick-Off Word of a Definition Should Not Be the Term Being Defined.
Guideline 3. A Definition Should Not Be Simply a Synonym of the Term Defined.
Guideline 4. The Kick-Off Word of a Definition and the Term Being Defined Should Align.
Guideline 5. The Term Being Defined Should Be Singular.
Guideline 6. The Kick-Off Word of a Definition Should Be Singular.

## The Main Body of a Definition

Guideline 7. The Definition of a Term Should Express the Essence of the Concept, not its Purpose, Function or Use.
Guideline 8. A Definition Should Be Clear About Whether the Word Being Defined Designates an Individual Thing or a General Concept.
Guideline 9. A Definition Should Not Comprise Multiple Sentences.
Guideline 10. A Definition Should Not Embed Business Rules.
Guideline 11. A Definition Should Provide a Clear Antecedent for Each Embedded Pronoun.
Guideline 12. A Definition Should Provide a Clear Antecedent for Each Definite Article After the Kick-Off Word.

<!-- essential_ecto:record-definition-end -->
<!-- essential_ecto:typedoc-start -->
## essential_ecto:typedoc usage
## Typedoc

- Write a `typedoc` for this Ecto Schema.
- The typedoc must appear above the `typespec`.
- If `@typedoc` already exists, skip.

Typedoc for fields should exclude:

- `id` field
- description of the struct type
- values for enums (Ecto.Enum)
- timestamps
- foreign key ID's

Fields must be documented with one of the following categories:

- descriptive: Domain-specific and tracking fields
- time: date or time fields
- lifecycle state: status of one-way state transitions (e.g., nomination status: pending, in review, approved, rejected)
- operating state: status of two-way state transitions (e.g., sensor state: off, on)
- role: classification of people (e.g., team member role: chair, admin, member)
- type: classification of places, things, and events (e.g., store type: physical, online, phone)

Fields documentation must be formatted as a list of bullet points using the following template:

```TEMPLATE
`{field_name}` ({field category}): {documentation}
```

<!-- essential_ecto:typedoc-end -->
<!-- essential_ecto:typespec-start -->
## essential_ecto:typespec usage
## Typespec

- Write a `typespec` for this Ecto Schema.
- The `typespec` should always appear above the Ecto schema.
- If `@type` already exists, skip.

The typespec must include:

- all fields (including timestamps and foreign key ID's)
- associations, e.g. belongs_to, has_one, has_many

The typedoc must use this template where places holders are {} and directives are //:

```TEMPLATE
## Fields

A {human_form_of_module_name} has these fields:

{list_of_fields}

//OPTIONAL(start): include only when associations are defined

## Associations

A {human_form_of_module_name} associates with:

{list_of_associations}
```

Typespec for fields should include:

- `id` field

Types for fields:

- `id: integer()`

<!-- essential_ecto:typespec-end -->
<!-- essential_ecto:10_essential_ecto-start -->
## essential_ecto:10_essential_ecto usage
# Essential Ecto

## Record Categories

Through discovery find the following category of records:

- **People**: a record of a person or an organization; an _actor_ participating in a system.
- **Places**: a record of the location where an event occurs; places in multiple contexts record
  their participation as a _role_.
- **Articles**: a _subject_ of an **event**; people or places as the subject of an event act like
  articles. Articles require two records to represent them -- a generalized record (item) shared
  between many specific records (specific item). **Aggregated Articles** require two records to
  represent the receptacle and the article in the receptacle; these include _containers_ (_content_),
  _groups_ (_member_) and _assemblies_ (_part_).
- **Events**: a historical record of the particpation of people, places or articles in a context.
  Events are recorded as transactions in two way: **point-in-time** (single timestamp) or
  **time-interval** (start and end timestamps). Events may require multiple transaction records for
  _composite_ or _follow-up_ events.

## Association Players

Typically associations are thought of in terms of `has_many`, `has_one`, `belongs_to`. etc, and each
record form a parent-child relationship, limiting our ability to model the domain.

Thinking beyond Ecto associations, records forming an association play a richer part than simply
parent-child:

**People**

- Actor
- Role

**Places**

- Place
- OuterPlace

**Articles**

- Item
- SpecificItem
- Assembly
- Part
- Container
- Content

**Events**

- Transaction
- CompositeTransaction
- LineItem
- Follow-upTransaction

> "the presence of a given type of object suggests the presences of its likely collaborators"
> -- Streamlined Object Modeling

## Theory

1. [Association Patterns]()
2. [Association Validations]()
3. [Fields and Actions]()

## Implementation

The implementation is performed in two steps:

1. [Implement the association pairs](); i.e. schema and context modules
2. [Implement the buiness rules]()

<!-- essential_ecto:10_essential_ecto-end -->
<!-- essential_ecto:20_association_patterns-start -->
## essential_ecto:20_association_patterns usage
## Association Patterns

Asssocations must be documented with one of the following patterns:

**Actor - Role**

Use to model the participation of a person, organization, place, or thing in a context.

- An _actor_ knows about zero to many _roles_, but typically takes on only or of each kind.
- A _role_ represents a unique view of its _actor_ with a context. The _role_ depends on its _actor_ and cannot exist without it.

**OuterPlace - Place**

Use to model a hierarchy of locations where events happen.

- An _outer place_ is the container for zero or more _places_.
- A _place_ knows at most one o_uter place_. The _place's_ location depends on the location of its _outer place_.

**Item - SpecificItem**

Use to model a thing that exists in several distinct variations.

- An _item_ is the common description for zero to many _specific items_.
- A _specific item_ knows and depends on one _item_. The _specific item's_ property values distinguish it from other _specific items_ described by the same _item_.

**Assembly - Part**

Use to model an ensemble of things.

- An _assembly_ has one or more _parts_. Its _parts_ determine its properties, and the _assembly_ cannot exist without them.
- A _part_ belongs to at most one _assembly_ at a time. The _part_ can exist on its own.

**Container - Content**

Use to model a receptacle for things.

- A _container_ holds zero or more _content_ objects. Unlike an _assembly_, it can be empty.
- A _content_ object can be in at most one _container_ at a time. The _content_ object can exist on its own.

**Group - Member**

Use to model a classification of things.

- A _group_ contains zero or more _members_. _Groups_ are used to classify objects.
- A _member_, unlike a _part_ or _content_ objects, can belong to more than one _group_.

**Role - Transaction**

Use to record participants in events.

- A _transaction_ knows one _role_, the doer of its interaction.
- A _role_ knows about zero or more _transactions_. The _role_ provides a contextual description of the person, organization, thing, or place involved in the _transaction_.

**Place - Transaction**

Use to record where an event happens.

- A _transaction_ occurs at one _place_.
- A _place_ knows about zero to many _transactions_. The _transactions_ record the history of interactions at the _place_.

**SpecificItem - Transaction**

Use to record an event involving a single thing.

- A _transaction_ knows about on _specific item_.
- A _specific item_ can be involved in zero to many _transactions._ The _transactions_ record the _specific item's_ history or interactions.

**CompositeTransaction - LineItem**

Use to record an event involving more than one thing.

- A _composite transaction_ must contain at least one _line item_.
- A _line item_ knows only one _composite transaction_. The _line item_ depends on the _composite transaction_ and cannot exist without it.

**SpecificItem - LineItem**

Use to record the particular involvement of a thing in an event involving multiple things.

- A _specific item_ can be involved in zero to many _line items_.
- A _line item_ knows exactly one _specific item_. The _line item_ captures details about the _specific item's_ interaction a _composite transaction_.

**Transaction - FollowupTransaction**

Use to record an event that occurs only after a previous event.

- A _transaction_ knows about some number of _follow-up transactions_.
- A follow-up transaction_ follows and depends on exactly one previous _transaction_.

Association documentation must be formatted as a list of bullet points using the following template:

```TEMPLATE
`{association_name}` ({association pattern}): {documentation}
```

<!-- essential_ecto:20_association_patterns-end -->
<!-- essential_ecto:30_association_validations-start -->
## essential_ecto:30_association_validations usage
# Association Validations

Association patterns enable us to implement Business Rules. Business rules from the problem domain
are translated to Association Validations in your record modules in the solution domain.

Five categories of validations:

- **Type**: validate right type
- **Cardinality**: validate too many/too few associations
- **Field**: validate correct values
- **State**: validate correct state
- **Conflict**: validate compatibility

Validations are shared between players:

|                       | Type | Cardinality | Fields   | State | Conflict |
| --------------------- | ---- | ------------| -------- | ----- | -------- |
| Actor                 |      |             |          |       |          |
| Role                  | x    | x           | x        | x     | x        |
|                       |      |             |          |       |          |
| Outer Place           |      | x           | x        | x     |          |
| Place                 | x    | x           | x        | x     | x        |
|                       |      |             |          |       |          |
| Item                  |      | x           |          | x     |          |
| Item Specific         | x    | x           | x        | x     | x        |
|                       |      |             |          |       |          |
| Assembly              |      | x           | x        | x     |          |
| Part                  | x    | x           | x        | x     | x        |
|                       |      |             |          |       |          |
| Container             |      | x           | x        | x     |          |
| Content               | x    | x           | x        | x     | x        |
|                       |      |             |          |       |          |
| Group                 |      | x           | x        | x     | x        |
| Member                | x    | x           | x        | x     | x        |
|                       |      |             |          |       |          |
| Role                  | x    | x           | x        | x     | x        |
| Transaction           |      | x           |          |       |          |
|                       |      |             |          |       |          |
| Place                 | x    | x           | x        | x     | x        |
| Transaction           |      | x           |          |       |          |
|                       |      |             |          |       |          |
| Specific Item         | x    | x           | x        | x     | x        |
| Transaction           |      | x           |          |       |          |
|                       |      |             |          |       |          |
| Composite Transaction |      | x           |          |       |          |
| Specific Item         | x    | x           |          |       |          |
|                       |      |             |          |       |          |
| Transaction           | x    | x           | x        | x     | x        |
| Follow-up Transaction |      | x           |          |       |          |

<!-- essential_ecto:30_association_validations-end -->
<!-- essential_ecto:40_fields_and_actions-start -->
## essential_ecto:40_fields_and_actions usage
# Fields and Actions

## Fields

- Except _descriptive_ fields, typically fields are validated and changed by a business service.
- Fields maybe _calculated or derived_, e.g. order total. They may be cached once a value cannot change.
- Fields maybe "_inherited_" from a record when two tables are need to present a "complete" record (Actor – Role, Item – SpecificItem,  CompositeTransaction – Line Item, see Generic - Specific Template below)
- Calculated or inherited fields are implemented using _virtual fields_.
- Historical fields are modeled as a _transaction_ (e.g. PriceHistory, RoleHistory)

Five categories of fields:

- **Descriptive**: Domain-specific and _tracking_ fields
- **Time**: date or time fields, typically records occurence of a transaction
- **Lifecycle state**: status of one-way state transitions (e.g., nomination status: pending, in review, approved, rejected)
- **Operating state**: status of two-way state transitions (e.g., sensor state: off, on)
- **Role**: classification of people (e.g., team member role: chair, admin, member)
- **Type**: classification of places, things, and events (e.g., store type: physical, online, phone)

Categorizing fields help us to decide how to represent them and what [business rules]() need to be consider.

## Actions

Three categories of actions:

- **Business Actions**: validate and change state (field and associations); create new records (typically transactions)
- **Query Actions**: return current state, e.g. predicates
- **Reporting Actions**: report on future or historical state

<!-- essential_ecto:40_fields_and_actions-end -->
<!-- essential_ecto:50_implementing_associations-start -->
## essential_ecto:50_implementing_associations usage
# Implementing Association Pairs

There are three implementation templates:

> ... 12 collaboration patterns can be classified into three categories: generic – specific, whole – part, or transaction – specific. The same prototyping template can implement all collaborations within a given category; thus, only three templates are required to implement all 12 collaboration patterns.
>
> -- Streamlined Object Modeling

> #### Templates {: .warning}
>
> Each template applies to two records.

**Generic - Specific Template**

- Actor - Role
- Item - Specific Item
- Composite Transaction - Line Item

**Whole - Part Template**

- Outer Place - Place
- Assembly - Part
- Container - Content
- Group - Member

**Specific - Transaction Template**

- Role - Transaction
- Place - Transaction
- Specific item - Transaction
- Transaction - Follow-up Transaction
- Specific Item - Line Item

## DAmpIER

How to define record and context modules:

1. Define (`def*`)

- Name: Give the record module a name
- Fields: Define the schema with fields with sensible defaults
- Associations: Add associations to the schema
- Context: Give the context module a name
- Migrations: Write the migrations

2. Actions

- Fields: Write `insert_changeset/2` and `update_changeset/2 function` in the schema module with field validations
- Associations: Write `put_ASSOC_changeset/2` functions in schema module (`delete_ASSOC_changeset/2`) ???
- Context: Write the actions functions

3. Inspect

- Fields
- Associations

4. Equality?

5. Run?

## Record Module Definitions

Record modules include:

- Fields (properties)
- Associations (object collaborations)
- Changesets; Fields and Associations
- Validations; Fields and Associations (object collaboration rules)

### Changesets

Write validations for each field as appropriate:

- validated with `Ecto.Changeset` validation functions, e.g., `validate_length/3`.
- `Ecto.Changeset` validation functions wrapped, e.g., `validate_title/1`

### Associations

Write association changesets for the dependent record:

- `put_ASSOC_changeset/2`, e.g., `put_team_member_changeset/2`

### Validations (Business Rules)

Convert business rules to validations:

- validate associations with `validate_ASSOC/1`, e.g. `validate_team_member/1`
  - calls `ASSOC_RECORD.check_RECORD/1`, e.g. `TeamMember.check_nomination/1`
- validate association conflicts with `validate_RECORD_conflict`
  - conflict exists between two or more associations
  - calls `ASSOC_RECORD.check_RECORD_conflict/2`

## Templates

TODO: Add examples from DAIER for each template

Associations Summary:

| Player 1    | Player 2 | assoc              |          | assoc        |          |
| ----------- | -------- | ------------------ | -------- | ------------ | -------- |
| Generic     | Specific | `has_one/has_many` |          | `belongs_to` | required |
| Whole       | Part     | `has_many`         |          | `belongs_to` | optional |
| Transaction | Specific | `belongs_to`       | required | `has_many`   |          |

NOTE: The dependent record is identified by the `belongs_to` association (or foreign_key).

### Generic - Specific Template

Generic:

- Associations: one association for each Specific; `has_one` or `has_many` dependent on business rules

Specific:

- Fields: Include "inherited" fields from Generic; populated in query functions
- Associations: `belongs_to` Generic (required)
- Record: `put_GENERIC_changeset/2`
- Context: `create_SPECIFIC(GENERIC, params)`

### Whole - Part Template

Whole:

- Associations: `has_many` Parts (optional)

Part:

- Associations: `belongs_to` Whole (optional)
- Record: `put_WHOLE_changeset/2`
- Context: `put_PART(WHOLE, PART)` or `create_PART(WHOLE, params)`

### Transaction - Specific Template

Transaction:

- Associations: `belongs_to` Specific (required)
- Context: `create_TRANSACTION(SPECIFIC, params)` (can be renamed to a business revealing action)
- Record: `put_SPECIFIC_changeset/2`

Specific:

- Associations: `has_many` Transactions

<!-- essential_ecto:50_implementing_associations-end -->
<!-- essential_ecto:60_implementing_business_rules-start -->
## essential_ecto:60_implementing_business_rules usage
# Implementing Business Rules

## Field Validations

Domain-specific limits on field values implemented using `Ecto.Changeset.validate_*` functions.

> 1. checking the logical validity of the new value, e.g `Ecto.Changeset.validate_required/3`
> 2. checking the business rule validity of the new value

Functions for enforcing field validations for business rules `validate_FIELD/1`, e.g.
`validate_title/1`. Wrapping encourages cohesive functions that include all related validations,
helpful for Cross-Field Validations (see below).

How to handle enums?? `validate_FIELD_VALUE/1`, e.g. `validate_status_accepted/1`

Validation rules by field category:

- **Descriptive and Time**: (1) State transition rules prevent fields from changing; (2) limit the range of possible values
- **State, Role and Type**: `Ecto.Enum` and may limit changes, e.g. state transition

Cross-Field Validation:

- Validate a change in one record requires checking business-rules in another.
- Record validates own field, associated record checks if the field value invalidates the association.
- Indicates a separate action/changeset is required

## Association Validations

Guidelines:

- Dual Validation: Both association players (record modules) validate the association (Why? Extensability, cohesiveness, locality)
- NJH: Commutative Rule Checking ???

## Steps

Follow the dependency graph to update Actions (changesets) :

1. Add "check" `check_ASSOC/1` functions to each associated record where required,
   see [Association Validations]()
2. Add validation functions for association changeset to call `check_ASSOC/1` functions
3. Add validations for each category as needed, see [Association Validations]()

`put_ASSOC_changeset/2` => `validate_ASSOC_1/1` => `check_ASSOC_1/1`
                        => `validate_ASSOC_2/1` => `check_ASSOC_2/1`

- Generic-Specific => `validate_GENERIC/1` ("inherited" fields)
- Whole-Part => `validate_WHOLE/1` => `WHOLE.check_PART/2`
- Transaction-Specific => `validate_SPECIFIC/1` => `SPECIFIC.check_TRANSACTION/1`

## Conflict Validations

Validates conflicts between in-direct associated records for a intermediary record.

`validate_PLAYER_1_PLAYER_2_conflict/1` can be implemented to any player that
has associations with different records.

- Implemented using `Ecto.Changeset.unique_constraint/3`
- Implemented calling `check_ASSOC/1` for indirect associated records.

<!-- essential_ecto:60_implementing_business_rules-end -->
<!-- usage-rules-end -->
