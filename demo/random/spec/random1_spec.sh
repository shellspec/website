Describe "random1_spec.sh"
  Example "random 1"
    When call echo "random"
    The output should eq "random"
  End
End
