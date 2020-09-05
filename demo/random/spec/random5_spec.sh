Describe "random5_spec.sh"
  Example "random 5"
    When call echo "random"
    The output should eq "random"
  End
End
