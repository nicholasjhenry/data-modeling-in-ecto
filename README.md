# Nomify

NOTE: This is a work in progress, please do not base your application on these ideas. Yet.

An example using "Essential Ecto", a technique to consistently model your domain
with business rules in your application's Context Modules and Ecto Schemas.

The "Essential Ecto" (working title) specification is the application of
[Streamlined Object Modeling](https://streamlinedmodeling.com/) by Jill Nicola,
Mark Mayfield and Mike Abney applied to Ecto.

- To learn more about the application, see: `Nomify` module documentation.
- To learn about this technique checkout out the docs: `mix docs`

## Documentation

| Application                                        | Description                                                                                                    |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Essential Ecto [Docs](./essential_ecto/index.html) | Business Rule Specification                                                                                    |
| Nomify [Docs](./nomify/index.html)                 | From Chapter 7 Implementing Collaborations Patterns, Chapter 8 Implementing Business Rules and casestudy code. |
| Examples [Docs](./examples/index.html)             | From Chapter 4 Collaboration Rules                                                                             |

## Setup

Prerequistes:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Mise-en-place](https://mise.jdx.dev/)

Execute the following:

```
cp env.template .env
# No configuration required
script/setup
```

## Notebooks

To see examples of invoking actions on context module, run the notebooks:

- Install LiveBook: https://github.com/livebook-dev/livebook#escript
- Run LiveBook: `livebook server ./apps/nomify/notebooks/`
- Run application, e.g.: `iex --name test@127.0.0.1 --cookie mycookie -S mix`
- Select Runtime settings, keyboard shortcut `sr` and configure to connect
