Describe "parallel1_spec.sh"
  It "sleep 3 seconds"
    When run sleep 3
    The status should be success
  End
End
