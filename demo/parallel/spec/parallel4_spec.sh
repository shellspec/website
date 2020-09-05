Describe "parallel4_spec.sh"
  It "sleep 2 seconds"
    When run sleep 2
    The status should be success
  End
End
