module OffersHelper
  def quotes_number_badge(number_of_quotes)
    klass_suffix = (number_of_quotes == 0) ? 'important' : 'info'
    content_tag(:span, number_of_quotes, class: "badge badge-#{klass_suffix}")
  end

  def link_to_add_variant(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id, defaults: { label: false, wrapper_html: { class: 'income_variant_field' }, input_html: { class:'input-mini' } } ) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "btn btn-info add_variant", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_add_quote(name, f, association, index) 
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id, defaults: { wrapper_html: {class: 'quote_field'}, input_html: { class:'input-mini' } } ) do |builder|
      builder.object.id = id
      render(association.to_s.singularize + "_fields", f: builder, i: index)
    end
    new_tab = content_tag(:li, content_tag(:a, "New Quote", href: "#quote#{id}", data: { toggle: "tab" }, id: "q_#{id}_tab"))
    link_to(name, '#', class: "btn add_quote", data: {id: id, fields: fields.gsub("\n", ""), tab: new_tab.gsub("\n", "")} )
  end
end