Describe "random3_spec.sh"
  Example "random 3"
    When call echo "random"
    The output should eq "random"
  End
End
