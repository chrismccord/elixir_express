# All Aboard The Elixir Express!
Elixir provides the joy and productivity of Ruby with the concurrency and fault-tolerance of Erlang. Together, we'll take a guided tour through the language, going from the very basics to macros and distributed programming. Along the way, we'll see how Elixir embraces concurrency and how we can construct self-healing programs that restart automatically on failure. Attendees should leave with a great head-start into Elixir, some minor language envy, and a strong desire to continue exploration.

## What is Erlang?

Erlang is a functional language with focuses on concurrency and fault tolerance. It first appeared in 1986 as part of Ericsson's quest to build fault tolerant, scalable telecommunication systems. It was open-sourced in 1998 and has gone on to power large portions of the worlds telecom systems, in addition to some of the most popular online services.

## Why Elixir?

Elixir is a language built on top of the Erlang VM. Elixir exists with the goal to build concurrent, distributed, fault-tolerant systems with productive and powerful language features. Mainstream languages were constructed around limited CPUs, threading, and shared-everything state. This concurrency model can become fragile and can make concurrent programs difficult to reason about. Other languages skirt these issues by running on a single CPU with multiple processes to achieve concurrency; however, as Moore's Law pushes us towards increasing multicore CPUs, this approach becomes unmanageable. Elixir's immutable state, Actors, and processes produce a concurrency model that is easy to reason about and allows code to be written distributively without extra fanfare. Additionally, by building on top of Erlang, Elixir can take advantage of all the libraries and advantages that the Erlang ecosystem has to offer.
