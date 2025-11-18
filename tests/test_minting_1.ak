use validators.MintingValidator1

test mint_success {
  let ctx = Mock.context()
    |> Mock.sign_as(MintingValidator1.AUTHORIZED_MINTER)
    |> Mock.mint("AccessNFT", 1)

  MintingValidator1.validate(unit, ctx)
}

test fail_unauthorized {
  let ctx = Mock.context()
    |> Mock.sign_as(#"deadbeef")
    |> Mock.mint("AccessNFT", 1)

  !MintingValidator1.validate(unit, ctx)
}

test fail_wrong_amount {
  let ctx = Mock.context()
    |> Mock.sign_as(MintingValidator1.AUTHORIZED_MINTER)
    |> Mock.mint("AccessNFT", 2)

  !MintingValidator1.validate(unit, ctx)
}

test fail_wrong_token_name {
  let ctx = Mock.context()
    |> Mock.sign_as(MintingValidator1.AUTHORIZED_MINTER)
    |> Mock.mint("WrongToken", 1)

  !MintingValidator1.validate(unit, ctx)
}

test fit_resource_limits {
  let ctx = Mock.context()
    |> Mock.sign_as(MintingValidator1.AUTHORIZED_MINTER)
    |> Mock.mint("AccessNFT", 1)

  MintingValidator1.validate(unit, ctx)
}
