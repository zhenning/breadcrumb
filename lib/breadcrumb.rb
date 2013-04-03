require "breadcrumb/version"

module Breadcrumb

  # crumbs container
  @@crumbs = []
  
  # is crumb disabled for output
  @@disabled = false
  
  # is crumb initialised
  @@inited = false

  class << self
    
    # mixes in Breadcrumb::ViewHelpers in ActionView::Base
    def enable_helper
      return if ActionView::Base.instance_methods.include? 'breadcrumb'
      require 'breadcrumb/view_helpers'
      ActionView::Base.class_eval { include ViewHelpers }
    end
    
    def add(v)
      @@crumbs.push(v)
    end
    
    def disable
      @@disabled = true
    end
    
    def disabled?
      return @@disabled
    end
    
    def get(controller)
      if @@disabled
        return nil
      end
      init(controller) unless @@inited
      @@crumbs
    end
    
    def shift
      @@crumbs.shift
    end
    
    def merge(v, append = false)
      if append
        @@crumbs = @@crumbs + v
      else
        @crumbs = v + @@crumbs
      end
    end
    
    # reset on every request ensuring due to
    # class variables shared in each thread.
    def reset!
      @@crumbs = []
      @@disabled = false
      @@inited = false
    end
    
    private
    def init(controller)
      if @@inited 
        return
      end
      @@inited = true
      
      append = Array.new
      
      if (controller.respond_to?(:module_name) === true)
        module_name = controller.module_name
        controller_name = controller.controller_name
        
        append = [ { :name => module_name, :url => { :controller => controller_name, :action => 'index' } } ]
      end
      
      @@crumbs = append + @@crumbs
    end
    
  end
  
end

require "breadcrumb/railtie"
