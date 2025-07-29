test_that("DTM API subscription key set as environmental variable.", {
  skip_on_cran()

  env_var_before_call <- Sys.getenv()["DTM_SUBSCRIPTION_KEY"] |> as.vector()

  subscription_key_input <- "dummyValue"
  set_subscription_key(key = subscription_key_input)
  
  # as.vector() is used to remove all attributes including names.
  env_var_after_call <- Sys.getenv()["DTM_SUBSCRIPTION_KEY"] |> as.vector()
  # Restore old env variable value to what it was before the function was tested.
  Sys.setenv("DTM_SUBSCRIPTION_KEY" = env_var_before_call)

  expect_true(env_var_after_call == subscription_key_input)
})
