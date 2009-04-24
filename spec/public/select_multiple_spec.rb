require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "select_multiple" do
  it "should submit all selected options" do
    with_html <<-HTML
      <html>
      <form method="post" action="/login">
        <select name="month[]" multiple="multiple"><option value="1">January</option><option value="2">February</option></select>
        <input type="submit" />
      </form>
      </html>
    HTML
    
    webrat_session.should_receive(:post).with("/login", "month" => ["1", "2"])
    select_multiple ["January", "February"], :from => "month[]"
    click_button
  end

  it "should work with old-style multiple selects" do
    with_html <<-HTML
      <html>
      <form method="post" action="/login">
        <select name="month[]" multiple><option value="1">January</option><option value="2">February</option></select>
        <input type="submit" />
      </form>
      </html>
    HTML
    
    webrat_session.should_receive(:post).with("/login", "month" => ["1", "2"])
    select_multiple ["January", "February"], :from => "month[]"
    click_button
  end
  
  it "should submit submit a single value" do
    with_html <<-HTML
      <html>
      <form method="post" action="/login">
        <select name="month[]" multiple="multiple"><option value="1">January</option><option value="2">February</option></select>
        <input type="submit" />
      </form>
      </html>
    HTML
    webrat_session.should_receive(:post).with("/login", "month" => ["1"])
    select_multiple ["January"], :from => "month[]"
    click_button
  end
  
  it "should fail if specified list not found" do
    with_html <<-HTML
      <html>
      <form method="get" action="/login">
        <select name="month[]" multiple="multiple"><option value="1">January</option></select>
      </form>
      </html>
    HTML

    lambda { select_multiple "February", :from => "year" }.should raise_error(Webrat::NotFoundError)
  end
  
  it "should send values with HTML encoded ampersands" do
    with_html <<-HTML
      <html>
      <form method="post" action="/login">
        <select name="encoded[]" multiple="multiple"><option value="A &amp; B">Encoded</option><option value="C &amp; D">Also Encoded</option></select>
        <input type="submit" />
      </form>
      </html>
    HTML
    webrat_session.should_receive(:post).with("/login", "encoded" => ["A & B", "C & D"])
    select_multiple ["Encoded", "Also Encoded"], :from => "encoded[]"
    click_button
  end
  
  it "should work without specifying the field name or label" do
    with_html <<-HTML
      <html>
      <form method="post" action="/login">
        <select name="month[]"><option value="1">January</option></select>
        <input type="submit" />
      </form>
      </html>
    HTML
    webrat_session.should_receive(:post).with("/login", "month" => ["1"])
    select_multiple "January"
    click_button
  end
  
end