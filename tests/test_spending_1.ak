use validators.SpendingValidator1

test successful_unlock {
  let datum = { buyer: #"abcd", deadline: 100 }
  let ctx = Mock.context()
    |> Mock.sign_as(#"abcd")
    |> Mock.with_time(150)

  SpendingValidator1.validate(datum, unit, ctx)
}

test fail_no_signature {
  let datum = { buyer: #"abcd", deadline: 100 }
  let ctx = Mock.context()
    |> Mock.with_time(150)

  !SpendingValidator1.validate(datum, unit, ctx)
}

test fail_deadline {
  let datum = { buyer: #"abcd", deadline: 200 }
  let ctx = Mock.context()
    |> Mock.sign_as(#"abcd")
    |> Mock.with_time(150)

  !SpendingValidator1.validate(datum, unit, ctx)
}
