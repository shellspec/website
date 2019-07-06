Describe "Sample specfile"
  Describe "hello()"
    Include ./lib/lib.sh
    It "puts greeting"
      When call hello world
      The output should eq "hello world"
    End
    It "puts greeting"
      When call hello world
      The output should eq "hello world"
    End
    It "puts greeting"
      When call hello world
      The output should eq "hello world"
    End
    It "puts greeting"
      When call hello world
      The output should eq "hello world"
    End
    It "puts greeting"
      When call hello world
      The output should eq "hello world"
    End
  End
End
