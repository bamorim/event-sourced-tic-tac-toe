# Event Sourcing
## What it is?

---

# Store events, not the final state

---

# Traditional

```elixir
demodule Account do
  def deposit(%Account{balance: b}, amount) do
    %Account{balance: b+amount}
  end
end
```

---

# Tradicional

```elixir
account = DB.deposit(id)
new_account = Account.deposit(account, 10)
DB.save(id, new_account)
```

---

# Event Sourced

```elixir
demodule Account do
  def deposit(%Account{}, amount) do
    %MoneyDeposited{amount: amount}
  end
end
```

---

# Event Sourced
## How to know the current balance?

```elixir
defmodule Account do
  def apply(account, event) do
    %{account | balance: account.balance + event.amount
  end
end
```

---

# Event Sourced

```elixir
saved_events = EventStore.get(id)
account = saved_events
  |> List.foldl(%Account{}, &(Account.apply(&1, &2)))
new_event = Account.deposit(account, 10)
EventStore.save(id, new_event)
```
---

# Events are immutable and definitive
## It is something that happened, a fact

---

# Domain Conditions in ES
## They should not go in the apply function

```elixir
demodule Account do
  def withdraw(%Account{balance: b}, amount) do
    if b >= amount do
      %MoneyWithdrawn{amount: amount}
    else
      nil
    end
  end
end
```
---

# CQRS
## Command Query Responsability Segregation

Writes and Reads (Commands and Queries) are totally different and you can (and that's a great idea) have different domain models.

---

# Commands
## A request to do something (i.e.: WithdrawMoney)

---

# Commands vs Events

## Commands

* They are requests that may or may not result in new events.
* Can "fail"
* Can trigger side effects
* Imperative Verbs (WithdrawMoney)

## Events

* Never fail (the apply function)
* States something that happened on the past
* Can be "replayed" without side effects
* Past-Participle Verb (MoneyWithdrawn)

---

# Let's play a game: Tic Tac Toe

---

# Tic Tac Toe
## Commands

* StartGame
* PlayMove

## Events

* GameStarted
* MovePlayed
* GameFinished

---

# Tic Tac Toe
## Requirements

* The server can hold many games at once
* Cannot send moves to a finished game
* We can have some win statistics
* We can check the state or result of a game