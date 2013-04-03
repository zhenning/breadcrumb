module Breadcrumb

	class Railtie < Rails::Railtie
		initializer "imigu breadcrumb gem initialization" do
			return if ActionView::Base.instance_methods.include? 'breadcrumb'
			require 'breadcrumb/view_helpers'
			ActionView::Base.class_eval { include ViewHelpers }
		end
	end

end

