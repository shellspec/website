Describe "parallel5_spec.sh"
  It "sleep 1 seconds"
    When run sleep 1
    The status should be success
  End
End
