Describe "random4_spec.sh"
  Example "random 4"
    When call echo "random"
    The output should eq "random"
  End
End
