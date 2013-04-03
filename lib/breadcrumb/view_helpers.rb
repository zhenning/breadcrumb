# -*- coding: utf-8 -*-
module ViewHelpers

  def breadcrumb(controller)
    return '' if Breadcrumb.disabled?
    
    crumbs = Breadcrumb.get(controller).clone
    
    return '' if crumbs.nil?
      
    html = (crumbs.map {|node| fmt_url(node)}).join(' › ')
    content_tag('h1', html.html_safe, :class => "box")
  end
  
  def meta_title(controler, site_name)
    crumbs = Breadcrumb.get(controller).clone 
    site = { :name => site_name, :url => root_path }
    crumbs.unshift site
    
    title = (crumbs.reverse!.collect { |crumb| crumb[:name] }).join(" - ")
    content_tag 'title', title
  end

  private
  def fmt_url(node)
    if (node[:url] != nil)
      url = url_for(node[:url])
      return '<a href="'.html_safe + url + '" title="'.html_safe + node[:name] + '">'.html_safe + node[:name] + '</a>'.html_safe
    else
      return node[:name]
    end
  end
end
