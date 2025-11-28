// validator SpendingValidator1 {
//   type Datum = {
//     buyer: ByteArray,
//     deadline: Int
//   }

//   type Redeemer = Unit

//   pub fn validate(datum: Datum, _redeemer: Redeemer, ctx: ScriptContext) -> Bool {
//     let info = ctx.transaction

//     let buyer_signed =
//       trace_if_false("Checking buyer signature", info.signer.hash == datum.buyer)

//     let deadline_passed =
//       trace_if_false("Checking deadline condition", ctx.current_time >= datum.deadline)

//     trace_if_false("Validation succeeded", buyer_signed && deadline_passed)
//   }
// }
