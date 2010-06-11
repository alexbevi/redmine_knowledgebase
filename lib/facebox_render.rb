# FaceboxRender plugin for use with Prototype Facebox
module FaceboxRender
  def render_to_facebox(options = {})
    options[:template] = "#{default_template_name}" if options.empty?

    logger.info(options[:template])
    
    action_string = render_to_string(:action => options[:action], :layout => false) if options[:action]
    template_string = render_to_string(:template => options[:template], :layout => false) if options[:template]
    
    render :update do |page|

      page << "facebox.reveal(#{action_string.to_json})" if options[:action]
      page << "facebox.reveal(#{template_string.to_json})" if options[:template]
      page << "facebox.reveal(#{(render :partial => options[:partial]).to_json})" if options[:partial]
      page << "facebox.reveal(#{options[:html].to_json})" if options[:html]
      
      if options[:msg]
        page << "if( !$('facebox_message')){"
        page << "$('facebox_content').insert({top: '<div id=facebox_message>#{options[:msg]}</div>'});"
        page << "}"
      end

      yield(page) if block_given?
    end
  end

  def close_facebox
    render :update do |page|
      page << 'facebox.close();'
      yield(page) if block_given?
    end
  end

  def redirect_from_facebox(url)
    render :update do |page|
      page.redirect_to url
    end
  end
end