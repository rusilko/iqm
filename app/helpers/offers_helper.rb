module OffersHelper
  def quotes_number_badge(number_of_quotes)
    klass_suffix = (number_of_quotes == 0) ? 'important' : 'info'
    content_tag(:span, number_of_quotes, class: "badge badge-#{klass_suffix}")
  end

  def link_to_add_quote(name, f, association, index) 
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id, defaults: { wrapper_html: {class: 'quote_field'}, input_html: { class:'input-mini' } } ) do |builder|
      builder.object.id = id
      render(association.to_s.singularize + "_fields", f: builder, i: index)
    end
    new_tab = content_tag(:li, content_tag(:a, "New Quote", href: "#quote#{id}", data: { toggle: "tab" }, id: "q_#{id}_tab"))
    link_to(name, '#', class: "btn btn-success", id: "add_quote_btn", data: {id: id, fields: fields.gsub("\n", ""), tab: new_tab.gsub("\n", "")} )
  end

  def link_to_add_variant(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id, defaults: { label: false, wrapper_html: { class: 'income_variant_field' }, input_html: { class:'input-mini' } } ) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "btn btn-success add_variant_btn", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_add_cost_item(name, f, association) 
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id, defaults: { label: false, wrapper_html: { class: 'cost_item_field' }, input_html: { class:'input_cost_item' } } ) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, i: raw("<i class=\"icon-star new_row_star\"></i>"))
    end
    link_to(name, '#', class: "btn btn-success add_cost_item_btn", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def field_with_prepend(builder, params_hash)
    p = params_hash
    text = p[:prepend_text] || p[:name]
    type = p[:type] || "text"
    as = p[:as]
    ct = content_tag(:span, raw(text.capitalize), class: 'add-on')+builder.input_field(p[:name], as: p[:as], class: p[:input_html_class], collection: p[:collection], type: type, step: p[:step])
    if p[:wrapper_html_class] 
      builder.input p[:name], label: false, wrapper: :prepend, wrapper_html: { class: p[:wrapper_html_class] } do
        ct
      end
    else
      builder.input p[:name], label: false, wrapper: :prepend  do
        ct
      end
    end
  end

  def iconize(string,white=false)
    icon_white = "icon-white" if white
    content_tag(:i, "", class: "icon-#{string} #{icon_white}")
  end

  def n_to_pln(n)
    number_to_currency(n, locale: 'pl', delimiter: '', separator: '.', precision: 2, unit: '')
  end
end