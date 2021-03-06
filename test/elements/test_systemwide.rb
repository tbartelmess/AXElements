class TestAXSystemWide < MiniTest::Unit::TestCase

  def test_is_singleton
    assert_raises NoMethodError do
      AX::SystemWide.new
    end
    assert_respond_to AX::SystemWide, :instance
  end

  def test_type_string_makes_appropriate_callback
    class << AX
      alias_method :old_keyboard_action, :keyboard_action
      def keyboard_action element, string
        true if string == 'test' && element == AXUIElementCreateSystemWide()
      end
    end
    assert AX::SYSTEM.type_string('test')
  ensure
    class << AX; alias_method :keyboard_action, :old_keyboard_action; end
  end

  def test_search_not_allowed
    assert_raises NoMethodError do
      AX::SYSTEM.search
    end
  end

  def test_notifications_not_allowed
    assert_raises NoMethodError do
      AX::SYSTEM.search
    end
  end

  def test_expose_instance_as_constant
    assert_instance_of AX::SystemWide, AX::SYSTEM
  end

end
