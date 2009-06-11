require "webrat/core_extensions/detect_mapped"
require "webrat/core/locators/select_option_locator"

module Webrat
  module Locators

    class SelectMultipleOptionsLocator < SelectOptionLocator # :nodoc:
      def initialize(session, dom, option_texts, id_or_name_or_label)
        @session = session
        @dom = dom
        @option_texts = Array(option_texts)
        @id_or_name_or_label = id_or_name_or_label
      end
      
      def locate
        if @id_or_name_or_label
          field = FieldLocator.new(@session, @dom, @id_or_name_or_label, MultipleSelectField).locate!
          @selected_options = field.options.select do |o|
            @option_texts.map{|option_text| option_text.to_s}.include?(Webrat::XML.inner_html(o.element))
          end
        else
          selected_options = option_elements.select do |o|
            @option_texts.map{|option_text| option_text.to_s}.include?(Webrat::XML.inner_html(o))
          end
          @selected_options = selected_options.map {|option_element| SelectOption.load(@session, option_element)}
        end
        self unless @selected_options.nil? || @selected_options.empty?
      end
      
      def choose
        @selected_options.each {|option| option.choose}
      end
    end
    
    def select_options(option_texts, id_or_name_or_label = nil) #:nodoc:
      SelectMultipleOptionsLocator.new(@session, dom, option_texts, id_or_name_or_label).locate!
    end
  end
end