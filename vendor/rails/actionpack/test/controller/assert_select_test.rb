#--
# Copyright (c) 2006 Assaf Arkin (http://labnotes.org)
# Under MIT and/or CC By license.
#++

require File.dirname(__FILE__) + '/../abstract_unit'
require File.dirname(__FILE__) + '/fake_controllers'


unless defined?(ActionMailer)
  begin
    $:.unshift(File.dirname(__FILE__) + "/../../../actionmailer/lib")
    require 'action_mailer'
  rescue LoadError
    require 'rubygems'
    gem 'actionmailer'
  end
end

class AssertSelectTest < Test::Unit::TestCase
  class AssertSelectController < ActionController::Base
    def response_with=(content)
      @content = content
    end

    def response_with(&block)
      @update = block
    end

    def html()
      render :text=>@content, :layout=>false, :content_type=>Mime::HTML
      @content = nil
    end

    def rjs()
      render :update do |page|
        @update.call page
      end
      @update = nil
    end

    def xml()
      render :text=>@content, :layout=>false, :content_type=>Mime::XML
      @content = nil
    end

    def rescue_action(e)
      raise e
    end
  end

  class AssertSelectMailer < ActionMailer::Base
    def test(html)
      recipients "test <test@test.host>"
      from "test@test.host"
      subject "Test e-mail"
      part :content_type=>"text/html", :body=>html
    end
  end

  AssertionFailedError = Test::Unit::AssertionFailedError

  def setup
    @controller = AssertSelectController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end


  def teardown
    ActionMailer::Base.deliveries.clear
  end


  #
  # Test assert select.
  #

  def test_assert_select
    render_html %Q{<div id="1"></div><div id="2"></div>}
    assert_select "div", 2
    assert_raises(AssertionFailedError) { assert_select "div", 3 }
    assert_raises(AssertionFailedError){ assert_select "p" }
  end


  def test_equality_true_false
    render_html %Q{<div id="1"></div><div id="2"></div>}
    assert_nothing_raised               { assert_select "div" }
    assert_raises(AssertionFailedError) { assert_select "p" }
    assert_nothing_raised               { assert_select "div", true }
    assert_raises(AssertionFailedError) { assert_select "p", true }
    assert_raises(AssertionFailedError) { assert_select "div", false }
    assert_nothing_raised               { assert_select "p", false }
  end


  def test_equality_string_and_regexp
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    assert_nothing_raised               { assert_select "div", "foo" }
    assert_raises(AssertionFailedError) { assert_select "div", "bar" }
    assert_nothing_raised               { assert_select "div", :text=>"foo" }
    assert_raises(AssertionFailedError) { assert_select "div", :text=>"bar" }
    assert_nothing_raised               { assert_select "div", /(foo|bar)/ }
    assert_raises(AssertionFailedError) { assert_select "div", /foobar/ }
    assert_nothing_raised               { assert_select "div", :text=>/(foo|bar)/ }
    assert_raises(AssertionFailedError) { assert_select "div", :text=>/foobar/ }
    assert_raises(AssertionFailedError) { assert_select "p", :text=>/foobar/ }
  end


  def test_equality_of_html
    render_html %Q{<p>\n<em>"This is <strong>not</strong> a big problem,"</em> he said.\n</p>}
    text = "\"This is not a big problem,\" he said."
    html = "<em>\"This is <strong>not</strong> a big problem,\"</em> he said."
    assert_nothing_raised               { assert_select "p", text }
    assert_raises(AssertionFailedError) { assert_select "p", html }
    assert_nothing_raised               { assert_select "p", :html=>html }
    assert_raises(AssertionFailedError) { assert_select "p", :html=>text }
    # No stripping for pre.
    render_html %Q{<pre>\n<em>"This is <strong>not</strong> a big problem,"</em> he said.\n</pre>}
    text = "\n\"This is not a big problem,\" he said.\n"
    html = "\n<em>\"This is <strong>not</strong> a big problem,\"</em> he said.\n"
    assert_nothing_raised               { assert_select "pre", text }
    assert_raises(AssertionFailedError) { assert_select "pre", html }
    assert_nothing_raised               { assert_select "pre", :html=>html }
    assert_raises(AssertionFailedError) { assert_select "pre", :html=>text }
  end


  def test_equality_of_instances
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    assert_nothing_raised               { assert_select "div", 2 }
    assert_raises(AssertionFailedError) { assert_select "div", 3 }
    assert_nothing_raised               { assert_select "div", 1..2 }
    assert_raises(AssertionFailedError) { assert_select "div", 3..4 }
    assert_nothing_raised               { assert_select "div", :count=>2 }
    assert_raises(AssertionFailedError) { assert_select "div", :count=>3 }
    assert_nothing_raised               { assert_select "div", :minimum=>1 }
    assert_nothing_raised               { assert_select "div", :minimum=>2 }
    assert_raises(AssertionFailedError) { assert_select "div", :minimum=>3 }
    assert_nothing_raised               { assert_select "div", :maximum=>2 }
    assert_nothing_raised               { assert_select "div", :maximum=>3 }
    assert_raises(AssertionFailedError) { assert_select "div", :maximum=>1 }
    assert_nothing_raised               { assert_select "div", :minimum=>1, :maximum=>2 }
    assert_raises(AssertionFailedError) { assert_select "div", :minimum=>3, :maximum=>4 }
  end


  def test_substitution_values
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    assert_select "div#?", /\d+/ do |elements|
      assert_equal 2, elements.size
    end
    assert_select "div" do
      assert_select "div#?", /\d+/ do |elements|
        assert_equal 2, elements.size
        assert_select "#1"
        assert_select "#2"
      end
    end
  end

  
  def test_nested_assert_select
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    assert_select "div" do |elements|
      assert_equal 2, elements.size
      assert_select elements[0], "#1"
      assert_select elements[1], "#2"
    end
    assert_select "div" do
      assert_select "div" do |elements|
        assert_equal 2, elements.size
        # Testing in a group is one thing
        assert_select "#1,#2"
        # Testing individually is another.
        assert_select "#1"
        assert_select "#2"
        assert_select "#3", false
      end
    end
  end


  def test_assert_select_text_match
    render_html %Q{<div id="1"><span>foo</span></div><div id="2"><span>bar</span></div>}
    assert_select "div" do
      assert_nothing_raised               { assert_select "div", "foo" }
      assert_nothing_raised               { assert_select "div", "bar" }
      assert_nothing_raised               { assert_select "div", /\w*/ }
      assert_nothing_raised               { assert_select "div", /\w*/, :count=>2 }
      assert_raises(AssertionFailedError) { assert_select "div", :text=>"foo", :count=>2 }
      assert_nothing_raised               { assert_select "div", :html=>"<span>bar</span>" }
      assert_nothing_raised               { assert_select "div", :html=>"<span>bar</span>" }
      assert_nothing_raised               { assert_select "div", :html=>/\w*/ }
      assert_nothing_raised               { assert_select "div", :html=>/\w*/, :count=>2 }
      assert_raises(AssertionFailedError) { assert_select "div", :html=>"<span>foo</span>", :count=>2 }
    end
  end


  # With single result.
  def test_assert_select_from_rjs_with_single_result
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>\n<div id=\"2\">foo</div>"
    end
    assert_select "div" do |elements|
      assert elements.size == 2
      assert_select "#1"
      assert_select "#2"
    end
    assert_select "div#?", /\d+/ do |elements|
      assert_select "#1"
      assert_select "#2"
    end
  end

  # With multiple results.
  def test_assert_select_from_rjs_with_multiple_results
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">foo</div>"
    end
    assert_select "div" do |elements|
      assert elements.size == 2
      assert_select "#1"
      assert_select "#2"
    end
  end


  #
  # Test css_select.
  #


  def test_css_select
    render_html %Q{<div id="1"></div><div id="2"></div>}
    assert 2, css_select("div").size
    assert 0, css_select("p").size
  end


  def test_nested_css_select
    render_html %Q{<div id="1">foo</div><div id="2">foo</div>}
    assert_select "div#?", /\d+/ do |elements|
      assert_equal 1, css_select(elements[0], "div").size
      assert_equal 1, css_select(elements[1], "div").size
    end
    assert_select "div" do
      assert_equal 2, css_select("div").size
      css_select("div").each do |element|
        # Testing as a group is one thing
        assert !css_select("#1,#2").empty?
        # Testing individually is another
        assert !css_select("#1").empty?
        assert !css_select("#2").empty?
      end
    end
  end


  # With one result.
  def test_css_select_from_rjs_with_single_result
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>\n<div id=\"2\">foo</div>"
    end
    assert_equal 2, css_select("div").size
    assert_equal 1, css_select("#1").size
    assert_equal 1, css_select("#2").size
  end

  # With multiple results.
  def test_css_select_from_rjs_with_multiple_results
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">foo</div>"
    end

    assert_equal 2, css_select("div").size
    assert_equal 1, css_select("#1").size
    assert_equal 1, css_select("#2").size
  end


  #
  # Test assert_select_rjs.
  #


  # Test that we can pick up all statements in the result.
  def test_assert_select_rjs_picks_up_all_statements
    render_rjs do |page|
      page.replace "test", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">foo</div>"
      page.insert_html :top, "test3", "<div id=\"3\">foo</div>"
    end

    found = false
    assert_select_rjs do
      assert_select "#1"
      assert_select "#2"
      assert_select "#3"
      found = true
    end
    assert found
  end

  # Test that we fail if there is nothing to pick.
  def test_assert_select_rjs_fails_if_nothing_to_pick
    render_rjs { }
    assert_raises(AssertionFailedError) { assert_select_rjs }
  end

  def test_assert_select_rjs_with_unicode
    # Test that non-ascii characters (which are converted into \uXXXX in RJS) are decoded correctly.
    render_rjs do |page|
      page.replace "test", "<div id=\"1\">\343\203\201\343\202\261\343\203\203\343\203\210</div>"
    end
    assert_select_rjs do
      assert_select "#1", :text => "\343\203\201\343\202\261\343\203\203\343\203\210"
      assert_select "#1", "\343\203\201\343\202\261\343\203\203\343\203\210"
      assert_select "#1", Regexp.new("\343\203\201..\343\203\210",0,'U')
      assert_raises(AssertionFailedError) { assert_select "#1", Regexp.new("\343\203\201.\343\203\210",0,'U') }
    end
  end

  def test_assert_select_rjs_with_id
    # Test that we can pick up all statements in the result.
    render_rjs do |page|
      page.replace "test1", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">foo</div>"
      page.insert_html :top, "test3", "<div id=\"3\">foo</div>"
    end
    assert_select_rjs "test1" do
      assert_select "div", 1
      assert_select "#1"
    end
    assert_select_rjs "test2" do
      assert_select "div", 1
      assert_select "#2"
    end
    assert_select_rjs "test3" do
      assert_select "div", 1
      assert_select "#3"
    end
    assert_raises(AssertionFailedError) { assert_select_rjs "test4" }
  end


  def test_assert_select_rjs_for_replace
    render_rjs do |page|
      page.replace "test1", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">foo</div>"
      page.insert_html :top, "test3", "<div id=\"3\">foo</div>"
    end
    # Replace.
    assert_select_rjs :replace do
      assert_select "div", 1
      assert_select "#1"
    end
    assert_select_rjs :replace, "test1" do
      assert_select "div", 1
      assert_select "#1"
    end
    assert_raises(AssertionFailedError) { assert_select_rjs :replace, "test2" }
    # Replace HTML.
    assert_select_rjs :replace_html do
      assert_select "div", 1
      assert_select "#2"
    end
    assert_select_rjs :replace_html, "test2" do
      assert_select "div", 1
      assert_select "#2"
    end
    assert_raises(AssertionFailedError) { assert_select_rjs :replace_html, "test1" }
  end

  def test_assert_select_rjs_for_chained_replace
    render_rjs do |page|
      page['test1'].replace "<div id=\"1\">foo</div>"
      page['test2'].replace_html "<div id=\"2\">foo</div>"
      page.insert_html :top, "test3", "<div id=\"3\">foo</div>"
    end
    # Replace.
    assert_select_rjs :chained_replace do
      assert_select "div", 1
      assert_select "#1"
    end
    assert_select_rjs :chained_replace, "test1" do
      assert_select "div", 1
      assert_select "#1"
    end
    assert_raises(AssertionFailedError) { assert_select_rjs :chained_replace, "test2" }
    # Replace HTML.
    assert_select_rjs :chained_replace_html do
      assert_select "div", 1
      assert_select "#2"
    end
    assert_select_rjs :chained_replace_html, "test2" do
      assert_select "div", 1
      assert_select "#2"
    end
    assert_raises(AssertionFailedError) { assert_select_rjs :replace_html, "test1" }
  end

  # Non-positioned insert.
  def test_assert_select_rjs_for_nonpositioned_insert
    render_rjs do |page|
      page.replace "test1", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">foo</div>"
      page.insert_html :top, "test3", "<div id=\"3\">foo</div>"
    end
    assert_select_rjs :insert_html do
      assert_select "div", 1
      assert_select "#3"
    end
    assert_select_rjs :insert_html, "test3" do
      assert_select "div", 1
      assert_select "#3"
    end
    assert_raises(AssertionFailedError) { assert_select_rjs :insert_html, "test1" }
  end

  # Positioned insert.
  def test_assert_select_rjs_for_positioned_insert
    render_rjs do |page|
      page.insert_html :top, "test1", "<div id=\"1\">foo</div>"
      page.insert_html :bottom, "test2", "<div id=\"2\">foo</div>"
      page.insert_html :before, "test3", "<div id=\"3\">foo</div>"
      page.insert_html :after, "test4", "<div id=\"4\">foo</div>"
    end
    assert_select_rjs :insert, :top do
      assert_select "div", 1
      assert_select "#1"
    end
    assert_select_rjs :insert, :bottom do
      assert_select "div", 1
      assert_select "#2"
    end
    assert_select_rjs :insert, :before do
      assert_select "div", 1
      assert_select "#3"
    end
    assert_select_rjs :insert, :after do
      assert_select "div", 1
      assert_select "#4"
    end
    assert_select_rjs :insert_html do
      assert_select "div", 4
    end
  end


  # Simple selection from a single result.
  def test_nested_assert_select_rjs_with_single_result
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>\n<div id=\"2\">foo</div>"
    end

    assert_select_rjs "test" do |elements|
      assert_equal 2, elements.size
      assert_select "#1"
      assert_select "#2"
    end
  end

  # Deal with two results.
  def test_nested_assert_select_rjs_with_two_results
    render_rjs do |page|
      page.replace_html "test", "<div id=\"1\">foo</div>"
      page.replace_html "test2", "<div id=\"2\">foo</div>"
    end

    assert_select_rjs "test" do |elements|
      assert_equal 1, elements.size
      assert_select "#1"
    end

    assert_select_rjs "test2" do |elements|
      assert_equal 1, elements.size
      assert_select "#2"
    end
  end


  def test_feed_item_encoded
    render_xml <<-EOF
<rss version="2.0">
  <channel>
    <item>
      <description>
        <![CDATA[
          <p>Test 1</p>
        ]]>
      </description>
    </item>
    <item>
      <description>
        <![CDATA[
          <p>Test 2</p>
        ]]>
      </description>
    </item>
  </channel>
</rss>
EOF
    assert_select "channel item description" do
      # Test element regardless of wrapper.
      assert_select_encoded do
        assert_select "p", :count=>2, :text=>/Test/
      end
      # Test through encoded wrapper.
      assert_select_encoded do
        assert_select "encoded p", :count=>2, :text=>/Test/
      end
      # Use :root instead (recommended)
      assert_select_encoded do
        assert_select ":root p", :count=>2, :text=>/Test/
      end
      # Test individually.
      assert_select "description" do |elements|
        assert_select_encoded elements[0] do
          assert_select "p", "Test 1"
        end
        assert_select_encoded elements[1] do
          assert_select "p", "Test 2"
        end
      end
    end

    # Test that we only un-encode element itself.
    assert_select "channel item" do
      assert_select_encoded do
        assert_select "p", 0
      end
    end
  end


  #
  # Test assert_select_email
  #

  def test_assert_select_email
    assert_raises(AssertionFailedError) { assert_select_email {} }
    AssertSelectMailer.deliver_test "<div><p>foo</p><p>bar</p></div>"
    assert_select_email do
      assert_select "div:root" do
        assert_select "p:first-child", "foo"
        assert_select "p:last-child", "bar"
      end
    end
  end


  protected
    def render_html(html)
      @controller.response_with = html
      get :html
    end

    def render_rjs(&block)
      @controller.response_with &block
      get :rjs
    end

    def render_xml(xml)
      @controller.response_with = xml
      get :xml
    end
end
