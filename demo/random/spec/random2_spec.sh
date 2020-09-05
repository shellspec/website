Describe "random2_spec.sh"
  Example "random 2"
    When call echo "random"
    The output should eq "random"
  End
End