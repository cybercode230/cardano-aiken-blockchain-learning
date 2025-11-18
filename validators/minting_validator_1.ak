validator MintingValidator1 {
  type Redeemer = Unit

  const AUTHORIZED_MINTER: ByteArray =
    #"d83a5f204aab93f91f0cb90a0a123abcde90ff12"  // replace with real hash

  pub fn validate(_redeemer: Redeemer, ctx: ScriptContext) -> Bool {
    let info = ctx.transaction

    let authorized =
      trace_if_false("Verifying authorized minter", info.signer.hash == AUTHORIZED_MINTER)

    let mint_amount =
      trace_if_false("Checking mint amount", ctx.mint.value == 1)

    let token_name_ok =
      trace_if_false("Checking token name", ctx.mint.asset_name == "AccessNFT")

    trace_if_false("Minting successful", authorized && mint_amount && token_name_ok)
  }
}
