Describe 'calc.sh'
  . ./lib/calc.sh

  Describe 'add()'
    Example '1 + 1 = 2'
      When call add 1 1
      The output should equal 2
    End

    Example '1 + 10 = 11'
      When call add 1 10
      The output should equal 11
    End
  End

  Describe 'sub()'
    Example '1 - 1 = 0'
      When call sub 1 1
      The output should equal 0
    End

    Example '1 - 10 = -9'
      When call sub 1 10
      The output should equal -9
    End
  End

  Describe 'mul()'
    Example '1 * 1 = 1'
      When call mul 1 1
      The output should equal 1
    End

    Example '1 * 10 = 10'
      When call mul 1 10
      The output should equal 10
    End
  End

  Describe 'div()'
    Example '1 / 1 = 1'
      When call div 1 1
      The output should equal 1
    End

    Example '1 / 10 = 0.1'
      When call div 1 10
      The output should equal 0.1
    End
  End

  Describe 'add()'
    Example '1 + 1 = 2'
      When call add 1 1
      The output should equal 2
    End

    Example '1 + 10 = 11'
      When call add 1 10
      The output should equal 11
    End
  End

  Describe 'sub()'
    Example '1 - 1 = 0'
      When call sub 1 1
      The output should equal 0
    End

    Example '1 - 10 = -9'
      When call sub 1 10
      The output should equal -9
    End
  End

  Describe 'mul()'
    Example '1 * 1 = 1'
      When call mul 1 1
      The output should equal 1
    End

    Example '1 * 10 = 10'
      When call mul 1 10
      The output should equal 10
    End
  End
End
