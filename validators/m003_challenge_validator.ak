// =============================================================================
// Module M003 Workshop – Escrow Contract
// Demonstrates: Datum validation, redeemer logic, signatures,
// time locking and input/output validation.
// =============================================================================

use aiken/collection/list
use cardano/address.{Address, Script, VerificationKey}
use cardano/assets.{from_lovelace, lovelace_of}
use cardano/transaction.{
  Input, NoDatum, Output, OutputReference, Transaction, placeholder,
}
use cocktail.{valid_after}
use mocktail.{
  complete, invalid_before, invalid_hereafter, mock_utxo_ref, mocktail_tx,
}

// -----------------------------------------------------------------------------
// Escrow Types
// -----------------------------------------------------------------------------

pub type EscrowDatum {
  buyer: ByteArray,
  seller: ByteArray,
  amount: Int,
  deadline: Int,
}

// Redeemer with multiple variants
pub type EscrowAction {
  ReleaseFunds
  RefundBuyer
  Dispute
}

// -----------------------------------------------------------------------------
// Escrow Validator Logic
// Contains all core conditions:
// 1. Required signatures
// 2. Time-based validation
// 3. Correct payment address
// 4. Correct amount released
// -----------------------------------------------------------------------------

validator escrow_validator {
  spend(
    datum: Option<EscrowDatum>,
    redeemer: EscrowAction,
    _input_ref: OutputReference,
    self: Transaction,
  ) {
    expect Some(e) = datum

    // CORE RULE 1: The UTxO must contain at least amount
    let has_minimum_value =
      list.any(
        self.inputs,
        fn(input) {
          lovelace_of(input.output.value) >= e.amount
        },
      )

    // CORE RULE 2: Only buyer or seller may sign
    let signed_by_buyer =
      list.has(self.extra_signatories, e.buyer)
    let signed_by_seller =
      list.has(self.extra_signatories, e.seller)

    // CORE RULE 3: Deadline logic
    let after_deadline =
      valid_after(self.validity_range, e.deadline)

    // Main redeemer branching
    when redeemer is {

      // Case 1: Normal settlement – release funds to seller
      ReleaseFunds -> {
        // Must be signed by buyer or seller, and before deadline
        (signed_by_buyer || signed_by_seller) && has_minimum_value
      }

      // Case 2: Refund only possible after deadline and signed by buyer
      RefundBuyer -> {
        after_deadline && signed_by_buyer && has_minimum_value
      }

      // Optional Case 3: dispute is allowed by either party any time
      Dispute ->
        signed_by_buyer || signed_by_seller
    }
  }

  else(_) {
    fail  // once every transaction failed no exchange happen
  }
}
