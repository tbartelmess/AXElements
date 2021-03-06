# -*- coding: utf-8 -*-
class TestAXApplication < TestAX

  APP = AX::Application.new REF, AX.attrs_of_element(REF)

  def test_is_a_direct_subclass_of_element
    assert_equal AX::Element, AX::Application.superclass
  end

  def app inst
    inst.instance_variable_get :@app
  end

  def test_can_set_focus_to_an_app
    app(APP).hide
    sleep 0.2
    refute APP.active?
    APP.set_attribute :focused, true
    sleep 0.2
    assert APP.active?
  ensure
    app(APP).activateWithOptions NSApplicationActivateIgnoringOtherApps
  end

  def test_can_hide_the_app
    APP.set_attribute :focused, false
    sleep 0.2
    refute APP.active?
  ensure
    app(APP).activateWithOptions NSApplicationActivateIgnoringOtherApps
  end

  def test_attribute_has_special_case_for_focused
    assert_instance_of_boolean APP.attribute :focused?
    assert_instance_of_boolean APP.attribute :focused
  end

  def test_attribute_still_works_for_other_attributes
    assert_equal 'AXElementsTester', APP.title
  end

  def test_inspect_includes_pid
    assert_match /\spid=\d+/, APP.inspect
  end

  def test_inspect_includes_focused
    assert_match /\sfocused\[(?:✔|✘)\]/, APP.inspect
  end

  def test_type_string_forwards_call
    class << AX
      alias_method :old_keyboard_action, :keyboard_action
      def keyboard_action element, string
        true if string == 'test' && element == TestAX::REF
      end
    end
    assert APP.type_string('test')
  ensure
    class << AX; alias_method :keyboard_action, :old_keyboard_action; end
  end

  def test_terminate_kills_app
    skip 'Not sure how to reset state after this test...'
    assert AX::DOCK.terminate
  end

  def test_dock_constant_is_set
    assert_instance_of AX::Application, AX::DOCK
    assert_equal 'Dock', AX::DOCK.attribute(:title)
  end

end
