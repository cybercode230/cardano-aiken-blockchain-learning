// -----------------------------------------------------------------------------
// Escrow Tests
// -----------------------------------------------------------------------------

test test_release_buyer_before_deadline() {
  let datum =
    Some(
      EscrowDatum {
        buyer: #"aaaa",
        seller: #"bbbb",
        amount: 5_000_000,
        deadline: 1000,
      },
    )

  // Valid signature by buyer
  let tx =
    mocktail_tx()
      |> invalid_before(True, 900)
      |> complete()
  let final_tx =
    Transaction {
      ..tx,
      extra_signatories: [#"aaaa"],
    }

  escrow_validator.spend(datum, ReleaseFunds, mock_utxo_ref(0, 0), final_tx)
}

test test_release_seller_before_deadline() {
  let datum =
    Some(
      EscrowDatum {
        buyer: #"aaaa",
        seller: #"bbbb",
        amount: 5_000_000,
        deadline: 1000,
      },
    )

  let tx =
    mocktail_tx()
      |> invalid_before(True, 900)
      |> complete()
  let final_tx =
    Transaction {
      ..tx,
      extra_signatories: [#"bbbb"],
    }

  escrow_validator.spend(datum, ReleaseFunds, mock_utxo_ref(0, 0), final_tx)
}

test test_refund_after_deadline() {
  let datum =
    Some(
      EscrowDatum {
        buyer: #"aaaa",
        seller: #"bbbb",
        amount: 5_000_000,
        deadline: 1000,
      },
    )

  let tx =
    mocktail_tx()
      |> invalid_before(True, 1500)
      |> complete()
  let final_tx =
    Transaction {
      ..tx,
      extra_signatories: [#"aaaa"],
    }

  escrow_validator.spend(datum, RefundBuyer, mock_utxo_ref(0, 0), final_tx)
}

// ------------------ FAILING TESTS -------------------------------------------

test test_refund_before_deadline_fails() fail {
  let datum =
    Some(
      EscrowDatum {
        buyer: #"aaaa",
        seller: #"bbbb",
        amount: 5_000_000,
        deadline: 1000,
      },
    )

  let tx =
    mocktail_tx()
      |> invalid_hereafter(True, 900)
      |> complete()
  let final_tx =
    Transaction {
      ..tx,
      extra_signatories: [#"aaaa"],
    }

  escrow_validator.spend(datum, RefundBuyer, mock_utxo_ref(0, 0), final_tx)
}

test test_wrong_signature_fails() fail {
  let datum =
    Some(
      EscrowDatum {
        buyer: #"aaaa",
        seller: #"bbbb",
        amount: 5_000_000,
        deadline: 1000,
      },
    )

  let tx =
    mocktail_tx()
      |> invalid_before(True, 900)
      |> complete()
  let final_tx =
    Transaction {
      ..tx,
      extra_signatories: [#"cccc"],
    }

  escrow_validator.spend(datum, ReleaseFunds, mock_utxo_ref(0, 0), final_tx)
}

test test_dispute_signature_success() {
  let datum =
    Some(
      EscrowDatum {
        buyer: #"aaaa",
        seller: #"bbbb",
        amount: 5_000_000,
        deadline: 1000,
      },
    )

  let tx = Transaction { ..placeholder, extra_signatories: [#"bbbb"] }

  escrow_validator.spend(datum, Dispute, mock_utxo_ref(0, 0), tx)
}
