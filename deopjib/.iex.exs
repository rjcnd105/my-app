require Ash.Query

alias DeopjibWebUI.{Layouts, Parts}
alias Monad.Result, as: R
alias Deopjib.{Settlement}
alias Deopjib.Settlement.{Room, Payer, PayItem, PayItemExcludedPayer}

import DeopjibUtils.Debug,
  only: [dbg_vget: 0, dbg_vget: 1, dbg_store: 1, dbg_store: 2, dbg_store: 3]

IO.puts("hello world")

first_room = Room |> Ash.read_first!() |> Ash.load!(:payers)
