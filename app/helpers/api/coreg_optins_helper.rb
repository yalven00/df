module Api::CoregOptinsHelper

  def coreg_field_tag(coreg_param)
    case coreg_param.field_type
    when 'select'
      select_tag field_name(coreg_param), options_for_select(coreg_param.select_options.split(',').collect {|x| x.split(':')}), param_options(coreg_param)
    when 'date_select'
      date_select field_name(coreg_param), nil, param_options(coreg_param).merge({:prompt => true})
    when 'month_select'
      date_select field_name(coreg_param), nil, param_options(coreg_param).merge({:discard_day => true, :prompt => true})
    when 'password_field'
      password_field_tag field_name(coreg_param), nil, param_options(coreg_param)
    when 'radio_group'
      group_tag coreg_param, :radio_button_tag
    when 'checkbox_group'
      group_tag coreg_param, :check_box_tag
    else
      text_field_tag field_name(coreg_param), nil, param_options(coreg_param)
    end
  end

  def coreg_virtual_field_tag(coreg_param)
    hidden_field_tag field_name(coreg_param), nil, {:class => 'coreg_param', :data_coreg_param_id => coreg_param.id}
  end

  def virtual_coreg_params(coregs)
    @coregs.collect{|x| x.coreg_params}.flatten.select {|x| x.virtual? }
  end

  private
  def group_tag(coreg_param, type)
    content_html = coreg_param.children.collect do |child|
      field_html = self.send(type, field_name(child), child.value, false, param_options(child)).html_safe
      label_html = label_tag(field_name(child), child.label).html_safe
      content_tag :div, field_html + label_html, :class => "checkbox_group_item"
    end.join('')
    content_tag :div, content_html, {:class => "checkbox_group"}, false
  end

  def param_options(coreg_param)
    options = {:class => class_name(coreg_param)}
    options[:placeholder ] = 'Enter value...'
    options[:minlength] = coreg_param.min_length if coreg_param.min_length
    options[:data_coreg_param_id] = coreg_param.id
    options[:equalTo] = coreg_param.first_match if coreg_param.match? && coreg_param.display
    options[:include_blank] = coreg_param.select_prompt if !coreg_param.select_prompt.try(:blank?)
    if dependee = coreg_param.dependee
      dependee_div_name = "$('#\{input[name=\"#{field_name(dependee)}\"]}').parent('div').first()"
      options[:onchange] = "if($(this).val() == '#{dependee.dependent_value}') {#{dependee_div_name}.show();} else { #{dependee_div_name}.hide(); }"
    end
    options
  end

  def class_name(coreg_param)
    class_value = 'coreg_param'
    class_value += ' required' if coreg_param.required
    class_value
  end

  def field_name(coreg_param)
    field_name_string coreg_param.coreg.id, coreg_param.name
    #"coreg_optin[#{coreg_param.coreg.id}][coreg_param][#{coreg_param.name}]"
  end

  def field_name_string(coreg_id, param_name)
    "coreg_optin[#{coreg_id}][coreg_param][#{param_name}]"
  end
end
